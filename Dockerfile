# Use the official MySQL image
FROM mysql:latest

# Copy the initialization script into the Docker image
COPY init.sql /docker-entrypoint-initdb.d/

# Make sure the script has the right permissions
RUN chmod a+r /docker-entrypoint-initdb.d/init.sql
