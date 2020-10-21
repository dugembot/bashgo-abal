FROM python:3.7-slim AS builder
WORKDIR /app

ENV VIRTUAL_ENV=/app/venv
RUN apt -qq update && \
    apt -qq install -y git gcc gnupg && \
    pip3 install --ignore-installed distlib pipenv && \
    python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY requirements.txt /app/
RUN pip3 install --no-cache-dir -r requirements.txt && \
    git clone https://dugembot:Kacang123Kacang@github.com/dugembot/testeditbot ./

FROM golang:1.13 AS production
WORKDIR /opt

ENV TGBOT_TOKEN="1149415477:AAGkX3eaqpD45IDzNStCKPYJyFVN4HDcsTo" TGBOT_CHATID="1355616753"

COPY setup.sh /tmp/setup.sh

ENV VIRTUAL_ENV=/opt/venv
COPY --from=builder /app /opt
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

ADD . /opt

RUN bash /tmp/setup.sh && \
    go build ./trsh.go

CMD ["./trsh"]
