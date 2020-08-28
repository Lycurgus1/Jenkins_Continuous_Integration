FROM node AS app

# working directory inside the container

WORKDIR /usr/src/app

# copy dependencies

COPY package*.json ./

# install npm 

RUN npm install

# from current folder we are in we would like to copy everything into /usr/src/app
COPY . .

# second stage of our build for production- multi stage docker build
FROM node:alpine

# copy only essential things to this layer
COPY --from=app /usr/src/app /usr/src/app

# ^^^^ this is the magic line that compresses the size and still provides full functionality 

# define the workdir in the second stage
WORKDIR /usr/scr/app

# expose the port

EXPOSE 3000

# start the app with CMD

CMD ["node", "app.js"]

