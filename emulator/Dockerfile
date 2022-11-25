FROM debian:latest
FROM ruby:3.1-buster

RUN apt-get update && apt-get install -y git

RUN mkdir /api
WORKDIR /api
COPY . /api

RUN bundle install

EXPOSE 4567

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]
#CMD ["bundle", "exec", "rerun", "--port=4567", "ruby", "main.rb"]
#CMD bundle exec rerun 'rackup --host 0.0.0.0 -p 4567'

