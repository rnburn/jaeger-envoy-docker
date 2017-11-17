#!/bin/sh
docker build -t envoyhello .
docker run -d -p 8080:8080 envoyhello
