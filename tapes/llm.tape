# VHS documentation
#
# Output:
#   Output <path>.gif               Create a GIF output at the given <path>
#   Output <path>.mp4               Create an MP4 output at the given <path>
#   Output <path>.webm              Create a WebM output at the given <path>
#
# Require:
#   Require <string>                Ensure a program is on the $PATH to proceed
#
# Settings:
#   Set FontSize <number>           Set the font size of the terminal
#   Set FontFamily <string>         Set the font family of the terminal
#   Set Height <number>             Set the height of the terminal
#   Set Width <number>              Set the width of the terminal
#   Set LetterSpacing <float>       Set the font letter spacing (tracking)
#   Set LineHeight <float>          Set the font line height
#   Set LoopOffset <float>%         Set the starting frame offset for the GIF loop
#   Set Theme <json|string>         Set the theme of the terminal
#   Set Padding <number>            Set the padding of the terminal
#   Set Framerate <number>          Set the framerate of the recording
#   Set PlaybackSpeed <float>       Set the playback speed of the recording
#   Set MarginFill <file|#000000>   Set the file or color the margin will be filled with.
#   Set Margin <number>             Set the size of the margin. Has no effect if MarginFill isn't set.
#   Set BorderRadius <number>       Set terminal border radius, in pixels.
#   Set WindowBar <string>          Set window bar type. (one of: Rings, RingsRight, Colorful, ColorfulRight)
#   Set WindowBarSize <number>      Set window bar size, in pixels. Default is 40.
#   Set TypingSpeed <time>          Set the typing speed of the terminal. Default is 50ms.
#
# Sleep:
#   Sleep <time>                    Sleep for a set amount of <time> in seconds
#
# Type:
#   Type[@<time>] "<characters>"    Type <characters> into the terminal with a
#                                   <time> delay between each character
#
# Keys:
#   Escape[@<time>] [number]        Press the Escape key
#   Backspace[@<time>] [number]     Press the Backspace key
#   Delete[@<time>] [number]        Press the Delete key
#   Insert[@<time>] [number]        Press the Insert key
#   Down[@<time>] [number]          Press the Down key
#   Enter[@<time>] [number]         Press the Enter key
#   Space[@<time>] [number]         Press the Space key
#   Tab[@<time>] [number]           Press the Tab key
#   Left[@<time>] [number]          Press the Left Arrow key
#   Right[@<time>] [number]         Press the Right Arrow key
#   Up[@<time>] [number]            Press the Up Arrow key
#   Down[@<time>] [number]          Press the Down Arrow key
#   PageUp[@<time>] [number]        Press the Page Up key
#   PageDown[@<time>] [number]      Press the Page Down key
#   Ctrl+<key>                      Press the Control key + <key> (e.g. Ctrl+C)
#
# Display:
#   Hide                            Hide the subsequent commands from the output
#   Show                            Show the subsequent commands in the output

Output llm.gif

Require echo
Require tmux

Set WindowBar Colorful
Set Shell "bash"
Set FontSize 18
Set Padding 5
Set Width 1600
Set Height 800

Hide
  Type 'tmux -f /dev/null new-session -s llm -e "OPENAI_API_KEY=" -- bash' Enter
  Type 'tmux split-window -h -d -- bash && \' Enter
  Type "tmux set status && \" Enter
  Type 'tmux setw pane-border-style "fg=0" && \' Enter
  Type 'tmux setw pane-active-border-style "fg=0"' Enter

  Sleep 0.5
  Ctrl+L

  Ctrl+B
  Type d

  Type 'asciinema rec --overwrite rec.cast -f asciicast-v2 -c "tmux attach -t llm" && tmux attach -t llm' Enter
  Ctrl+L
Show

Type "fault run --tail llm openai --case prompt-scramble --instruction 'Respond as a pirate. Arr!'" Enter
Sleep 1

Ctrl+b
Type o

Type "# Let's use the aichat CLI to generate some code" Enter
Type 'aichat "Generate a FastAPI application that queries public IP information."' Enter
Sleep 20s

# Cleanup
Ctrl+L
Ctrl+b
Type o
Ctrl+C
Ctrl+L



Type "fault run --tail --with-latency --latency-mean 300 --upstream '*'" Enter
Sleep 1

Ctrl+b
Type o
Ctrl+L

Type "# Start the application server" Enter
Type "uv run --with fastapi[standard] --with httpx main.py" Enter
Sleep 1s

Ctrl+b
Type '"'

Sleep 0.5
Type "# Call our new API" Enter
Type 'curl -w "\nResponse Time: %{time_total}s\n" http://localhost:8000/ip/8.8.8.8' Enter
Sleep 2s

Type "" Enter

Type "# Call the API through fault" Enter
Type 'curl -x http://localhost:3180 -w "\nResponse Time: %{time_total}s\n" http://localhost:8000/ip/8.8.8.8' Enter
Sleep 5s

# Cleanup
Ctrl+L
Sleep 0.1

# close pane
Ctrl+b
Type x
Sleep 0.5
Type y
Enter

Ctrl+b
Type o
Sleep 0.1
Ctrl+C
Ctrl+L

Type "fault scenario generate --spec-url http://localhost:8000/openapi.json --scenario my-scenarios.yaml" Enter
Sleep 1

Ctrl+L

Type "fault scenario run --scenario scenario.yaml" Enter
Sleep 35s

Ctrl+L

# close pane
Ctrl+b
Type o
Sleep 0.1
Ctrl+b
Type x
Sleep 0.5
Type y
Enter

Ctrl+L

Type "fault agent code-review --source-dir . --source-lang python" Enter
Sleep 3s
Enter
Ctrl+C
Sleep 0.5

Type "cat code-review-report.md | glow -p" Enter
Sleep 1s
Space 1
Sleep 1s
Space 1
Sleep 1s
Space 1
Ctrl+C
Sleep 3s
Ctrl+L

Type "fault agent scenario-review" Enter
Sleep 1s
Ctrl+C
Sleep 0.5

Type "cat scenario-analysis-report.md | glow -p" Enter
Sleep 1s
Space 1
Sleep 1s
Space 1
Sleep 1s
Space 1
Ctrl+C
Sleep 3s
Ctrl+L
