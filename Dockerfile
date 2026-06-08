FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash ca-certificates curl git make python3 \
    && rm -rf /var/lib/apt/lists/*

RUN curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh -s -- -y --default-toolchain none
ENV PATH="/root/.elan/bin:${PATH}"

WORKDIR /artifact
COPY . /artifact

RUN lake --version
RUN bash scripts/reviewer_quickstart.sh
RUN lake build

CMD ["bash", "scripts/reviewer_quickstart.sh"]
