# This is a simple aws practice

### deploy nginx as frontend and tomcat as backend server using autoscaling group in in different AZ

Since this is a pratice, I will try to use different solution for cross AZ implementation

## Backend

* Written in **Java** 
* Framework **SpringBoot**
* Built Tool **Maven** 
* Packaging **ami** by **Hashicorp Packer**
* Host **AWS EC2**
* Scale **AWS Autoscaling Group**
* LoadBalance **AWS ALB**
* source files `/src/backend/`

## Frontend

* Written in **JavaScript**
* Framework **ReactJS**
* Built Tool **NPM** 
* Packaging **docker image** by **Docker file (Terraform local-exec)**
* Host **AWS ECS**
* Scale **AWS Autoscaling Group**
* LoadBalance **AWS ALB**
* source files `/src/frontend/`

## DB

* Java prevayler

## CI/CD
Using GitLab, building in progress
![Alt text](cicd.png?raw=true "Title")

## Diagram
![Alt text](infrastructure.png?raw=true "Title")