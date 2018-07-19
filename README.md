# NurseConnect Companion
[![Build Status](https://travis-ci.org/praekeltfoundation/nurseconnect-companion.svg?branch=develop)](https://travis-ci.org/praekeltfoundation/nurseconnect-companion)
[![codecov](https://codecov.io/gh/praekeltfoundation/nurseconnect-companion/branch/develop/graph/badge.svg)](https://codecov.io/gh/praekeltfoundation/nurseconnect-companion)

A companion application to run tasks that we cannot inside of RapidPro

To setup the development environment:
  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`

To run the development server:
  * Setup the development environment
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

To run the tests:
  * Setup the development environment
  * Run the tests with `mix test --cover`

Environment config:
`GOOGLE_CLIENT_ID` - Client ID for Google OAuth
`GOOGLE_CLIENT_SECRET` - Secret for Google OAuth
`GOOGLE_DOMAIN` - The domain to limit sign in to
`HOST` - Hostname of the service
`SECRET_KEY` - Secure secret key for the service
`DATABASE_URL` - URL to connect to the database
`TASK_TIMEOUT` - Timeout for tasks to be retried. Defaults to 300 seconds
`TASK_RETRIES` - Number of retries before task is considered failed. Defaults to 10
`RAPIDPRO_URL` - URL of the rapidpro instance where the contacts are stored
`RAPIDPRO_TOKEN` - Authorization token to access the rapidpro instance
`OPENHIM_URL` - URL to send to OpenHIM
`OPENHIM_USERNAME` - Username to access OpenHIM
`OPENHIM_PASSWORD` - Password to access OpenHIM
