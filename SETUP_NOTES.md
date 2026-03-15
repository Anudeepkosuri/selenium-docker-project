# Selenium Automation Project - Complete CI/CD Documentation

## Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Technology Stack](#technology-stack)
4. [Project Structure](#project-structure)
5. [How CI/CD Works](#how-cicd-works)
6. [Step-by-Step Flow](#step-by-step-flow)
7. [Configuration Files](#configuration-files)
8. [CI/CD Platforms](#cicd-platforms)
9. [How to Run](#how-to-run)
10. [Troubleshooting](#troubleshooting)

---

## Project Overview

This is a **Selenium Automation Testing Project** with integrated **CI/CD pipelines** that automatically run tests in Docker containers whenever code is pushed to GitHub or GitLab. The project demonstrates:

- ✅ Automated browser testing using Selenium WebDriver
- ✅ Containerized test execution with Docker
- ✅ Continuous Integration with GitHub Actions & GitLab CI
- ✅ Automated test report generation
- ✅ TestNG framework for test management

**Main Test**: `SelectDateTest.java` - Opens a website, fills in a date field in a web form

---

## Architecture

### High-Level Flow

```
Developer Push Code
        ↓
   [GitHub & GitLab]
        ↓
   [CI/CD Pipeline]
        ↓
   [Build Docker Image]
        ↓
   [Run Tests in Container]
        ↓
   [Generate Reports]
        ↓
   [Store Artifacts]
```

### Component Diagram

```
Project Repository
│
├─ Source Code
│  ├─ SelectDateTest.java (Selenium test)
│  ├─ WildcardTest.java (Another test)
│  └─ genericcy.java (Generic test class)
│
├─ Build Configuration
│  ├─ pom.xml (Maven build & dependencies)
│  ├─ testng.xml (TestNG test suite config)
│  └─ Dockerfile (Container specification)
│
├─ CI/CD Pipelines
│  ├─ .github/workflows/docker-image.yml (GitHub Actions)
│  └─ .gitlab-ci.yml (GitLab CI)
│
└─ Reports & Artifacts
   ├─ target/surefire-reports/ (Test reports inside Docker)
   └─ GitHub Actions Artifacts (Extracted reports)
```

---

## Technology Stack

### Core Technologies

| Component | Technology | Version | Purpose |
|-----------|-----------|---------|---------|
| **Programming Language** | Java | 17 | Write test automation code |
| **Testing Framework** | TestNG | 7.11.0 | Test management & execution |
| **Browser Automation** | Selenium WebDriver | 4.39.0 | Automate browser interactions |
| **Driver Management** | WebDriverManager | 5.6.3 | Automatic browser driver download |
| **Build Tool** | Maven | 3.9.6 | Project building & test execution |
| **Containerization** | Docker | Latest | Run tests in isolated environment |
| **CI/CD - GitHub** | GitHub Actions | Latest | GitHub-hosted CI/CD |
| **CI/CD - GitLab** | GitLab CI | Latest | GitLab-hosted CI/CD |
| **Data Handling** | Apache POI | 5.5.1 | Excel file processing |

### Dependencies (from pom.xml)

```xml
✅ Selenium Java - Browser automation
✅ TestNG - Test framework & management
✅ WebDriverManager - Automatic driver management
✅ Apache POI - Excel file handling
```

---

## Project Structure

```
Selenium Project/
│
├─ src/
│  ├─ main/
│  │  ├─ java/org/example/
│  │  │  └─ Main.java (Main application)
│  │  └─ resources/ (Configuration files)
│  │
│  └─ test/
│     └─ java/
│        ├─ SelectDateTest.java ⭐ (Primary test - runs in CI/CD)
│        ├─ WildcardTest.java (Secondary test)
│        └─ genericcy.java (Generic test utilities)
│
├─ target/ (Generated after build)
│  ├─ classes/ (Compiled main code)
│  ├─ test-classes/ (Compiled test code)
│  └─ surefire-reports/ (Test reports)
│     ├─ TEST-SelectDateTest.xml (Surefire XML format)
│     ├─ index.html (HTML report)
│     └─ SelectDateTest.txt (Text report)
│
├─ .github/
│  └─ workflows/
│     └─ docker-image.yml (GitHub Actions configuration)
│
├─ pom.xml (Maven project configuration)
├─ testng.xml (TestNG suite configuration)
├─ Dockerfile (Docker container specification)
├─ .gitlab-ci.yml (GitLab CI configuration)
└─ .gitignore (Git exclusions)
```

---

## How CI/CD Works

### Dual CI/CD Setup

This project is configured for **BOTH** GitHub Actions AND GitLab CI. Each platform has its own workflow:

#### **GitHub Actions** (PRIMARY - Recommended)
- **Trigger**: Push to `main` branch or Pull Request
- **Platform**: GitHub-hosted runners
- **Advantage**: Integrated with GitHub, easy artifact management
- **Reports**: Available as downloadable artifacts

#### **GitLab CI** (ALTERNATIVE)
- **Trigger**: Push to repository
- **Platform**: GitLab-hosted or self-hosted runners
- **Advantage**: Pipeline as code, detailed visualization
- **Reports**: Available in CI/CD pipeline logs

### Overall Process Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                   DEVELOPER WORKFLOW                            │
└─────────────────────────────────────────────────────────────────┘
                              ↓
                    Developer commits code
                              ↓
                  git push origin main
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│              GITHUB ACTIONS TRIGGERED                           │
│         (.github/workflows/docker-image.yml)                    │
└─────────────────────────────────────────────────────────────────┘
                              ↓
        ┌───────────────────────────────────────┐
        │    Step 1: Checkout Code              │
        │  - Clone repository                   │
        │  - Access all project files           │
        └───────────────────────────────────────┘
                              ↓
        ┌───────────────────────────────────────┐
        │  Step 2: Create Directories           │
        │  - mkdir -p reports                   │
        │  - Create space for extracted reports │
        └───────────────────────────────────────┘
                              ↓
        ┌───────────────────────────────────────┐
        │   Step 3: Build Docker Image          │
        │  - docker build -t selenium-tests     │
        │  - Executes Dockerfile commands       │
        └───────────────────────────────────────┘
                              ↓
                ┌──────────────────────────┐
                │ DOCKERFILE EXECUTION     │
                │ (Inside Docker Build)    │
                └──────────────────────────┘
                              ↓
        ┌───────────────────────────────────────┐
        │  FROM maven:3.9.6-eclipse-temurin-17 │
        │  - Base image with Maven & Java 17    │
        └───────────────────────────────────────┘
                              ↓
        ┌───────────────────────────────────────┐
        │  Install System Dependencies          │
        │  - wget, curl, gnupg, fonts           │
        │  - Chrome libraries (libgtk, libnss3) │
        └───────────────────────────────────────┘
                              ↓
        ┌───────────────────────────────────────┐
        │  Install Google Chrome                │
        │  - Download & install Chrome .deb     │
        │  - Required for Selenium automation   │
        └───────────────────────────────────────┘
                              ↓
        ┌───────────────────────────────────────┐
        │  WORKDIR /app                         │
        │  - Set working directory in container │
        └───────────────────────────────────────┘
                              ↓
        ┌───────────────────────────────────────┐
        │  COPY . .                             │
        │  - Copy project files into container  │
        └───────────────────────────────────────┘
                              ↓
        ┌───────────────────────────────────────┐
        │  RUN mvn clean test                   │
        │  -Dtest=SelectDateTest                │
        │                                       │
        │  Maven Command:                       │
        │  - clean: Remove old artifacts        │
        │  - test: Run test phase               │
        │  - -Dtest=SelectDateTest: Run only    │
        │    the SelectDateTest class           │
        └───────────────────────────────────────┘
                              ↓
        ┌──────────────────────────────────────────────────┐
        │  MAVEN TEST EXECUTION PROCESS                    │
        │                                                  │
        │  1. Compile source code                          │
        │  2. Compile test code                            │
        │  3. Execute test lifecycle:                      │
        │     - @BeforeTest methods                        │
        │     - @Test methods (actual tests)               │
        │     - @AfterTest methods (cleanup)               │
        │  4. Generate test reports:                       │
        │     - TEST-SelectDateTest.xml (Surefire format)  │
        │     - index.html (HTML report)                   │
        │     - SelectDateTest.txt (Text report)           │
        │  5. Place reports in:                            │
        │     - /app/target/surefire-reports/              │
        └──────────────────────────────────────────────────┘
                              ↓
        ┌───────────────────────────────────────┐
        │  TEST EXECUTION (SelectDateTest.java) │
        │                                       │
        │  @BeforeTest:                         │
        │  - Setup WebDriver                    │
        │  - Configure Chrome options           │
        │  - Enable headless mode               │
        │  - Launch browser                     │
        │                                       │
        │  @Test:                               │
        │  - Navigate to website                │
        │  - Find date input element            │
        │  - Enter date: "12/09/2023"           │
        │  - Verify test passed                 │
        │                                       │
        │  @AfterTest:                          │
        │  - Close browser                      │
        │  - Clean up resources                 │
        └───────────────────────────────────────┘
                              ↓
        ┌──────────────────────────────────────────────────┐
        │  TEST RESULTS                                    │
        │                                                  │
        │  If PASSED (✅):                                 │
        │  - Generate success report                       │
        │  - Export TEST-SelectDateTest.xml                │
        │  - Mark as passed                                │
        │                                                  │
        │  If FAILED (❌):                                 │
        │  - Generate failure report                       │
        │  - Include error stack trace                     │
        │  - Mark as failed                                │
        │  - Still export reports (with failures)          │
        └──────────────────────────────────────────────────┘
                              ↓
        ┌───────────────────────────────────────┐
        │  Dockerfile Verification              │
        │  - List contents of target directory  │
        │  - Verify surefire-reports generated  │
        │  - CMD ["bash"] - keep container live │
        └───────────────────────────────────────┘
                              ↓
                [Docker Image Built Successfully]
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│         RETURN TO GITHUB ACTIONS WORKFLOW                       │
└─────────────────────────────────────────────────────────────────┘
                              ↓
        ┌───────────────────────────────────────────────────┐
        │  Step 4: Run Tests & Extract Reports             │
        │                                                  │
        │  docker run --name test-container -d \           │
        │    selenium-tests:latest sleep 3600              │
        │                                                  │
        │  - Starts container in detached mode            │
        │  - Container stays alive (sleeps 3600 sec)      │
        │  - Allows time to extract files                 │
        │  - Reports already generated during build       │
        └───────────────────────────────────────────────────┘
                              ↓
        ┌───────────────────────────────────────────────────┐
        │  Extract Reports from Container                  │
        │                                                  │
        │  docker cp test-container:\                      │
        │    /app/target/surefire-reports/ \               │
        │    ./reports/                                    │
        │                                                  │
        │  - Copies all reports from container            │
        │  - Places them in ./reports/ on host            │
        │  - Makes them accessible to GitHub Actions     │
        └───────────────────────────────────────────────────┘
                              ↓
        ┌───────────────────────────────────────┐
        │  Stop & Clean Container               │
        │  - docker stop test-container         │
        │  - docker rm test-container           │
        │  - Free up resources                  │
        └───────────────────────────────────────┘
                              ↓
        ┌───────────────────────────────────────────────────┐
        │  Step 5: List Extracted Reports                  │
        │                                                  │
        │  find ./reports -name "*.xml"                    │
        │                                                  │
        │  Output:                                         │
        │  ./reports/surefire-reports/                    │
        │  ├── TEST-SelectDateTest.xml ✅                 │
        │  ├── index.html ✅                              │
        │  └── SelectDateTest.txt ✅                       │
        └───────────────────────────────────────────────────┘
                              ↓
        ┌───────────────────────────────────────────────────┐
        │  Step 6: Upload Artifacts                        │
        │  (uses: actions/upload-artifact@v4)             │
        │                                                  │
        │  - Uploads ./reports/ directory                  │
        │  - Available for 30 days                         │
        │  - Downloadable from GitHub Actions             │
        │  - Visible in Artifacts tab                      │
        └───────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                    FINAL RESULT                                 │
│                                                                 │
│  ✅ Workflow Completed                                          │
│  ✅ Tests Executed                                              │
│  ✅ Reports Generated                                           │
│  ✅ Artifacts Available                                         │
│                                                                 │
│  View in GitHub:                                                │
│  - Actions tab: See workflow run details                        │
│  - Artifacts: Download test reports                            │
```

---

## Step-by-Step Flow

### Flow Diagram: From Code Push to Test Results

```
1. DEVELOPER COMMITS & PUSHES
   └─ git add .
   └─ git commit -m "message"
   └─ git push origin main

2. GITHUB/GITLAB DETECTS PUSH
   └─ Webhook triggered
   └─ CI/CD pipeline starts

3. GITHUB ACTIONS WORKFLOW BEGINS
   └─ Runner allocated (ubuntu-latest)
   └─ Workspace created

4. CHECKOUT CODE
   └─ Clone repository
   └─ All files available

5. BUILD DOCKER IMAGE
   └─ Read Dockerfile
   └─ Execute each RUN command
   └─ Install dependencies
   └─ Run Maven tests (inside Docker)
   └─ Generate reports (inside Docker)
   └─ Create image layer

6. RUN CONTAINER & EXTRACT REPORTS
   └─ Start container
   └─ Wait for stability
   └─ Use docker cp to extract files
   └─ Stop and remove container

7. UPLOAD ARTIFACTS
   └─ Compress reports
   └─ Upload to GitHub
   └─ Store for 30 days

8. COMPLETE
   └─ Workflow finished
   └─ Results visible in GitHub
```

---

## Configuration Files

### 1. **pom.xml** - Maven Build Configuration

```xml
Purpose: Define project build, dependencies, and plugins

Key Sections:

<modelVersion>4.0.0</modelVersion>
- Maven project model version

<groupId>org.example</groupId>
<artifactId>SeleniumProject</artifactId>
<version>1.0-SNAPSHOT</version>
- Project identification

<properties>
  <maven.compiler.source>17</maven.compiler.source>
  <maven.compiler.target>17</maven.compiler.target>
- Compile Java 17 code

<dependencies>
  ✅ Selenium - Browser automation
  ✅ TestNG - Test framework
  ✅ WebDriverManager - Auto driver management
  ✅ Apache POI - Excel handling

<build><plugins>
  ✅ maven-surefire-plugin
     - Runs tests
     - Generates TEST-*.xml reports
     - Configuration:
       * useFile: true (generate files)
       * disableXmlReport: false (keep XML enabled)
       * suiteXmlFiles: testng.xml (use TestNG suite)

  ✅ maven-surefire-report-plugin
     - Generates HTML reports
     - Creates index.html
```

### 2. **testng.xml** - TestNG Test Suite Configuration

```xml
Purpose: Define which tests to run and test suite settings

<suite name="Selenium Test Suite" parallel="false">
- Single test suite, no parallel execution

<test name="SelectDateTest">
- Test group name

<classes>
  <class name="SelectDateTest"/>
- Specifies which test class to run

Result: Only SelectDateTest.java runs, others ignored
```

### 3. **Dockerfile** - Container Build Specification

```dockerfile
Purpose: Create Docker image with all dependencies and test environment

Base Image:
  FROM maven:3.9.6-eclipse-temurin-17
  - Pre-installed: Maven 3.9.6, Java 17, Linux OS

Install Dependencies:
  RUN apt-get update && apt-get install -y \
    wget curl gnupg ca-certificates \
    fonts-liberation libasound2 \
    libatk-bridge2.0-0 libatk1.0-0 \
    libgbm1 libgtk-3-0 libnss3 \
    libx11-xcb1 libxcomposite1 \
    libxdamage1 libxrandr2 xdg-utils
  - Required libraries for Chrome to run

Install Chrome:
  RUN wget -q https://dl.google.com/linux/direct/\
      google-chrome-stable_current_amd64.deb
  - Download Chrome browser
  - Install .deb package

Setup Workspace:
  WORKDIR /app
  - Container working directory

Copy Code:
  COPY . .
  - Copy entire project into container

Run Tests:
  RUN mvn clean test -Dtest=SelectDateTest || true
  - Execute: Maven clean test for SelectDateTest
  - "|| true" ensures container doesn't stop if test fails

Verify:
  RUN echo "Contents:" && ls -la target/ && \
      ls -la target/surefire-reports/
  - Display generated files for debugging

Default Command:
  CMD ["bash"]
  - Keep container running with bash shell
```

### 4. **.github/workflows/docker-image.yml** - GitHub Actions Workflow

```yaml
Purpose: Define CI/CD pipeline steps in GitHub Actions

Trigger Events:
  on:
    push:
      branches: [ main ]
    pull_request:
      branches: [ main ]
  - Run on push to main or PR to main

Permissions:
  permissions:
    contents: read
    checks: write
    pull-requests: write
  - Allow workflow to write checks and PR comments

Jobs:
  test:
    runs-on: ubuntu-latest
    - Use GitHub-hosted Ubuntu runner

Steps:

1. Checkout Code
   uses: actions/checkout@v4
   - Clone repository

2. Create Reports Directory
   run: mkdir -p reports
   - Create space for reports

3. Build Docker Image
   run: docker build -t selenium-tests:latest .
   - Build from Dockerfile
   - Tag as selenium-tests:latest

4. Run Tests & Extract
   run: |
     docker run --name test-container -d \
       selenium-tests:latest sleep 3600
     sleep 10
     docker cp test-container:/app/target/\
       surefire-reports/ ./reports/
     docker stop test-container
     docker rm test-container
   - Start container in background
   - Extract reports using docker cp
   - Clean up container

5. List Reports
   run: find ./reports -type f -name "*.xml"
   - Show extracted report files for debugging

6. Upload Artifacts
   uses: actions/upload-artifact@v4
   with:
     name: test-reports
     path: reports/
     retention-days: 30
   - Upload reports to GitHub
   - Keep for 30 days
   - Downloadable from Actions tab
```

### 5. **.gitlab-ci.yml** - GitLab CI Configuration (Alternative)

```yaml
Purpose: CI/CD pipeline for GitLab (alternative to GitHub Actions)

stages:
  - test
- Define pipeline stage

run_selenium_tests:
  stage: test
  - Execute in test stage

  image: docker:latest
  - Use Docker image runner

  services:
    - docker:dind
  - Docker-in-Docker service (allows docker commands)

  variables:
    DOCKER_HOST: unix:///var/run/docker.sock
    DOCKER_DRIVER: overlay2
  - Docker connection settings

  script:
    - docker build -t selenium-tests .
    - docker run --rm selenium-tests
  - Build image and run container
  - "--rm" removes container after execution

  allow_failure: false
  - Pipeline fails if tests fail
```

---

## CI/CD Platforms

### GitHub Actions (PRIMARY)

**Advantages:**
- ✅ Native GitHub integration
- ✅ No extra configuration needed
- ✅ Free for public/private repos
- ✅ Easy artifact management
- ✅ Results shown on PRs
- ✅ Detailed logs and debugging

**How to Use:**
```
1. Code is in GitHub repository
2. Push to main branch
3. GitHub Actions automatically triggers
4. Workflow file: .github/workflows/docker-image.yml
5. See results in Actions tab
6. Artifacts downloadable for 30 days
```

**View Results:**
- GitHub.com → Your Repo → Actions tab
- Click workflow run
- Expand steps for details
- Download artifacts

### GitLab CI (ALTERNATIVE)

**Advantages:**
- ✅ Alternative if using GitLab
- ✅ Can use self-hosted runners
- ✅ Detailed pipeline visualization
- ✅ Built-in container registry

**How to Use:**
```
1. Code is in GitLab repository
2. Push to main branch
3. GitLab CI automatically triggers
4. Workflow file: .gitlab-ci.yml
5. See results in CI/CD → Pipelines
6. Logs available in pipeline details
```

**View Results:**
- GitLab.com → Your Repo → CI/CD → Pipelines
- Click pipeline run
- See stage details
- View logs

---

## How to Run

### Option 1: Automatic (GitHub/GitLab)

```bash
# Simply push code to trigger pipeline
git add .
git commit -m "Your commit message"
git push origin main

# Then monitor:
# GitHub: Go to Actions tab
# GitLab: Go to CI/CD > Pipelines
```

### Option 2: Local Execution (Docker)

```bash
# Build Docker image locally
docker build -t selenium-tests:local .

# Run tests in container
docker run --rm selenium-tests:local

# Output: Tests run, reports generated inside container
```

### Option 3: Local Execution (Maven Direct)

```bash
# Install Java 17 and Maven locally
# Install Chrome browser

# Run tests directly
mvn clean test -Dtest=SelectDateTest

# Reports generated in: target/surefire-reports/
```

---

## Troubleshooting

### Issue 1: "Could not find any files for test-reports/**/*.xml"

**Cause**: Reports not extracted from Docker container

**Solution**:
```
1. Check "List extracted reports" step in workflow logs
2. Verify docker cp command ran successfully
3. Ensure container stayed running (sleep 3600)
4. Check container name: test-container
```

### Issue 2: "Unsupported file format: testng-results.xml"

**Cause**: EnricoMi action received TestNG XML (not Surefire format)

**Solution**:
```
Already fixed in pom.xml configuration:
- useFile: true (generates Surefire format)
- Pattern changed to: TEST-*.xml (only Surefire)
- TestNG native XML excluded
```

### Issue 3: Tests Fail in Pipeline but Pass Locally

**Cause**: 
- Chrome options different in container
- Network/URL access issues
- Timezone differences

**Solution**:
```
1. Check Docker logs: docker logs test-container
2. Verify Chrome runs in headless mode (already configured)
3. Verify website is accessible from GitHub
4. Check test timeouts
```

### Issue 4: "403 Forbidden" GitHub Action Error

**Cause**: Missing permissions or token issues

**Solution**:
```
Already fixed with permissions block:
permissions:
  contents: read
  checks: write
  pull-requests: write
```

### How to Debug

**Local Docker Testing:**
```bash
# Build image
docker build -t selenium-tests .

# Run with output
docker run -it selenium-tests

# Inspect generated reports
docker run -it selenium-tests bash
# Inside container: ls -la /app/target/surefire-reports/
```

**GitHub Actions Logs:**
```
1. Go to GitHub Actions tab
2. Click failing workflow run
3. Expand "Run Tests & Extract Reports" step
4. See docker cp output and errors
5. Check file paths and permissions
```

---

## Key Points to Remember

### Test Execution Flow
1. **Code Push** → GitHub/GitLab
2. **Webhook** → Trigger CI/CD
3. **Docker Build** → Install deps + run tests
4. **Report Generation** → Inside Docker
5. **Extract Reports** → From container to host
6. **Store Artifacts** → Available for download

### Report Formats

| Format | Generated By | Used By | Location |
|--------|-------------|---------|----------|
| TEST-*.xml | Maven Surefire | GitHub Actions, CI tools | target/surefire-reports/ |
| index.html | Maven Surefire Report | Human reading | target/site/ |
| *.txt | Maven Surefire | Log viewing | target/surefire-reports/ |

### File Path Flow

```
Inside Docker Container:
/app/target/surefire-reports/TEST-SelectDateTest.xml

Extracted to Host:
./reports/surefire-reports/TEST-SelectDateTest.xml

Published by GitHub Actions:
Visible in Actions → Artifacts tab
```

### Important Configurations

```
Maven: pom.xml
- Surefire plugin: Runs tests, generates XML
- Report plugin: Generates HTML
- Dependencies: Selenium, TestNG, WebDriverManager

Docker: Dockerfile
- Base: Maven + Java 17 + Linux
- Installs: Chrome + all required libraries
- Runs: mvn clean test -Dtest=SelectDateTest

GitHub Actions: .github/workflows/docker-image.yml
- Builds Docker image
- Runs container
- Extracts reports
- Stores artifacts

TestNG: testng.xml
- Specifies which test class to run
- Controls test suite execution
```

---

## Summary

This is a **complete automated testing infrastructure**:

✅ **Write Tests** → SelectDateTest.java (Selenium)
✅ **Configure Build** → pom.xml (Maven + plugins)
✅ **Containerize** → Dockerfile (Docker)
✅ **Automate** → GitHub Actions (CI/CD)
✅ **Report** → Surefire XML + HTML (Results)
✅ **Store** → Artifacts available for download

**Every push triggers a fully automated test run with reports!**
