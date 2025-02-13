#!/bin/bash

env_file=".env"
output_file="./Savy/Resources/Config/DotEnv.swift"

mkdir -p "$(dirname "$output_file")"

if [[ -f "$env_file" ]]; then
    {
        echo "enum DotEnv {"

        base_keys=$(grep -o '^[^#]*' "$env_file" | awk -F'=' '{print $1}' | sed -E 's/_(DEV|PROD)$//' | sort -u)

        for base_key in $base_keys; do
            dev_value=$(grep "^${base_key}_DEV=" "$env_file" | cut -d'=' -f2-)
            prod_value=$(grep "^${base_key}_PROD=" "$env_file" | cut -d'=' -f2-)

            echo "    static let $base_key: String = {"
            echo "        switch AppEnvironment.current {"
            echo "        case .development:"
            echo "            return \"${dev_value}\""
            echo "        case .production:"
            echo "            return \"${prod_value}\""
            echo "        }"
            echo "    }()"
        done

        echo "}"
    } > "$output_file"

    echo "DotEnv.swift has been created at $output_file"
else
    echo "Error: .env file not found at $env_file"
    exit 1
fi
