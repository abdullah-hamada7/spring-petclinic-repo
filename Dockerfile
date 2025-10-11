FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

COPY target/spring-petclinic-*.jar /app/app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]