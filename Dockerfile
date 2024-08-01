FROM public.ecr.aws/ubuntu/ubuntu AS build

ARG VERSION=1449

RUN apt-get update && apt-get install curl unzip -y

WORKDIR /server
RUN curl -fsSL https://terraria.org/api/download/pc-dedicated-server/terraria-server-${VERSION}.zip -o server.zip
RUN unzip server.zip -d .
RUN mv ${VERSION}/Linux .
RUN chmod +x Linux/TerrariaServer.bin.x86_64


FROM public.ecr.aws/ubuntu/ubuntu

COPY --from=build /server/Linux /server
COPY server.cfg /server/server.cfg

ENV PLAYERS="8"
ENV PASS=
ENV MOTD="Welcome to the server!"
ENV WORLD=/data/worlds/world.wld
ENV AUTOCREATE=2
ENV BANLIST=/data/banlist.txt
ENV WORLDNAME=World

EXPOSE 7777/tcp
EXPOSE 7777/udp
VOLUME /data
WORKDIR /server
CMD [ "bash", "-c", "exec ./TerrariaServer.bin.x86_64 \
    -config server.cfg \
    -players ${PLAYERS} \
    -pass ${PASS} \
    -motd ${MOTD} \
    -world ${WORLD} \
    -autocreate ${AUTOCREATE} \
    -banlist ${BANLIST} \
    -worldname ${WORLDNAME}" \
]
