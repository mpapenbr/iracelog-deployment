ARG postgres_tag
FROM postgres:${postgres_tag}

ARG DB_USER_NAME 
ARG DB_USER_PASSWORD

RUN echo "Europe/Berlin" > /etc/timezone
COPY init /docker-entrypoint-initdb.d 

COPY conf /tmp/pgconf


