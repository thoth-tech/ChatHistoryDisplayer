FROM node:19.1-buster

# expose port 3000
EXPOSE 3000

# create the /app working dir and copy local file contents /frontEndSimulartor to /app
RUN mkdir /app
WORKDIR /app
COPY . /app

# install dependencies
RUN npm install

CMD /bin/bash -c 'npm install; npm start'

