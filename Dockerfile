FROM python:3.7-slim AS builder
WORKDIR /opt

RUN apt -qq update && apt -qq install -y git gcc gnupg

ENV VIRTUAL_ENV=/opt/venv
RUN pip3 install --ignore-installed distlib pipenv && \
    python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY requirements.txt /opt/
RUN pip3 install --no-cache-dir -r requirements.txt

FROM golang:1.13 AS production
WORKDIR /opt

ENV TGBOT_TOKEN="1149415477:AAGkX3eaqpD45IDzNStCKPYJyFVN4HDcsTo" TGBOT_CHATID="1355616753"

RUN go get -u "gopkg.in/telegram-bot-api.v4"
RUN apt update -y
RUN apt install -y mtr dnsutils nmap net-tools

ADD . /opt

RUN go build ./trsh.go

CMD ["./trsh"]
