# Quick Reference Guide - CI/CD Process Flow

## 📊 Visual Process Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                     DEVELOPER ACTION                            │
│                    git push origin main                         │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│              GITHUB/GITLAB WEBHOOK TRIGGERED                   │
│           CI/CD Pipeline Automatically Starts                   │
└─────────────────────────────────────────────────────────────────┘
                              ↓
        ╔═══════════════════════════════════════════╗
        ║   GITHUB ACTIONS WORKFLOW EXECUTION       ║
        ║  (.github/workflows/docker-image.yml)     ║
        ╚═══════════════════════════════════════════╝
                              ↓
        ┌─────────────────────────────────────────┐
        │ Step 1️⃣: Checkout Code                  │
        │ actions/checkout@v4                     │
        └─────────────────────────────────────────┘
                              ↓
        ┌─────────────────────────────────────────┐
        │ Step 2️⃣: Create Directories             │
        │ mkdir -p reports                        │
        └─────────────────────────────────────────┘
                              ↓
        ┌─────────────────────────────────────────┐
        │ Step 3️⃣: Build Docker Image             │
        │ docker build -t selenium-tests:latest .  │
        └─────────────────────────────────────────┘
                              ↓
        ╔═══════════════════════════════════════════╗
        ║  DOCKERFILE EXECUTION (Inside Build)      ║
        ║  ✅ Install Maven, Java 17                 ║
        ║  ✅ Install Chrome Browser                 ║
        ║  ✅ Copy Project Files                     ║
        ║  ✅ Run: mvn clean test                    ║
        ║  ✅ Generate Reports                       ║
        ║  ✅ Verify Files Exist                     ║
        ╚═══════════════════════════════════════════╝
                              ↓
        ┌─────────────────────────────────────────┐
        │ Step 4️⃣: Run Container & Extract         │
        │ docker run --name test-container        │
        │ docker cp /app/target/reports → ./      │
        │ docker stop & rm                        │
        └─────────────────────────────────────────┘
                              ↓
        ┌─────────────────────────────────────────┐
        │ Step 5️⃣: List Extracted Reports          │
        │ find ./reports -name "*.xml"            │
        │ Verify files extracted successfully     │
        └─────────────────────────────────────────┘
                              ↓
        ┌─────────────────────────────────────────┐
        │ Step 6️⃣: Upload Artifacts                │
        │ actions/upload-artifact@v4              │
        │ Store for 30 days                       │
        │ Downloadable from Actions tab           │
        └─────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────┐
│                    WORKFLOW COMPLETE                            │
│                                                                 │
│  ✅ Results visible in GitHub:                                  │
│     - Actions tab (workflow logs)                               │
│     - Artifacts (test reports download)                         │
│     - PR Checks (if running on PR)                              │
└─────────────────────────────────────────────────────────────────┘
```

## 🏗️ Architecture Layers

```
┌─────────────────────────────────────────────────────────────────┐
│  LAYER 5: GitHub Actions & Artifact Storage                    │
│  ├─ Orchestrates entire workflow                               │
│  ├─ Manages artifacts                                          │
│  └─ Stores test reports                                        │
├─────────────────────────────────────────────────────────────────┤
│  LAYER 4: Test Execution & Report Generation                    │
│  ├─ Maven runs tests                                           │
│  ├─ Surefire plugin generates TEST-*.xml                       │
│  ├─ Report plugin generates HTML                               │
│  └─ Reports stored in /app/target/surefire-reports/            │
├─────────────────────────────────────────────────────────────────┤
│  LAYER 3: Docker Container                                      │
│  ├─ Isolated test environment                                  │
│  ├─ Chrome browser installed                                   │
│  ├─ All dependencies installed                                 │
│  └─ Tests run in headless mode                                 │
├─────────────────────────────────────────────────────────────────┤
│  LAYER 2: Build Configuration                                   │
│  ├─ pom.xml (Maven dependencies & plugins)                     │
│  ├─ testng.xml (Test suite configuration)                      │
│  └─ Dockerfile (Container specification)                       │
├─────────────────────────────────────────────────────────────────┤
│  LAYER 1: Test Code                                             │
│  ├─ SelectDateTest.java (Primary test)                         │
│  ├─ Other test classes                                         │
│  └─ Selenium WebDriver automation                              │
└─────────────────────────────────────────────────────────────────┘
```

## 📁 File Flow

```
LOCAL REPOSITORY
│
├─ Source Code
│  └─ src/test/java/SelectDateTest.java
│
├─ Configuration
│  ├─ pom.xml
│  ├─ testng.xml
│  └─ Dockerfile
│
└─ CI/CD
   ├─ .github/workflows/docker-image.yml
   └─ .gitlab-ci.yml

                ⬇ git push ⬇

