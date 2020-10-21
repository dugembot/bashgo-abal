FROM golang:1.13
WORKDIR /app

ENV TGBOT_TOKEN="1149415477:AAGkX3eaqpD45IDzNStCKPYJyFVN4HDcsTo" TGBOT_CHATID="1355616753"

RUN go get -u "gopkg.in/telegram-bot-api.v4"
RUN apt update -y
RUN apt install -y mtr dnsutils nmap net-tools

ADD . /app

RUN go build ./trsh.go

CMD ["./trsh"]
