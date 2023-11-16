FROM rust:1.67 as builder
WORKDIR /usr/src/torch_beats
COPY . .
RUN apt-get update && apt-get install -y cmake && rm -rf /var/lib/apt/lists/*
RUN cargo install --path .

FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y build-essential autoconf automake libtool m4 libopus-dev ffmpeg curl && rm -rf /var/lib/apt/lists/*
RUN curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
RUN chmod a+rx /usr/local/bin/youtube-dl
COPY --from=builder /usr/local/cargo/bin/torch_beats /usr/local/bin/torch_beats
CMD ["torch_beats"]
