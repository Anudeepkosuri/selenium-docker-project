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

# Copy project files
COPY . .

# Run tests with verbose output
RUN mvn clean test -Dtest=SelectDateTest -DfailIfNoTests=false || true

# List all directories created to verify test execution
RUN echo "=== Listing /app/target ===" && \
    ls -la /app/target/ || echo "No target directory"

RUN echo "=== Listing /app/target/surefire-reports ===" && \
    ls -la /app/target/surefire-reports/ 2>/dev/null || echo "No surefire-reports directory yet"

RUN echo "=== Looking for any XML files ===" && \
    find /app/target -name "*.xml" -type f 2>/dev/null || echo "No XML files found"

# Default command - keep container alive
CMD ["bash"]
