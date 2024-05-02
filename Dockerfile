#Grab the latest alpine image
FROM python:3.8-slim

WORKDIR /app

COPY requirements.txt .

# Install python and pip
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
# Expose 80
EXPOSE 80

# $PORT is set by Heroku			
CMD gunicorn --bind 0.0.0.0:$PORT main:app
