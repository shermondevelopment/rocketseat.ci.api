FROM node:18-alpine3.19 AS build

WORKDIR /usr/src/app

# copia o arquivo package.json para dentro do meu WORKDIR
COPY package*.json ./

# instala as depêndencia
RUN npm install

# copia todo os arquivos para dentro do container
COPY . . 

# Gera o build da aplicação
RUN npm run build
RUN npm install --production && npm cache clean --force

# staged  two
FROM node:18-alpine3.19

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package*.json ./

# expoem uma porta do container
EXPOSE 3000

# roda a aplicação
CMD ["npm", "run", "start:prod"]

## -rm flag rm deleta o container ao ser parado