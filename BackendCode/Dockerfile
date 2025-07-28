FROM maven:3.8.4-openjdk-17-slim AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre
WORKDIR /app
EXPOSE 8082
COPY --from=build /app/target/myapp.jar myapp.jar
ENTRYPOINT ["java", "-jar", "myapp.jar"]