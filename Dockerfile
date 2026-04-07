# ===== BUILD STAGE =====
FROM maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR /app

COPY backend/pom.xml .
RUN mvn -B -q -e -DskipTests dependency:go-offline

COPY backend/src ./src

RUN mvn clean package -Dmaven.test.skip=true

# ===== RUN STAGE =====
FROM eclipse-temurin:21-jdk

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

ENV PORT=8080

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]