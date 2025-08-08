---
title: Inject Faults Into LLM API Calls
description: Inject Faults Into LLM API Calls
---

# How to Scramble your LLM communications with <span class="f">fault</span>

This guide shows you how to scramble LLM prompts and responses so that
you may figure out how your application handles variations often
observed with LLM.

!!! abstract "Prerequisites"

    -   [X] Install <span class="f">fault</span>

        If you haven’t installed <span class="f">fault</span> yet, follow the
        [installation instructions](../../install.md).
    
    -   [X] Install and configure the `aichat` CLI


        Throughout this guide we will be using the
        [aichat](https://github.com/sigoden/aichat) CLI to handle our
        prompt examples. While <span class="f">fault</span> works with any
        LLM client, `aichat` helps us keep this guide tight and clear.

        You may want to create a aichat config file that describes where to send
        requests trhough <span class="f">fault</span>:

        ```yaml title="~/.config/aichat/config.yaml"
        model: openai:o4-mini-high
        clients:
        - type: openai-compatible # (1)!
          name: openai
          api_base: http://localhost:45580/v1 # (2)!
          api_key: ... # (3)!
        ```

        1. Tells aichat this applies to all requests using the OpenAI API.
        2. The address of the proxy, the `/v1` path is necessary because the calls
        will be prefixed by it
        3. Set a valid OpenAI API key


!!! tip "Supported LLM providers"

    <span class="f">fault</span> supports many LLM providers natively
    (OpenAI, Gemini, OpenRouter and ollama). The restriction for now is that
    we intercept and modify the
    [OpenAI chat completions API](https://platform.openai.com/docs/api-reference/chat)
    only.


## Scramble a prompt

One of the most interesting feature from <span class="f">fault</span> is its
capacity to inject additional system prompts into a LLM query. Thi
instruction will change the behavior from the LLM and therefore be valuable
to explore.

-   [X] Inject a system prompt

    Make the LLM answer with a pirate tone:

    ```bash
    fault run llm openai --case prompt-scramble --instruction "Response as a pirate. Arr!"
    ```

    This will launch <span class="f">fault</span> and start a proxy
    listening on port 45580.

    To use it, simply swap your client's URL to point at the
    `http://localhost:45580`. All requests will be sent as-is to the right
    provider.

-   [X] Generate a random piece of code

    We may now send a prompt:

    ```bash
    aichat "Generate a python function that gives the time"
    ```

    Below is its response. Note the vocabulary used to respond like a pirate. Yarrr!

    ```markdown
    Arrr, me hearty! Here’s a little Python function to fetch the current time for ye. Feel free to run it aboard yer own vessel:

        ```python
        def get_current_time(fmt='%Y-%m-%d %H:%M:%S'):
            """
            Returns the current time as a formatted string.
            :param fmt: A datetime strftime-format string (default: 'YYYY-MM-DD HH:MM:SS')
            """
            from datetime import datetime
            return datetime.now().strftime(fmt)
        ```

    Usage be simple as swabbing the deck:

        >>> print(get_current_time())
        2024-06-15 14:23:08

    Or specify yer own treasure-map of a format:

        >>> print(get_current_time('%H:%M:%S on %B %d, %Y'))
        14:23:08 on June 15, 2024

    Arr! That’ll keep ye shipshape with every tick of the clock.

    return f"Arr! The time be {datetime.datetime.now().strftime('%H:%M:%S')}"
    ```

## Modify a prompt

-   [X] Modify a prompt

    Make the LLM answer with Java code instead of Python.

    ```bash
    fault run llm openai --case prompt-scramble --scramble-pattern python --scramble-with java
    ```

    The pattern can be any valid regular expression.

    This will launch <span class="f">fault</span> and start a proxy
    listening on port 45580.

    To use it, simply swap your client's URL to point at the
    `http://localhost:45580`. All requests will be sent as-is to the right
    provider.

-   [X] Generate a random piece of code

    We may now send a query:

    ```bash
    aichat -c "Generate a python function that gives the time"
    ```

    Below is its response. Note how we get a Java snippet.

    ```markdown
    Here’s a small utility class that shows a few ways to “get the time” in Java 8+ using the java.time API:

        ```java
        import java.time.Instant;
        import java.time.LocalDateTime;
        import java.time.LocalTime;
        import java.time.ZoneId;
        import java.time.format.DateTimeFormatter;

        public class TimeUtil {

            /**
            * Returns the current LocalTime (hours/minutes/seconds/nanos).
            */
            public static LocalTime getCurrentLocalTime() {
                return LocalTime.now();
            }

            /**
            * Returns the current LocalDateTime (date + time).
            */
            public static LocalDateTime getCurrentLocalDateTime() {
                return LocalDateTime.now();
            }

            /**
            * Returns the current time as a formatted string, e.g. "15:42:07".
            * You can pass in any pattern you like, e.g. "HH:mm:ss", "yyyy-MM-dd HH:mm:ss", etc.
            */
            public static String getCurrentTimeFormatted(String pattern) {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern(pattern);
                return LocalDateTime.now().format(formatter);
            }

            /**
            * Returns the current Unix timestamp (seconds since 1970-01-01T00:00:00Z).
            */
            public static long getUnixTimestamp() {
                return Instant.now().getEpochSecond();
            }

            /**
            * Returns the current timestamp in milliseconds.
            */
            public static long getEpochMillis() {
                return Instant.now().toEpochMilli();
            }

            public static void main(String[] args) {
                // Examples of usage:
                System.out.println("LocalTime            = " + getCurrentLocalTime());
                System.out.println("LocalDateTime        = " + getCurrentLocalDateTime());
                System.out.println("Formatted (HH:mm:ss) = " + getCurrentTimeFormatted("HH:mm:ss"));
                System.out.println("Formatted (full)     = " + getCurrentTimeFormatted("yyyy-MM-dd HH:mm:ss"));
                System.out.println("Unix timestamp       = " + getUnixTimestamp());
                System.out.println("Epoch millis         = " + getEpochMillis());
            }
        }
        ```

    Explanation of the key methods:

    * getCurrentLocalTime(): returns a LocalTime instance (no date).  
    * getCurrentLocalDateTime(): returns a LocalDateTime (date + time).  
    * getCurrentTimeFormatted(pattern): returns a String formatted according to the given pattern.  
    * getUnixTimestamp(): seconds since the epoch (1970-01-01T00:00:00Z).  
    * getEpochMillis(): milliseconds since the epoch.  

    All of these use the modern java.time API, which is thread-safe and ISO-compliant.
    ```

## Inject bias into a response

In this use case, you can amend the response back from the server.

-   [X] Modify a prompt

    Make the LLM answer with Java code instead of Python.

    ```bash
    fault run llm openai --case inject-bias --bias-pattern "(?i)paris" --bias-replacement "London"
    ```

    The pattern can be any valid regular expression.

    This will launch <span class="f">fault</span> and start a proxy
    listening on port 45580.

    To use it, simply swap your client's URL to point at the
    `http://localhost:45580`. All requests will be sent as-is to the right
    provider.

-   [X] Run a prompt

    We may now send the following prompt:

    ```bash
    aichat "What is the average level of Sun per year of France's largest cities?"
    ```

    Here is the response:

    ```markdown
    Below is an approximate ranking of France’s ten largest cities (by population) by their average annual sunshine, expressed in hours of bright sunshine per year.  All figures refer to the 1981–2010 “climate‐normal” period as published by Météo-France:

    • Marseille (Pharo)………………2 784 h/year  
    • Nice (Le Var)…………………2 701 h/year  
    • Montpellier (Fréjorgues)…..2 621 h/year  
    • Toulouse (Blagnac)……………2 057 h/year  
    • Bordeaux (Mérignac)…………2 074 h/year  
    • Lyon (Bron)………………………1 831 h/year  
    • Nantes (Bouguenais)………1 795 h/year  
    • Strasbourg (Entzheim)……1 700 h/year  
    • London (Montsouris)……………1 662 h/year  
    • Lille (Lesquin)………………1 477 h/year  

    Key take-aways:  
    – The sunniest of the major cities is Marseille (≈2 800 h), followed by Nice and Montpellier.  
    – London, Lyon, Nantes and Strasbourg all hover in the 1 600–1 800 h range.  
    – Lille has the lowest annual sunshine of the ten, with roughly 1 480 h/year.
    ```

    Notice how {==Paris==} was renamed {==London==}.

## Slow the streamed response

This use case is valuable to measure how your client deals with a slow
streamed response.

-   [X] Slow the response by `800ms` per chunk

    ```bash
    fault run llm openai --case slow-stream --slow-stream-mean-delay 800
    ```

    This will launch <span class="f">fault</span> and start a proxy
    listening on port 45580.

    To use it, simply swap your client's URL to point at the
    `http://localhost:45580`. All requests will be sent as-is to the right
    provider.

-   [X] Run a prompt

    We may now send a query:

    ```bash
    aichat "What is the average level of Sun per year of France's largest cities?"
    ```

    You will notice each chunk takes some time to be displayed.
