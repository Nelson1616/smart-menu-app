# how to run web version

first you need to build the docker image, to do this, run the following command in your terminal at the root of the project:

```
docker build -t flutter-web .  
```

then you need to run the image on a specific port on your machine:

```
docker run -d -p 8080:80 --name flutter-web flutter-web
```

to stop, run this command:

```
docker stop flutter-web
```