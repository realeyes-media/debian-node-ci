FROM bitnami/node:8 as builder

ENV CHGLOG_VERSION 0.7.1
ENV HUGO_VERSION 0.54.0

# Add that CI candy!
RUN install_packages \
    curl wget zip

# Install https://github.com/git-chglog
WORKDIR /temp
RUN wget https://github.com/git-chglog/git-chglog/releases/download/${CHGLOG_VERSION}/git-chglog_linux_amd64 && \
    mv git-chglog_linux_amd64 /usr/local/bin/git-chglog && \
    chmod +x /usr/local/bin/git-chglog

# Install Hugo SSG
RUN wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    tar -xvzf hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    mv hugo /usr/local/bin && \
    chmod +x /usr/local/bin/hugo

FROM bitnami/node:8
COPY --from=builder /usr/local/bin/hugo /usr/local/bin
COPY --from=builder /usr/local/bin/git-chglog /usr/local/bin
WORKDIR /build

RUN install_packages git zip wget curl

RUN rm -rf temp

CMD ["/bin/bash"]
