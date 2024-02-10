FROM cycloid/github-cli as downloader

ARG GH_TOKEN
ENV GH_TOKEN=$GH_TOKEN

LABEL   org.opencontainers.image.authors="Miguel Sousa" \
        org.opencontainers.image.title="JMusicBot" \
        org.opencontainers.image.version="1.0.0"

WORKDIR /app

RUN gh release download --pattern "JMusicBot-*.jar" --repo jagrosh/MusicBot && \
    mv JMusicBot-*.jar JMusicBot.jar

FROM eclipse-temurin:19-jre-focal

LABEL   org.opencontainers.image.authors="Miguel Sousa" \
        org.opencontainers.image.title="JMusicBot" \
        org.opencontainers.image.version="1.0.0"

COPY --from=downloader /app/JMusicBot.jar /app/JMusicBot.jar
COPY config.txt /app/config.txt

WORKDIR /app

ENTRYPOINT ["java", "-Dconfig=/app/config.txt", "-Dnogui=true", "-jar", "/app/JMusicBot.jar"]