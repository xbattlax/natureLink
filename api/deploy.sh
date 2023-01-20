#!/bin/bash
sudo docker stop chassemarche-api-container
sudo docker rm chassemarche-api-container
sudo docker rmi -f chassemarche-api

sudo docker build -t chassemarche-api .
sudo docker run --name chassemarche-api-container -dtp 8000:8000 chassemarche-api