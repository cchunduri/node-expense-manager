ARG NODE_VERSION=21.0.0

#Build Stage
FROM node:${NODE_VERSION}-alpine
ENV NODE_ENV production
WORKDIR /app

COPY package*.json .
RUN npm install

COPY . .

RUN npm run build

#Production Stage
FROM node:${NODE_VERSION}-alpine
WORKDIR /app
COPY package*.json .

RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    --mount=type=cache,target=/root/.npm \
    npm ci --omit=dev --only=production

    
USER node
COPY --from=build /app/dist ./dist
RUN npx tsc
EXPOSE 3000
CMD ["node", "dist/server.js"]