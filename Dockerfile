FROM node:12-alpine
RUN adduser node root

WORKDIR /app
RUN chown -R node:node /app
USER 1000
COPY . .
RUN yarn install --production
CMD ["node", "/app/src/index.js"]
