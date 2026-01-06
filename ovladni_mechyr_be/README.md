# Ovladni měchýř BE

This is the backend repository for "Ovladni měchýř" application. It provides the API services for the frontend client.

---

## Getting Started

These instructions will get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Before you begin, make sure you have the following installed:

* **Ruby:** The specific version is defined in your `.ruby-version` file or `Gemfile`. We highly recommend using a Ruby version manager like `rbenv` or `RVM` for easy management.
* **Bundler:** You can install it by running `gem install bundler`.
* **PostgreSQL:** This is the chosen database system for the project.

### Installation

**Install Ruby dependencies:**

    bundle install

### Database Setup

1.  **Create the database configuration file:**

    Copy the example configuration:

    ```bash
    cp config/database.yml.example config/database.yml
    ```

    Then, **edit `config/database.yml`** with your local PostgreSQL credentials.

2.  **Set up the database (create, migrate, and seed):**

    This command will create your development and test databases, run all pending migrations, and then load any seed data you have defined.

    ```bash
    rails db:setup
    ```

### Running the Application

1.  **Start the Rails server:**

    ```bash
    rails s
    ```

    The application will typically be accessible in your browser at **`http://localhost:3000`**.

---

## Testing

To run the full test suite for the application:

```bash 
  bundle exec rspec
```

## API Documentation (Rswag):

    After making changes to your API endpoints or Rswag documentation, generate or update the Swagger JSON files:

    ```bash
    bundle exec rswag
    ```
    You can then access the interactive API documentation at `http://localhost:3000/api-docs` (or whatever path you've configured for Rswag).

## Example secrets file


```
devise:
  jwt_secret_key: my_devise_key

host: https://beta-be.uzis.rascasone.com
fe_url: https://uzis.rascasone.com

rollbar:
  api_key: my_key

swagger_ui:
  username: uzis-api
  password: 130-uzis

mailgun:
  domain: rascasone.com
  token: my_key

smtp:
  address: smtp.eu.mailgun.org
  port: 465
  user_name: dev@rascasone.com
  password: my_key
  from: dev@rascasone.com
  authentication: login
  enable_starttls_auto: true
  ssl: true

# Used as the base secret for all MessageVerifiers in Rails, including the one protecting cookies.
secret_key_base: my_key
```