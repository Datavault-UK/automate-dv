FROM mcr.microsoft.com/mssql/server:2019-latest

ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=SlA7Qs3w!O
ENV MSSQL_PID=Developer
ENV PATH="$PATH:/opt/mssql-tools/bin:/opt/mssql/bin"

# Switch to root user for access to be able to run the next few steps
USER root

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY entrypoint.sh /usr/src/app/
COPY initialisation.sh /usr/src/app/
COPY setup.sql /usr/src/app/

# Grant permissions for the initialisation script to be executable
RUN chmod +x /usr/src/app/initialisation.sh

EXPOSE 1433

# Switch to the mssql user and run the entrypoint script
USER mssql
ENTRYPOINT /bin/bash ./entrypoint.sh