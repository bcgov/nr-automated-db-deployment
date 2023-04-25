FROM ubuntu:22.10
WORKDIR /app
## Add node.js, liquibase, flyway, typeorm
RUN apt-get update && apt-get install -y \
  curl \
  wget \
  unzip \
  git \
  jq
# Add Golang
ENV GOLANG_VERSION 1.20.3
RUN wget https://go.dev/dl/go$GOLANG_VERSION.linux-amd64.tar.gz && \
  tar -C /usr/local -xzf go$GOLANG_VERSION.linux-amd64.tar.gz && \
  rm go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

# Add node.js
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
  apt-get install -y nodejs

# Add Java 17
ENV JAVA_HOME /usr/local/jdk-17.0.1
RUN wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz && \
  tar -C /usr/local -xzf jdk-17_linux-x64_bin.tar.gz && \
  rm jdk-17_linux-x64_bin.tar.gz
ENV PATH $JAVA_HOME/bin:$PATH

# Add Flyway
ENV FLYWAY_HOME /usr/local/flyway-8.0.5
RUN wget https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/8.0.5/flyway-commandline-8.0.5-linux-x64.tar.gz && \
  tar -C /usr/local -xzf flyway-commandline-8.0.5-linux-x64.tar.gz && \
  rm flyway-commandline-8.0.5-linux-x64.tar.gz
ENV PATH $FLYWAY_HOME:$PATH

# Add Liquibase
ENV LIQUIBASE_HOME /usr/local/liquibase-4.6.2
RUN wget https://github.com/liquibase/liquibase/releases/download/v4.6.2/liquibase-4.6.2.tar.gz && \
  tar -C /usr/local -xzf liquibase-4.6.2.tar.gz && \
  rm liquibase-4.6.2.tar.gz
ENV PATH $LIQUIBASE_HOME:$PATH

# Add TypeORM
RUN npm install -g typeorm

COPY execute.sh .
COPY data.json .
RUN chmod +x execute.sh
CMD ["./execute.sh"]
