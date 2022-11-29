FROM node:19.1-buster

EXPOSE 3000

RUN mkdir /app
WORKDIR /app
COPY . /app

RUN npm install
#RUN npm start

#CMD ["npm", "install"]
CMD /bin/bash -c 'npm install; npm start'

