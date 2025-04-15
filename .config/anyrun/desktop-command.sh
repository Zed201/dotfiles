#!/usr/bin/env bash

# AnyRun plugin to execute commands from .desktop files with <term|no-term> <command> handling.
# Usage: Add this as a custom plugin in AnyRun's configuration.

# Read the input (formatted as "command_name <term|no-term> <command>")
read -r input

# Split the input into parts
IFS=' ' read -ra parts <<<"$input"
command_name="${parts[0]}"
term_mode="${parts[1]}"
command_args="${parts[@]:2}" # Rest of the arguments

# Check if the command exists in .desktop files (simplified example)
# You may need to adjust this depending on how AnyRun passes the command.
if [[ "$command_name" == "nvim" && "$term_mode" == "term" ]]; then
  # Example: Open Neovim in a terminal (adjust terminal emulator as needed)
  alacritty -e nvim "$command_args" # Replace 'alacritty' with your preferred terminal
elif [[ "$command_name" == "firefox" && "$term_mode" == "no-term" ]]; then
  # Example: Open Firefox without a terminal
  firefox "$command_args"
else
  # Fallback: Execute the command directly (unsafe in production, validate commands first!)
  if [[ "$term_mode" == "term" ]]; then
    alacritty -e "$command_name" "$command_args"
  else
    "$command_name" "$command_args"
  fi
fi
