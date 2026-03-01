# Use Maven + Java 17
FROM maven:3.9.6-eclipse-temurin-17

# Install required dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    gnupg \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libgbm1 \
    libgtk-3-0 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils

# Install Google Chrome
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y ./google-chrome-stable_current_amd64.deb \
    || apt --fix-broken install -y

# Set working directory
WORKDIR /app

# Copy project
COPY . .

# Run tests and generate reports
RUN mvn clean test -Dtest=SelectDateTest

# Create directory for reports
RUN mkdir -p /app/test-reports && \
    cp -r target/surefire-reports/* /app/test-reports/ 2>/dev/null || true && \
    cp -r target/site/surefire-report.html /app/test-reports/ 2>/dev/null || true

# Output for verification
CMD ["echo", "Tests completed. Check reports in target/surefire-reports/"]
