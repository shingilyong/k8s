FROM openjdk:8-jdk-alpine
VOLUME /tmp
ADD ./target//CodePressoSB-0.0.1-SNAPSHOT.jar app.jar
ENV JAVA_OPTS=""
ENTRYPOINT ["java","-jar","/app.jar"]
