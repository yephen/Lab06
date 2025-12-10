# Lab 06

This lab is mostly set up for you to explore docker, I have provided a docker file and a docker-compose file. The docker file creates an image for our website. The website is a simple python program that saves and retrives coordinates from a database and displays them on the table. The docker compose file creates 3 things. It set up the backend database to store the coordinates we want to save, runs the front end based on the image built from the Dockerfile, and starts a mineraft server.


## Commands
+ Start all the docker-compose services
    `docker-compose up --build -d`
+ Stop all the docker-compose services
    `docker-compose down`
+ Build just the frontend image
    `docker-compose build frontend`
+ Stop an individual service
    `docker-compose stop <container name>`
+ Start an individual container
    `docker-compose start <container name>`
