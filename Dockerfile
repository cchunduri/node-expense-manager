ARG NODE_VERSION=21.0.0

#Build Stage
FROM --platform=linux/amd64 node:${NODE_VERSION}-alpine as base
WORKDIR /home/node/app
COPY package*.json ./
RUN npm install
COPY . .

FROM base as production
RUN npm run build

#Production Stage
FROM production
WORKDIR /home/node/app
USER node
EXPOSE 3000
CMD ["node", "dist/server.js"]