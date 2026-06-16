FROM mcr.microsoft.com/devcontainers/base:ubuntu24.04
# These dependencies were recommended by the Swiftly installer (2025-06)
RUN apt-get update && apt-get -y install libpython3-dev libxml2-dev libncurses-dev libz3-dev pkg-config
# Ugly installer: https://www.swift.org/install/linux/
WORKDIR /
RUN curl -L https://download.swift.org/swiftly/linux/swiftly-$(uname -m).tar.gz | tar zx
USER vscode
# Latest version is fine in dev, ci.yml will test older versions
RUN ./swiftly init --assume-yes
