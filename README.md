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
