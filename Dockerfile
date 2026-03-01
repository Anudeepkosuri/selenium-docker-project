# Base image with Maven + Java
FROM maven:3.9.6-eclipse-temurin-17

# Install required packages
FROM maven:3.9.6-eclipse-temurin-17

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    unzip \


# Install Google Chrome
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y ./google-chrome-stable_current_amd64.deb \
    || apt --fix-broken install -y

# Set working directory inside container
WORKDIR /app

# Copy project files into container
COPY . .

# Run Maven tests
CMD ["mvn", "clean", "test"]