---
title: Control DNS Responses
description: Control DNS Responses
---

# How to Control DNS Responses with <span class="f">fault</span>

This guide shows you how to control DNS responses and explore how a faulty
resolver may impact your operations.

!!! abstract "Prerequisites"

    -   [X] Install <span class="f">fault</span>

        If you haven’t installed <span class="f">fault</span> yet, follow the
        [installation instructions](../../install.md).

    -   [X] Install a DNS client

        Throughout this guide we will be using
        [dig](https://en.wikipedia.org/wiki/Dig_(command)). This CLI is
        readily available on Linux. Feel free to use any other client.

!!! note "Common flags"

    All the commands shown below may also take the following flags:

    * `--delay N` to slow down the reply coming back from the proxy implying
      the DNS server is slow

    * `--resolver X` is the address of the remote DNS resolver that will handle
      any queries that the proxy lets through. Defaults to `127.0.0.1:53`.

    * `--probability P` is the probability to apply the fault. Defaults to
      `1.0` which means always.

## NX Domain

-   [X] Inject NX Domain

    {==NXDOMAIN==} is DNS error indicating a domain doesn't exist, thus no IP is returned

    ```bash
    fault run dns --case nx-domain
    ```

    This will launch <span class="f">fault</span> and start a UDP proxy
    listening on port 45553 on all interfaces.

-   [X] Query an IP

    Let's use `dig` to query an IP for Google:

    ```bash
    dig @127.0.0.1 -p 45553 www.google.com
    ```

    Below is its response. Notice we didn't get an IP and the status
    of the response is set to `NXDOMAIN`.

    ```text
    ; <<>> DiG 9.20.0-2ubuntu3.2-Ubuntu <<>> @127.0.0.1 -p 45553 www.google.com
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 7430
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 0

    ;; QUESTION SECTION:
    ;www.google.com.			IN	A

    ;; Query time: 0 msec
    ;; SERVER: 127.0.0.1#45553(127.0.0.1) (UDP)
    ;; WHEN: Wed Aug 13 21:13:34 CEST 2025
    ;; MSG SIZE  rcvd: 32
    ```

## Server Fail

-   [X] Inject Server Fail

    {==SERVFAIL==} indicates the DNS server choked on the query.

    ```bash
    fault run dns  --case serv-fail
    ```

    This will launch <span class="f">fault</span> and start a UDP proxy
    listening on port 45553 on all interfaces.

-   [X] Query an IP

    Let's use `dig` to query an IP for Google:

    ```bash
    dig @127.0.0.1 -p 45553 www.google.com
    ```

    Below is its response. Notice we didn't get an IP and the status
    of the response is set to `SERVFAIL`.

    ```text
    ; <<>> DiG 9.20.0-2ubuntu3.2-Ubuntu <<>> @127.0.0.1 -p 45553 www.google.com
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: SERVFAIL, id: 45341
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 0

    ;; QUESTION SECTION:
    ;www.google.com.			IN	A

    ;; Query time: 0 msec
    ;; SERVER: 127.0.0.1#45553(127.0.0.1) (UDP)
    ;; WHEN: Wed Aug 13 21:18:34 CEST 2025
    ;; MSG SIZE  rcvd: 32
    ```

## Refused

-   [X] Inject Refused

    {==REFUSED==} indicates the DNS server refused to respond to the query.

    ```bash
    fault run dns  --case refused
    ```

    This will launch <span class="f">fault</span> and start a UDP proxy
    listening on port 45553 on all interfaces.

-   [X] Query an IP

    Let's use `dig` to query an IP for Google:

    ```bash
    dig @127.0.0.1 -p 45553 www.google.com
    ```

    Below is its response. Notice we didn't get an IP and the status
    of the response is set to `REFUSED`.

    ```text
    ; <<>> DiG 9.20.0-2ubuntu3.2-Ubuntu <<>> @127.0.0.1 -p 45553 www.google.com
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: REFUSED, id: 62200
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 0

    ;; QUESTION SECTION:
    ;www.google.com.			IN	A

    ;; Query time: 0 msec
    ;; SERVER: 127.0.0.1#45553(127.0.0.1) (UDP)
    ;; WHEN: Wed Aug 13 21:24:28 CEST 2025
    ;; MSG SIZE  rcvd: 32
    ```

## Timeout

-   [X] Inject Timeout

    {==TIMEOUT==} doesn't reply at all thus clients will stall, retry, and
    back off, turning quick lookups into slow user-visible delays.

    ```bash
    fault run dns  --case timeout
    ```

    This will launch <span class="f">fault</span> and start a UDP proxy
    listening on port 45553 on all interfaces.

-   [X] Query an IP

    Let's use `dig` to query an IP for Google:

    ```bash
    dig @127.0.0.1 -p 45553 www.google.com
    ```

    Below is its response. Notice we didn't get a response at all.

    ```text
    ;; Warning: query response not set

    ; <<>> DiG 9.20.0-2ubuntu3.2-Ubuntu <<>> @127.0.0.1 -p 45553 www.google.com
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 21569
    ;; flags: rd ad; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1
    ;; WARNING: recursion requested but not available

    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 1232
    ; COOKIE: 2e271e10f0a464e0 (echoed)
    ;; QUESTION SECTION:
    ;www.google.com.			IN	A

    ;; Query time: 801 msec
    ;; SERVER: 127.0.0.1#45553(127.0.0.1) (UDP)
    ;; WHEN: Wed Aug 13 21:25:44 CEST 2025
    ;; MSG SIZE  rcvd: 55
    ```

## Delay

-   [X] Inject Delay in Responses

    {==DELAY==} replies late on purpose increasing latency.

    ```bash
    fault run dns --case delay --delay 200ms
    ```

    This will launch <span class="f">fault</span> and start a UDP proxy
    listening on port 45553 on all interfaces.

-   [X] Query an IP

    Let's use `dig` to query an IP for Google:

    ```bash
    dig @127.0.0.1 -p 45553 www.google.com
    ```

    Below is its response. Notce

    ```text
    ; <<>> DiG 9.20.0-2ubuntu3.2-Ubuntu <<>> @127.0.0.1 -p 45553 www.google.com
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 29492
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 512
    ;; QUESTION SECTION:
    ;www.google.com.			IN	A

    ;; ANSWER SECTION:
    www.google.com.		278	IN	A	142.250.178.132

    ;; Query time: 815 msec
    ;; SERVER: 127.0.0.1#45553(127.0.0.1) (UDP)
    ;; WHEN: Wed Aug 13 22:47:59 CEST 2025
    ;; MSG SIZE  rcvd: 59
    ```

## Truncated

-   [X] Inject Truncated Response

    {==TRUNCATED==} replies with a response that doesn't fit in UDP.

    ```bash
    fault run dns --case truncated
    ```

    This will launch <span class="f">fault</span> and start a UDP proxy
    listening on port 45553 on all interfaces.

-   [X] Query an IP

    Let's use `dig` to query an IP for Google:

    ```bash
    dig @127.0.0.1 -p 45553 www.google.com
    ```

    Below is its response.

    ```text
    ;; Truncated, retrying in TCP mode.
    ;; Connection to 127.0.0.1#45553(127.0.0.1) for www.google.com failed: connection refused.
    ;; no servers could be reached

    ;; Connection to 127.0.0.1#45553(127.0.0.1) for www.google.com failed: connection refused.
    ;; no servers could be reached

    ;; Connection to 127.0.0.1#45553(127.0.0.1) for www.google.com failed: connection refused.
    ;; no servers could be reached
    ```

## Random `A`

-   [X] Inject Random A IP

    {==RANDOM A==} replies with a random IPv4 address.

    ```bash
    fault run dns --case random-a
    ```

    This will launch <span class="f">fault</span> and start a UDP proxy
    listening on port 45553 on all interfaces.

-   [X] Query an IP

    Let's use `dig` to query an IP for Google:

    ```bash
    dig @127.0.0.1 -p 45553 www.google.com
    ```

    Below is its response. Notice the returned IP was randomly generated
    and doesn't actually match a Google address.

    ```text
    ; <<>> DiG 9.20.0-2ubuntu3.2-Ubuntu <<>> @127.0.0.1 -p 45553 www.google.com
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 28240
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

    ;; QUESTION SECTION:
    ;www.google.com.			IN	A

    ;; ANSWER SECTION:
    www.google.com.		30	IN	A	235.253.117.73

    ;; Query time: 0 msec
    ;; SERVER: 127.0.0.1#45553(127.0.0.1) (UDP)
    ;; WHEN: Wed Aug 13 21:32:38 CEST 2025
    ;; MSG SIZE  rcvd: 48

    ```

## Empty Answer

-   [X] Inject Empty Answer

    {==EMPTY ANSWER==} replies correctly but without a match.

    ```bash
    fault run dns --case random-a
    ```

    This will launch <span class="f">fault</span> and start a UDP proxy
    listening on port 45553 on all interfaces.

-   [X] Query an IP

    Let's use `dig` to query an IP for Google:

    ```bash
    dig @127.0.0.1 -p 45553 www.google.com
    ```

    Below is its response. Notice how no IP was set.

    ```text
    ; <<>> DiG 9.20.0-2ubuntu3.2-Ubuntu <<>> @127.0.0.1 -p 45553 www.google.com
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 64266
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 0

    ;; QUESTION SECTION:
    ;www.google.com.			IN	A

    ;; Query time: 0 msec
    ;; SERVER: 127.0.0.1#45553(127.0.0.1) (UDP)
    ;; WHEN: Wed Aug 13 21:33:21 CEST 2025
    ;; MSG SIZE  rcvd: 32
    ```
