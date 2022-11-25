FROM debian:latest
FROM ruby:3.1-buster

RUN apt-get update && apt-get install -y git

RUN mkdir /emulator
WORKDIR /emulator
COPY . /emulator

RUN bundle install

EXPOSE 4567

#CMD bundle exec rerun --background main.rb

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]
#ENTRYPOINT ["sh", "./startup.sh"]
