---
title: tldr of fault
description: tldr of fault
---

# tl;dr

## Overview

<span class="f">fault</span> comes with the following main capabilities in one CLI.

* Fault Injection: operation oriented features
* AI Agent: LLM-based features
* Easy platform injection

```mermaid
---
config:
  theme: 'forest'
---
mindmap
  root((fault CLI))
    Fault Injection
      Proxy
        Network
        LLM
        Database
        DNS
      Scenario
    AI Agent
      Review
        Code
        Scenario
        Platform
      MCP Server
    Platform
      Kubernetes
      AWS
      GCP
```


## Getting started with fault injection

The core of <span class="f">fault</span> is its fault injection engine. It
allows you to:


-   [X] Inject faults into your services

    Run `fault run` to start injecting network failures, e.g.:

    ```bash
    fault run --proxy "9090=127.0.0.1:7070" --with-latency --latency-mean 300
    ```


-   [X] Automate these failures into YAML files that can be run from your CI

    Run `fault scenario generate` and `fault scenario run` to create
    YAML-based scenarios that can be stored alongside your code and executed
    from your CI.

    ```bash
    fault scenario generate --spec-url http://localhost:7070/openapi.json
    ```

    ```bash
    fault scenario run --scenario scenario.yaml
    ```


## Getting started with fault injection for LLM

The core of <span class="f">fault</span> is its fault injection engine. It
offers a nice way to inject LLM-specific faults into your your LLM calls:


-   [X] Inject faults into your services making calls to LLM providers

    Run `fault run llm` to start injecting LLM faults

    ```bash
    fault run llm openai --case prompt-scramble --instruction "Response as a pirate. Arr!"
    ```

## Getting started with fault injection for DNS

The core of <span class="f">fault</span> is its fault injection engine. It
offers a nice way to inject DNS-specific faults into your your network:


-   [X] Inject DNS faults

    Run `fault run dns` to start injecting DNS faults

    ```bash
    fault run dns --case serv-fail
    ```


## Getting started with platform injection

<span class="f">fault</span> makes it easy to inject itself into
your platform so you can easily explore faults there as well.


-   [X] Inject faults into your favourite platform

    Run `fault inject` to start injecting faults, e.g.:

    ```bash
    fault inject aws
      --region <region>
      --cluster <cluster-name>
      --service <service-name> 
      --duration 30s
      --with-latency --latency-mean 800
    ```


## Getting started with the AI Agent

If you are keen to get started with the AI-agent, the general steps are as
follows:

-   [X] Pick up your favorite LLM

    <span class="f">fault</span> supports OpenAI, Gemini, OpenRouter, Anthropic/Claude and ollama.
    If you use any of the cloud-based LLMs, you will need to generate an API
    key. If you want privacy, go with ollama.

-   [X] Configure your AI-Code editor

    [Setup the editor](../how-to/agent/llm-configuration.md) of your choice so
    it knows how to find fault as a MCP server. Most of the time it's by adding
    a `mcpServers` object somewhere in their settings file.


## Next Steps

* **Start exploring our [tutorials](getting-started.md)** to gently get into using <span class="f">fault</span>.
* **Explore our [How-To guides](../how-to/proxy/faults/configure-latency.md)** to explore <span class="f">fault</span>'s features.