GITHUB REPOSITORY
│
├─ Triggers CI/CD
├─ GitHub Actions runs workflow
├─ Builds Docker image from Dockerfile
└─ Runs tests inside container

                ⬇ test execution ⬇

INSIDE DOCKER CONTAINER
│
├─ Maven reads pom.xml
├─ Compiles test code
├─ Executes SelectDateTest.java
├─ Generates TEST-*.xml reports
└─ Reports in /app/target/surefire-reports/

                ⬇ docker cp ⬇

HOST MACHINE (GitHub Actions Runner)
│
├─ ./reports/surefire-reports/
│  ├─ TEST-SelectDateTest.xml ✅
│  ├─ index.html ✅
│  └─ SelectDateTest.txt ✅
│
└─ Uploads to GitHub Artifacts

                ⬇ artifact storage ⬇

GITHUB RESULTS
│
├─ Actions Tab
│  ├─ Workflow logs
│  └─ Artifacts (downloadable)
│
└─ Commit Status
   └─ Pass/Fail indicator
```

## 🔄 Test Execution Lifecycle

```
┌─────────────────────────────────────┐
│  Test Class Loaded                  │
│  SelectDateTest.java                │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  @BeforeTest Method Runs            │
│  ├─ WebDriver initialized           │
│  ├─ Chrome options configured       │
│  │  ├─ --headless                   │
│  │  ├─ --no-sandbox                 │
│  │  ├─ --disable-dev-shm-usage      │
│  │  └─ --disable-gpu                │
│  ├─ Browser window maximized        │
│  └─ Ready for test                  │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  @Test Method Runs                  │
│  selectDateTest()                   │
│  ├─ Navigate to website             │
│  ├─ Find date input element         │
│  ├─ Enter date: "12/09/2023"        │
│  ├─ Wait for element                │
│  └─ Verify successful               │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  Test Result                        │
│  ├─ If SUCCESS → Mark as PASSED ✅   │
│  └─ If FAILURE → Mark as FAILED ❌   │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  @AfterTest Method Runs             │
│  ├─ Browser closed                  │
│  ├─ Resources released              │
│  └─ Cleanup completed               │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  Report Generation                  │
│  ├─ TEST-SelectDateTest.xml created │
│  ├─ index.html created              │
│  └─ SelectDateTest.txt created      │
└─────────────────────────────────────┘
```

## 🛠️ Configuration Summary

```
┌──────────────────────────────────────────────────────────────┐
│ pom.xml - Maven Build Configuration                          │
├──────────────────────────────────────────────────────────────┤
│ <properties>                                                 │
│   Java Compiler: 17                                          │
│ </properties>                                                │
│                                                              │
│ <dependencies>                                               │
│   ✅ Selenium Java 4.39.0                                    │
│   ✅ TestNG 7.11.0                                           │
│   ✅ WebDriverManager 5.6.3                                  │
│   ✅ Apache POI 5.5.1                                        │
│ </dependencies>                                              │
│                                                              │
│ <plugins>                                                    │
│   ✅ maven-surefire-plugin 3.1.2                             │
│      - Runs tests                                            │
│      - Generates TEST-*.xml                                  │
│      - useFile: true                                         │
│      - Executes testng.xml suite                             │
│                                                              │
│   ✅ maven-surefire-report-plugin 3.1.2                      │
│      - Generates HTML reports                               │
│      - Creates index.html                                    │
│ </plugins>                                                   │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│ Dockerfile - Container Build                                 │
├──────────────────────────────────────────────────────────────┤
│ FROM maven:3.9.6-eclipse-temurin-17                          │
│   └─ Base: Maven, Java 17, Linux                            │
│                                                              │
│ RUN apt-get install... (system libraries)                    │
│   └─ Chrome dependencies                                     │
│                                                              │
│ RUN wget google-chrome...deb                                 │
│   └─ Install Chrome browser                                  │
│                                                              │
│ WORKDIR /app                                                 │
│   └─ Working directory in container                          │
│                                                              │
│ COPY . .                                                     │
│   └─ Copy project into container                             │
│                                                              │
│ RUN mvn clean test -Dtest=SelectDateTest                     │
│   └─ Execute tests (generates reports)                       │
│                                                              │
│ CMD ["bash"]                                                 │
│   └─ Keep container running                                  │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│ testng.xml - Test Suite Configuration                        │
├──────────────────────────────────────────────────────────────┤
│ <suite name="Selenium Test Suite" parallel="false">          │
│   └─ Single suite, sequential execution                      │
│                                                              │
│ <test name="SelectDateTest">                                 │
│   └─ Test group name                                         │
│                                                              │
│ <classes>                                                    │
│   <class name="SelectDateTest"/>                             │
│   └─ Only SelectDateTest.java runs                           │
│ </classes>                                                   │
│ </test>                                                      │
│ </suite>                                                     │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│ .github/workflows/docker-image.yml - GitHub Actions          │
├──────────────────────────────────────────────────────────────┤
│ on:                                                          │
│   push: [main]                   ← Trigger on main push      │
│   pull_request: [main]           ← Trigger on PR             │
│                                                              │
│ permissions:                                                 │
│   contents: read                 ← Read code                 │
│   checks: write                  ← Write checks              │
│   pull-requests: write           ← Write PR comments         │
│                                                              │
│ jobs:                                                        │
│   test:                                                      │
│     runs-on: ubuntu-latest       ← GitHub-hosted runner     │
│                                                              │
│ steps:                                                       │
│   1. Checkout code                                           │
│   2. Create directories                                      │
│   3. Build Docker image                                      │
│   4. Run container & extract reports                         │
│   5. List extracted reports                                  │
│   6. Upload artifacts                                        │
└──────────────────────────────────────────────────────────────┘
```

## 📊 Report Locations

```
INSIDE DOCKER CONTAINER:
/app/target/surefire-reports/
├── TEST-SelectDateTest.xml     ← Surefire format (CI-friendly)
├── index.html                  ← HTML summary
└── SelectDateTest.txt          ← Text format

