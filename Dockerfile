FROM alpine:latest AS build

LABEL description="Build container for Hello world app"

RUN apk update \
    && apk add --no-cache g++ gdb make ninja rsync zip cmake

COPY . /src
WORKDIR /src

RUN mkdir out_ninja \
    && cd out_ninja \
    && cmake -GNinja .. \
    && ninja

FROM alpine:latest AS runtime

RUN apk update && apk add --no-cache libstdc++

RUN mkdir /usr/local/SimpleHelloWorldContainer

COPY --from=build /src/out_ninja/SimpleHelloWorldContainer /usr/local/SimpleHelloWorldContainer

WORKDIR /usr/local/SimpleHelloWorldContainer

CMD ./SimpleHelloWorldContainer
