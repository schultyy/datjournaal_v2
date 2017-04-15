FROM alpine:3.5

EXPOSE 4000

RUN apk update
RUN apk add elixir erlang-crypto erlang-dev erlang-ssl g++ gcc make git vim nodejs imagemagick \
            erlang-dev erlang-asn1 erlang-crypto erlang-inets erlang-mnesia erlang-public-key \
            erlang-runtime-tools erlang-ssl erlang-syntax-tools erlang-hipe erlang-eunit \
            erlang-parsetools erlang-tools python inotify-tools
RUN mix local.hex --force
RUN mix local.rebar --force
RUN adduser -D -u 4000 journaal
RUN mkdir /app
RUN chown journaal:journaal -R /app
WORKDIR app