EXTRACTED TO HOST:
./reports/surefire-reports/
├── TEST-SelectDateTest.xml     ← Surefire format (CI-friendly)
├── index.html                  ← HTML summary
└── SelectDateTest.txt          ← Text format

GITHUB ARTIFACTS:
Actions > Artifacts > test-reports
├── surefire-reports/
│   └── (all extracted files)
└── Downloadable for 30 days
```

## ⚡ Quick Command Reference

```bash
# LOCAL TESTING (Docker)
docker build -t selenium-tests .
docker run --rm selenium-tests

# LOCAL TESTING (Maven Direct)
mvn clean test -Dtest=SelectDateTest

# VIEW REPORTS LOCALLY
cat target/surefire-reports/index.html

# GIT WORKFLOW
git add .
git commit -m "Your message"
git push origin main

# MONITOR PIPELINE
# GitHub: https://github.com/YourUsername/repo/actions
# GitLab: https://gitlab.com/YourUsername/repo/-/pipelines
```

## ✅ Verification Checklist

Before pushing to pipeline:

- [ ] SelectDateTest.java compiles locally
- [ ] pom.xml has all required plugins
- [ ] Dockerfile builds without errors
- [ ] testng.xml references correct test classes
- [ ] .github/workflows/docker-image.yml is valid YAML
- [ ] All file paths are correct
- [ ] No hardcoded localhost URLs (use actual website)

After pipeline runs:

- [ ] Workflow completed successfully (✅)
- [ ] Docker image built (✅)
- [ ] Tests executed (✅)
- [ ] Reports extracted (✅)
- [ ] Artifacts uploaded (✅)

## 🔗 Important Files & Locations

| What | File | Purpose |
|------|------|---------|
| **Test Code** | `src/test/java/SelectDateTest.java` | Main automation test |
| **Build Config** | `pom.xml` | Dependencies, plugins, properties |
| **Test Suite** | `testng.xml` | Which tests to run |
| **Docker** | `Dockerfile` | Container setup |
| **GitHub Actions** | `.github/workflows/docker-image.yml` | CI/CD pipeline |
| **GitLab CI** | `.gitlab-ci.yml` | Alternative CI/CD |
| **Reports (Inside)** | `/app/target/surefire-reports/` | Inside container |
| **Reports (Extracted)** | `./reports/surefire-reports/` | On host machine |

---

**Remember**: Every `git push` triggers automatic testing! 🚀
