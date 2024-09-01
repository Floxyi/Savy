#!/usr/bin/env bash

env_file=".env"
output_file="./Savy/Environment/DotEnv.swift"

mkdir -p "$(dirname "$output_file")"

if [[ -f "$env_file" ]]; then
    {
        echo "enum DotEnv {"
        grep -v '^#' "$env_file" | while IFS='=' read -r key value || [[ -n "$key" ]]; do
            if [[ -n "$key" && ! "$key" =~ ^# ]]; then
                if [[ -z "$value" ]]; then
                    value=$(eval "echo \$$key")
                fi
                echo "  static let $key = \"$value\""
            fi
        done
        echo "}"
    } > "$output_file"
    
    echo "DotEnv.swift has been created at $output_file"
else
    echo "Error: .env file not found at $env_file"
    exit 1
fi
