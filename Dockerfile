FROM maven:3.9.6-eclipse-temurin-11 AS build

WORKDIR /app

COPY . .

RUN mvn clean package -DskipTests

FROM tomcat:10.1-jdk11

COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]