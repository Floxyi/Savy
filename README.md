# Savy
**Savy** is an iOS app that challenges you and your friends to save money in a fun and engaging way!

## Development Setup

To get started with development, follow the steps below to configure your environment:

1. **Create Your Environment Configuration**

   Start by setting up your `.env` file:

   ```bash
   cp .example.env .env
   ```

   Then, open the newly created `.env` file and fill it with the required values. You can use any text editor, such as:

   ```bash
   code .env
   ```

2. **Generate the Swift Enum**

   Once your `.env` file is correctly configured, generate the Swift Enum by running:

   ```bash
   sh env.sh
   ```

3. **Start the Local Supabase Instance**

   To run the app locally, start your Supabase instance:

   ```bash
   supabase start
   ```

   **Note:** Make sure Docker is running before executing this command.

### Run Configurations

There are two run configurations:
- **Savy**: This is used for local development
- **Savy - Release**: This is used for testing a production environment
