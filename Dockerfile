FROM debian:stable-20210511-slim
WORKDIR ~

#USER root
COPY ./melwalletd/ ./melwalletd
COPY ./ginkou/ ./ginkou
COPY ./ginkou-loader/ ./ginkou-loader

# Install build tools
# ----
RUN apt update
RUN apt-get install --no-install-recommends -y \
    ca-certificates \
    curl \
    build-essential

# rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH=/root/.cargo/bin:$PATH
RUN rustup target add x86_64-unknown-linux-musl

# Build melwalletd
# ====

RUN chmod -R 777 ./melwalletd
WORKDIR ./melwalletd
RUN cargo build --release --target x86_64-unknown-linux-musl

# Build ginkou-loader
# ====

RUN apt install --no-install-recommends -y \
    libwebkit2gtk-4.0-dev \
    libappindicator3-dev \
    libsoup2.4-dev \
    libclang-7-dev \
    clang-7 \
    pkg-config \
    glib2.0 \
    libcairo2-dev \
    pango1.0 \
    libatk1.0 \
    libgdk-pixbuf2.0 \
    libgtk-3.0 \
    libgtk-3-dev \
    gdk-3.0 \
    gtk-3.0 \
    gtksourceview-3.0 \
    libpango-1.0

RUN chmod -R 777 ../ginkou-loader
WORKDIR ../ginkou-loader
RUN cargo build --release

# Zip up tar file
#ENTRYPOINT "/bin/bash"
#CMD ["sh", "ziptar.sh"]
#CMD ["sh", "-c", "ls", "melwalletd*", "|", "tar", "-cvf", "ginkou.tar.gz", "ginkou", "-T", "-"]
