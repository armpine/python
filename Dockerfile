# From Alpine Linux image
FROM armhf/alpine:3.5

# QEMU Travis CI
COPY tmp/qemu-arm-static /usr/bin/qemu-arm-static

# Details
LABEL com.armpine.vendor="Armpine" \
      description="Alpine Linux Python 3.5.2-r10 Docker image" \
      version="3.5.2-r10"

# Installer
RUN set -ex \
  # replacing default repositories with edge ones
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" > /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \

  # Add the packages, with a CDN-breakage fallback if needed
  && apk add --update --no-cache \
      ca-certificates \
      python3=3.5.2-r10 \
      python3-dev=3.5.2-r10 \

  # Add the virtual packages
  && apk add --update --virtual build-dependencies \
      dumb-init \
      musl \
      linux-headers \
      build-base \
      bash \
      git \

  # make some useful symlinks that are expected to exist
  && if [[ ! -e /usr/bin/python ]];        then ln -sf /usr/bin/python3.5 /usr/bin/python; fi \
  && if [[ ! -e /usr/bin/python-config ]]; then ln -sf /usr/bin/python3.5-config /usr/bin/python-config; fi \
  && if [[ ! -e /usr/bin/idle ]];          then ln -sf /usr/bin/idle3.5 /usr/bin/idle; fi \
  && if [[ ! -e /usr/bin/pydoc ]];         then ln -sf /usr/bin/pydoc3.5 /usr/bin/pydoc; fi \
  && if [[ ! -e /usr/bin/easy_install ]];  then ln -sf /usr/bin/easy_install-3.5 /usr/bin/easy_install; fi \

  # Install and upgrade Pip
  && easy_install pip \
  && pip install --upgrade pip \
  && if [[ ! -e /usr/bin/pip ]]; then ln -sf /usr/bin/pip3.5 /usr/bin/pip; fi \

  # Cache clear
  && apk del build-dependencies \
  && rm -r /root/.cache \
  && rm -rf /var/cache/apk/*;

CMD ["python"]
