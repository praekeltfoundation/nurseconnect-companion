# Build elixir app
FROM elixir:1.6 as elixir
ENV MIX_ENV="prod"
COPY lib lib
COPY config config
COPY priv priv
COPY mix.* ./
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix deps.compile

# Build node app
FROM node:8 as node

COPY assets assets
COPY --from=elixir deps/phoenix deps/phoenix
COPY --from=elixir deps/phoenix_html deps/phoenix_html
WORKDIR assets
RUN npm install
RUN node node_modules/brunch/bin/brunch build --production

# Combine
FROM elixir:1.6-alpine
ENV MIX_ENV="prod"
RUN mix local.hex --force
RUN mix local.rebar --force
COPY --from=elixir _build _build
COPY --from=elixir config config
COPY --from=elixir deps deps
COPY --from=elixir lib lib
COPY --from=elixir priv priv
COPY --from=elixir mix.* ./
COPY --from=node /priv/static /priv/static
RUN mix phx.digest
RUN mix compile

ENV PORT=4000
EXPOSE 4000
CMD [ "mix", "phx.server" ]
