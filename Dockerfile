FROM maven:3.9.9-eclipse-temurin-17-alpine AS build
ADD . /app
WORKDIR /app
RUN mvn package 

FROM eclipse-temurin:17-jre-alpine

LABEL org.opencontainers.image.authors="Anupam Developer" \
      org.opencontainers.image.version="2.0" \
      org.opencontainers.image.title="Spring Pet Clinic" \
      org.opencontainers.image.description="Spring Pet Clinic Multistage Dockerfile" \
      org.opencontainers.image.url="https://github.com/spring-projects/spring-petclinic"

# Run as a non-root user
RUN addgroup -S spring && adduser -S spring -G spring

WORKDIR /usr/share/spring-petclinic

COPY --from=build /app/target/spring-petclinic-4.0.0-SNAPSHOT.jar /usr/share/spring-petclinic/spring-petclinic.jar

USER spring:spring

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/usr/share/spring-petclinic/spring-petclinic.jar"]
