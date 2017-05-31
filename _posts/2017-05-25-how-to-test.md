---
title: 'How to run our Dockerfiles'

layout: nil
---

1. You must open a shell inside the folder of the question you want to run:
`docker build -t question .`

2. After that, you will build the image. The images that are not successfully built demonstrate a problem during the system environment configuration described at the question.

3. If your image is successfully built, you can test with: `docker run -p <port>:<port> question`
You must substitute the __port__ parameter with the port described in the Dockerfile/application. Usually 3000, 5000 or 8000.
