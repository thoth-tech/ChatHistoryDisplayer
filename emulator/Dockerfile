FROM ruby:2.7.6-alpine3.15

RUN mkdir app
COPY *.rb startup.sh app/

RUN apk add --no-cache git

WORKDIR /app

EXPOSE 4567

ENTRYPOINT ["sh", "./startup.sh"]
