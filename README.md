# Savy

**Savy** is an innovative iOS app that transforms saving money into an exciting challenge for you and your friends!

## Table of Contents

- [Savy](#savy)
    - [Table of Contents](#table-of-contents)
    - [Features](#features)
    - [Getting Started](#getting-started)
        - [Prerequisites](#prerequisites)
        - [Installation](#installation)
    - [Development](#development)
        - [Development Setup](#development-setup)
        - [Environment Setup](#environment-setup)
        - [Supabase Setup](#supabase-setup)
        - [Xcode Run Configurations](#xcode-run-configurations)

## Features

- 💰 Set personalized saving goals
- 🏆 Compete with friends in saving challenges
- 📊 Track your progress with intuitive visualizations

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- Xcode
- [Homebrew](https://brew.sh/)
- Docker
- Supabase CLI

### Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/yourusername/savy.git
    cd savy
    ```

2. Install Docker Desktop (if not already installed):

    ```bash
    brew install --cask docker
    ```

3. Install Supabase CLI:
    ```bash
    brew install supabase/tap/supabase
    supabase --version # verify installation
    ```

## Development

### Development Setup

Setup the needed project configuration:

```bash
sh setup.sh
```

### Environment Setup

1. Create your environment configuration:

    ```bash
    cp .env.mock .env
    ```

2. Open and edit the `.env` file with your preferred text editor:

    ```bash
    code .env  # for Visual Studio Code
    nano .env  # for terminal-based editing
    ```

3. Generate the Swift Enum:
    ```bash
    sh env.sh
    ```

### Supabase Setup

- Link to the Production instance:

    ```bash
    supabase link --project-ref dttigamyidncuoomgkpo
    ```

- Start the local Supabase instance:

    ```bash
    supabase start
    ```

    **Note:** Ensure Docker is running before executing this command.

- Apply newest migrations:

    ```bash
     supabase migration up
    ```

- Stop the local Supabase instance:

    ```bash
    supabase stop
    ```

- Pull the changes from Production:

    ```bash
    supabase db pull
    ```

- Push the local changes to Production:
    ```bash
    supabase db push
    ```

### Xcode Run Configurations

The Savy Xcode project comes with two run configurations:

1. **Savy**: Use this for local development.
2. **Savy - Release**: Use this for testing in a production-like environment.
