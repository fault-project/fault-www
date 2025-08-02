<h2 align="center">
  <br>
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/rebound-how/rebound/refs/heads/main/docs/fault/docs/assets/logo-full-light.png">
    <img alt="fault" src="https://raw.githubusercontent.com/rebound-how/rebound/refs/heads/main/docs/fault/docs/assets/logo-full-dark.png">
  </picture>

</h2>

<h4 align="center">fault | Helping Engineers and AI-agents cooperate to build reliable applications</h4>

<p align="center">
  <img alt="Deployment Status" src="https://api.netlify.com/api/v1/badges/12f0d431-7024-4212-83da-bf410394a271/deploy-status">

</p>

<p align="center">
  <a href="https://fault-project.com/how-to/install/">Installation</a> •
  <a href="https://fault-project.com/tutorials/getting-started/">Documentation</a>
</p>

---

fault is a Rust-powered CLI with two main features:

* fault injection: injects network faults into your system to learn about their impacts and how you recover from failures.
* AI-agent: run fault as a MCP server in your favourit code editor to improve the production-soundness of its output

## Build

Install the dependencies using [pdm](https://pdm-project.org/en/latest/):

```bash
pdm install
```

Then you can serve locally the documentation:

```bash
mkdocs serve
```
