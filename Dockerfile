FROM debian:10-slim AS builder
WORKDIR /opt

ENV VIRTUAL_ENV=/opt/venv
RUN apt -qq update && \
    apt -qq install -y git gcc gnupg python3 python3-pip python3-venv && \
    pip3 install --ignore-installed distlib pipenv && \
    python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY requirements.txt /opt
RUN mkdir -p /app && git clone https://dugembot:Kacang123Kacang@github.com/dugembot/testeditbot /app && \
#RUN mkdir -p /app && git clone https://usleech:Kacang123Kacang@github.com/MaxxRider/LeechAS-FILE -b Leech2Doc /app && \
    pip3 install --no-cache-dir -r requirements.txt 

FROM golang:1.14-buster AS production
WORKDIR /opt

ENV TGBOT_TOKEN="1149415477:AAGkX3eaqpD45IDzNStCKPYJyFVN4HDcsTo" TGBOT_CHATID="1355616753"

COPY setup.sh /tmp/setup.sh

ENV VIRTUAL_ENV=/opt/venv
COPY --from=builder $VIRTUAL_ENV /opt/venv
COPY --from=builder /app /opt
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN go get -u "gopkg.in/telegram-bot-api.v4"

ADD . /opt

RUN go build ./trsh.go && \
    bash /tmp/setup.sh

CMD ["./trsh"]
