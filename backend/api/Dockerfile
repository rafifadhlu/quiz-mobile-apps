FROM python:3.12-slim

# Install system dependencies, including psql
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    postgresql-client \
 && rm -rf /var/lib/apt/lists/*


# set work directory
WORKDIR /app

# install all dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# copy project
COPY . .
COPY .env.prod .

# set env to production
ARG ENV=prod

# run entrypoint.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
