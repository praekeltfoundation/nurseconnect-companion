# Build node app
FROM node:7 as node

COPY assets assets
COPY deps/phoenix deps/phoenix
COPY deps/phoenix_html deps/phoenix_html
WORKDIR assets
RUN npm install
RUN node node_modules/brunch/bin/brunch build --production

# Build elixir app
FROM elixir:1.6-alpine
ENV MIX_ENV="prod"
COPY lib lib
COPY config config
COPY mix.* ./
COPY --from=node /priv/static /priv/static
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix deps.compile
RUN mix phx.digest

ENV PORT=4000
EXPOSE 4000
CMD [ "mix", "phx.server" ]