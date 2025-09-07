# ===============================
# Stage 1: Build the application
# ===============================
FROM maven:3.9.9-eclipse-temurin-17 AS builder
WORKDIR /workspace

# Copy pom.xml and mvnw first for better caching
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# Ensure Maven wrapper is executable
RUN chmod +x mvnw

# Download dependencies without building (caching layer)
RUN ./mvnw -B dependency:resolve dependency:resolve-plugins || true

# Now copy the full source code
COPY src ./src

# Build the Spring Boot application
RUN ./mvnw -B clean package -DskipTests

# ===============================
# Stage 2: Create runtime image
# ===============================
FROM eclipse-temurin:17-jre-jammy AS runtime
WORKDIR /app

# Create non-root user for security
RUN useradd --create-home --shell /bin/bash appuser
USER appuser

# Copy the built JAR from the builder stage
COPY --from=builder --chown=appuser:appuser /workspace/target/spring-petclinic-*.jar /app/app.jar

# Expose default port
EXPOSE 8080

# Optimize JVM for containers + disable problematic process metrics
ENV JAVA_OPTS="-XX:+UseContainerSupport \
               -XX:MaxRAMPercentage=75.0 \
               -Djava.security.egd=file:/dev/./urandom \
               -Dmanagement.metrics.enable.process=false"

# Run the application
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
