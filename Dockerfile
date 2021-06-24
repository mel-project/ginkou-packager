#FROM rust:1.51 as builder
FROM ekidd/rust-musl-builder:stable as builder
WORKDIR ~

ENV USER root
COPY ./melwalletd/ ./melwalletd
COPY ./ginkou/ ./ginkou
COPY ./ginkou-loader/ ./ginkou-loader

RUN sudo chmod -R 777 ./melwalletd
WORKDIR ./melwalletd
RUN cargo build --release

# Zip up tar file
ENTRYPOINT "/bin/bash"
#CMD ["sh", "ziptar.sh"]
#CMD ["sh", "-c", "ls", "melwalletd*", "|", "tar", "-cvf", "ginkou.tar.gz", "ginkou", "-T", "-"]

# Second stage?
#FROM debian:stable-20210511-slim
