FROM ruby:3.1-buster

# download git, a dependency for the git gem
RUN apt-get update && apt-get install -y git

# create the working dir and copy /emulator local files into /api working dir
RUN mkdir /api
WORKDIR /api
COPY . /api

# install the bundler gem
RUN gem install bundler --version 2.3.26

# use bundle to install gems in gemfile
RUN bundle install

# expose port 4567
EXPOSE 4567

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]

