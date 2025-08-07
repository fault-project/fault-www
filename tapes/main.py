import os
from typing import Optional

import httpx
from fastapi import FastAPI, Request, HTTPException
from pydantic import BaseModel, Field

app = FastAPI(
    title="Public IP Info API",
    version="1.0.0",
    description="Lookup geo/ISP/etc. information for a public IP address.",
    servers=[
        {
            "name": "dev",
            "url": "http://localhost:8000"
        }
    ]
)

# -------------------------------------------------------------------
# Pydantic model of the response from ip-api.com
# -------------------------------------------------------------------
class IPInfo(BaseModel):
    status: str
    country: Optional[str]
    countryCode: Optional[str]
    region: Optional[str]
    regionName: Optional[str]
    city: Optional[str]
    zip: Optional[str]
    lat: Optional[float]
    lon: Optional[float]
    timezone: Optional[str]
    isp: Optional[str]
    org: Optional[str]
    as_: Optional[str] = Field(None, alias="as")
    query: str

# -------------------------------------------------------------------
# Internal helper
# -------------------------------------------------------------------
async def fetch_ip_info(ip: str) -> IPInfo:
    """
    Query ip-api.com for IP information.
    Raises HTTPException if the remote API returns an error.
    """
    url = f"http://ip-api.com/json/{ip}"
    async with httpx.AsyncClient() as client:
        resp = await client.get(url)
    if resp.status_code != 200:
        raise HTTPException(
            status_code=502,
            detail=f"Upstream service returned status {resp.status_code}"
        )
    data = resp.json()
    # ip-api sets "status": "fail" on bad queries
    if data.get("status") != "success":
        msg = data.get("message", "unknown error")
        raise HTTPException(status_code=400, detail=f"IP lookup failed: {msg}")
    return IPInfo.parse_obj(data)

# -------------------------------------------------------------------
# Routes
# -------------------------------------------------------------------
@app.get("/ip", response_model=IPInfo)
async def get_own_ip_info(request: Request):
    """
    Return info about the client's public IP.
    If you're behind a proxy/load-balancer, set X-Forwarded-For.
    """
    client_host = request.client.host
    # honor X-Forwarded-For when present
    xff = request.headers.get("X-Forwarded-For")
    if xff:
        # take the leftmost IP
        client_ip = xff.split(",")[0].strip()
    else:
        client_ip = client_host

    return await fetch_ip_info(client_ip)


@app.get("/ip/{ip_addr}", response_model=IPInfo)
async def get_ip_info(ip_addr: str):
    """
    Return geo/ISP/etc. info for any public IP address.
    """
    # Basic sanity check
    if ip_addr.lower() == "localhost":
        raise HTTPException(status_code=400, detail="Localhost is not a public IP")
    return await fetch_ip_info(ip_addr)


# -------------------------------------------------------------------
# Optional root endpoint
# -------------------------------------------------------------------
@app.get("/")
def read_root():
    return {
        "message": "Welcome! Try GET /ip or GET /ip/{ip_addr}"
    }

# -------------------------------------------------------------------
# If you want to run with `python main.py`
# -------------------------------------------------------------------
if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=int(os.getenv("PORT", 8000)))
