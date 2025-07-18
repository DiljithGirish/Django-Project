**How to Run, Deploy and Monitor this Application**


This application can be run in two ways- either manually via the Github Actions(Manual Trigger) or by pushing code changes to the master branch(Push trigger)

   Once the trigger is applied, the CI/CD pipeline starts to run and it will build the docker images, push it to AWS ECR and then deploy it to AWS ECS(built using terraform)
   and the public url will be displayed as an output

Monitoring can be done via AWS cloudwatch (Link will be generated as output)

There is another pipeline that is designed to destroy the resources built using terraform








