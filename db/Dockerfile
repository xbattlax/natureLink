FROM postgres:latest
ENV POSTGRES_PASSWORD=secret
ENV POSTGRES_USER=username
ENV POSTGRES_DB=database
#COPY create_fixtures.sql /docker-entrypoint-initdb.d/create_fixtures.sql
COPY uudi.sh /docker-entrypoint-initdb.d/uudi.sh
COPY data.sql /docker-entrypoint-initdb.d/data.sql
EXPOSE 5432