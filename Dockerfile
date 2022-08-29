FROM node:16
WORKDIR /app
RUN npm set strict-ssl false
RUN npm install pm2 -g
RUN pm2 install @easynvest/pm2-logstash
RUN pm2 set @easynvest/pm2-logstash:logstash_port 9600 && pm2 set @easynvest/pm2-logstash:logstash_host logstash && pm2 set @easynvest/pm2-logstash:logstash_type tcp
COPY package*.json .
RUN yarn config set network-timeout 300000
RUN yarn config set strict-ssl false -g
RUN yarn install
COPY . .
RUN yarn build
EXPOSE 3333
ENTRYPOINT ["pm2-runtime", "dist/main.js"]