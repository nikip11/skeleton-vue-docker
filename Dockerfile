FROM node:18-alpine

RUN npm install -g pnpm

WORKDIR /app

EXPOSE 3000

CMD ["pnpm", "run", "dev"]