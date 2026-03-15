# CI/CD Process - Interactive Learning Guide

## 🎯 What Do You Want To Do?

### "I want to understand the ENTIRE process from start to finish"
**→ Read: `SETUP_NOTES.md` → Section "How CI/CD Works"**

### "I want a quick visual overview"
**→ Read: `CI_CD_QUICK_REFERENCE.md`**

### "I want to run tests locally first"
**→ Go to: [Local Testing Guide](#local-testing-options)**

### "I want to run tests automatically on GitHub"
**→ Go to: [GitHub Actions Setup](#github-actions-flow)**

### "I want to run tests automatically on GitLab"
**→ Go to: [GitLab CI Setup](#gitlab-ci-flow)**

### "Something is broken - help me debug"
**→ Go to: [Troubleshooting](#troubleshooting-decision-tree)**

---

## Local Testing Options

### Option 1: Run with Docker (Recommended for Consistency)

**Use Case**: Test locally before pushing (exactly same environment as CI)

**Steps**:
```bash
# 1. Navigate to project
cd /Users/anudeepkosuri/IdeaProjects/Selenium\ Project

# 2. Build Docker image
docker build -t selenium-tests:local .

# 3. Run tests in container
docker run --rm selenium-tests:local

# 4. View test output
# Tests execute, reports generated inside container
```

**Pros**: ✅ Exact same environment as GitHub/GitLab
**Cons**: ❌ Reports stay inside container, need docker cp to extract

---

### Option 2: Run with Maven Directly

**Use Case**: Quick local testing (no Docker overhead)

**Prerequisites**:
```bash
# Need these installed:
- Java 17
- Maven 3.9.6
- Google Chrome browser
```

**Steps**:
```bash
# 1. Navigate to project
cd /Users/anudeepkosuri/IdeaProjects/Selenium\ Project

# 2. Run Maven tests
mvn clean test -Dtest=SelectDateTest

# 3. View reports
open target/surefire-reports/index.html
# or
cat target/surefire-reports/TEST-SelectDateTest.xml
```

**Pros**: ✅ Fast, simple, reports directly on disk
**Cons**: ❌ Different environment than CI, requires local setup

---

### Option 3: Debug Individual Test in IDE

**Use Case**: Debug test failures, step-by-step execution

**Steps**:
```
1. Open SelectDateTest.java in IntelliJ
2. Right-click → Run 'SelectDateTest'
3. Or: Right-click → Debug 'SelectDateTest' (for debugging)
4. View execution in IDE console
5. Check target/surefire-reports/ after
```

**Pros**: ✅ Full debugging capabilities
**Cons**: ❌ Requires IDE, still only local

---

## GitHub Actions Flow

### How It Starts

```
You commit & push code
        ↓
GitHub webhook triggers
        ↓
GitHub Actions runner starts (ubuntu-latest)
        ↓
Workflow file executes:
.github/workflows/docker-image.yml
```

### What Happens Inside GitHub Actions

**Step 1: Checkout Code**
```yaml
- uses: actions/checkout@v4
  # Clone your repository
  # All files available for next steps
```

**Step 2: Create Directories**
```yaml
- run: mkdir -p reports
  # Prepare space for extracted reports
```

**Step 3: Build Docker Image**
```yaml
- run: docker build -t selenium-tests:latest .
  # Executes every line in Dockerfile
  # Installs: Maven, Java, Chrome, dependencies
  # Runs: mvn clean test -Dtest=SelectDateTest
  # Creates image ready for tests
```

**What Dockerfile Does**:
```
1. Start with Maven + Java 17 base image
2. Install Chrome browser + dependencies
3. Copy your project files
4. Run: mvn clean test -Dtest=SelectDateTest
5. Tests execute in headless Chrome
6. Reports generated: TEST-*.xml, index.html, etc.
7. Keep container alive with bash
```

**Step 4: Run Container & Extract Reports**
```yaml
- run: |
    docker run --name test-container -d \
      selenium-tests:latest sleep 3600
    sleep 10
    docker cp test-container:/app/target/surefire-reports/ ./reports/
    docker stop test-container
    docker rm test-container
  
  # 1. Start container in background (sleep keeps it alive)
  # 2. Wait 10 seconds for stability
  # 3. Copy reports from inside container to host machine
  # 4. Stop and remove container (cleanup)
```

**Why This Complex?**
- Tests run during Docker build (fast)
- But reports are inside container
- Need docker cp to extract them
- Can't use volumes on GitHub (permission issues)

**Step 5: List Extracted Reports**
```yaml
- run: |
    find ./reports -type f -name "*.xml"
    ls -la ./reports/
    
  # Show what was extracted
  # For debugging (make sure files exist)
```

---

## GitLab CI Flow

### How It Starts

```
You commit & push code
        ↓
GitLab webhook triggers
        ↓
GitLab CI runner starts
        ↓
Pipeline file executes:
.gitlab-ci.yml
```

### What Happens Inside GitLab CI

**Pipeline Configuration:**
```yaml
stages:
  - test
  # Define pipeline stages

run_selenium_tests:
  stage: test
  # This job runs in "test" stage
  
  image: docker:latest
  # Use Docker image as runner
  
  services:
    - docker:dind
  # Docker-in-Docker: allows docker commands inside container
  
  variables:
    DOCKER_HOST: unix:///var/run/docker.sock
    DOCKER_DRIVER: overlay2
  # Docker connection settings
  
  script:
    - docker build -t selenium-tests .
    - docker run --rm selenium-tests
  # Build image and run tests
  # "--rm" removes container after execution
  
  allow_failure: false
  # Pipeline fails if tests fail
```

### View Results on GitLab

**In Pipelines:**
1. Go to: GitLab.com → Your Repo → CI/CD → Pipelines
2. Click pipeline run
3. See "run_selenium_tests" job
4. Click job to see logs

**In Commits:**
1. Green checkmark ✅: All tests passed
2. Red X ❌: Tests failed
3. Click pipeline icon for details

**In MR (Merge Request):**
1. Pipeline status shown at top
2. Jobs listed below
3. Test output in job logs

---

## Troubleshooting Decision Tree

### "My workflow is red (failed)"

```
START
  ↓
Check workflow status
  ↓
┌─ STEP FAILED? ──────────────────┐
│                                 │
├─ Build Docker Image Failed?     │
│  └─ Check Dockerfile errors     │
│     └─ Go to: [Dockerfile Issues](#dockerfile-issues)
│
├─ Run Tests Failed?              │
│  └─ Check test execution        │
│     └─ Go to: [Test Failed](#test-failed)
│
└─ Extract Reports Failed?        │
   └─ Check docker cp             │
      └─ Go to: [Report Extraction](#report-extraction-failed)
```

### Dockerfile Issues

**Error**: Build step failed

**Diagnosis**:
```
1. Click "Build Docker Image" step
2. Look for error message
3. Common issues:
   - Chrome download failed (network issue)
   - Missing dependency
   - Invalid Dockerfile syntax
```

**Solutions**:

**Issue**: "Failed to download google-chrome"
```bash
# Chrome CDN might be down, retry:
git commit --allow-empty -m "Retry"
git push
```

**Issue**: "Package not found"
```bash
# Update pom.xml versions
# Rebuild locally first:
docker build -t selenium-tests .
```

**Issue**: "Invalid command"
```bash
# Check Dockerfile syntax
# Common: Missing space after RUN, WORKDIR, etc.
```

---

### Test Failed

**Error**: Test executed but failed

**Diagnosis**:
```
1. Click "Run Tests in Docker" step
2. Look for test output
3. Check for:
   - Element not found errors
   - Network issues
   - Timeout errors
   - Assertion failures
```

**Solutions**:

**Issue**: "NoSuchElementException"
```
Website element changed or not found
→ Update XPath in SelectDateTest.java
→ Test locally first
→ Then push to GitHub
```

**Issue**: "Connection refused"
```
Website is down or unreachable from GitHub
→ Check website is online
→ GitHub might not have network access
→ Use public website (already using one)
```

**Issue**: "Timeout waiting for element"
```
Website slow or element takes time to load
→ Increase timeout in SelectDateTest.java
→ Add explicit waits
→ Test locally to check
```

---

### Report Extraction Failed

**Error**: "docker cp failed" or "Reports directory empty"

**Diagnosis**:
```
1. Click "List extracted reports" step
2. Should show: TEST-SelectDateTest.xml found
3. If empty: reports not generated
```

**Solutions**:

**Issue**: "docker cp failed: no such file"
```
Reports not generated inside container

Causes:
1. Test never ran (Java/Maven issue)
2. Test ran but didn't generate reports
3. Maven plugins missing in pom.xml

Fix:
- Check Maven Surefire plugin in pom.xml
- Verify test actually executed (check logs)
- Ensure useFile: true in Surefire config
```

**Issue**: "container not found"
```
Container stopped before docker cp

Causes:
1. Container exited too quickly
2. Test process error crashed container

Fix:
- Increase sleep time before docker cp
- Check if tests actually execute
- Look at test errors above docker cp step
```

---

## Test Execution Details

### What Happens During Test Execution

```
Maven Phase: Test Execution
├─ Compile
│  ├─ javac src/main/java -> classes
│  └─ javac src/test/java -> test-classes
│
├─ Run Tests
│  ├─ Read testng.xml
│  ├─ Load SelectDateTest class
│  ├─ For each @Test method:
│  │  ├─ Call @BeforeTest (setup)
│  │  ├─ Execute @Test (test logic)
│  │  ├─ Call @AfterTest (teardown)
│  │  └─ Record result (PASS/FAIL)
│  │
│  └─ Generate Reports
│     ├─ TEST-SelectDateTest.xml (Surefire XML)
│     ├─ SelectDateTest.txt (text)
│     ├─ index.html (HTML summary)
│     └─ Others...
│
└─ Reports Location
   └─ target/surefire-reports/
```

### SelectDateTest Execution Breakdown

```
@BeforeTest (setUp method)
├─ WebDriverManager.chromedriver().setup()
│  └─ Download Chrome driver if needed
├─ ChromeOptions options = new ChromeOptions()
│  └─ Create driver options
├─ options.addArguments("--headless")
│  └─ Run Chrome without GUI (required in Docker)
├─ options.addArguments("--no-sandbox")
│  └─ Disable sandbox (Docker compatibility)
├─ options.addArguments("--disable-dev-shm-usage")
│  └─ Use /tmp instead of /dev/shm (memory)
├─ options.addArguments("--disable-gpu")
│  └─ Disable GPU (container doesn't have GPU)
├─ driver = new ChromeDriver(options)
│  └─ Launch Chrome browser with options
└─ driver.manage().window().maximize()
   └─ Maximize window

@Test (selectDateTest method)
├─ WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10))
│  └─ Create wait object (10 second timeout)
├─ driver.get("https://testautomationpractice.blogspot.com/")
│  └─ Navigate to website
├─ driver.findElement(By.xpath("//input[@id='start-date']"))
│  └─ Find input element with id='start-date'
└─ .sendKeys("12/09/2023")
   └─ Type date into input field

@AfterTest (tearDown method)
├─ if (driver != null)
│  └─ Check if driver exists
└─ driver.quit()
   └─ Close Chrome browser, free resources

Test Result
├─ If test passes all steps → PASSED ✅
└─ If any step fails → FAILED ❌

Report Generation
├─ Maven Surefire records result
├─ Generates TEST-SelectDateTest.xml
├─ Includes: test name, duration, status, error (if failed)
└─ HTML report shows summary and details
```

---

## Configuration Quick Checklist

### Before First Push

- [ ] **pom.xml**
  - [ ] Java 17 compiler set
  - [ ] Selenium dependency added
  - [ ] TestNG dependency added
  - [ ] WebDriverManager dependency added
  - [ ] Maven Surefire plugin configured
  - [ ] Maven Surefire Report plugin configured

- [ ] **testng.xml**
  - [ ] Test suite name specified
  - [ ] SelectDateTest class referenced
  - [ ] Parallel execution: false

- [ ] **Dockerfile**
  - [ ] Base image: maven:3.9.6-eclipse-temurin-17
  - [ ] Chrome installed
  - [ ] WORKDIR set to /app
  - [ ] Project copied
  - [ ] mvn clean test command runs
  - [ ] CMD allows container to stay alive

- [ ] **SelectDateTest.java**
  - [ ] @BeforeTest method sets up driver
  - [ ] Chrome options configured for headless
  - [ ] @Test method exists
  - [ ] @AfterTest method closes driver

- [ ] **.github/workflows/docker-image.yml**
  - [ ] Triggered on: push to main, PR to main
  - [ ] Permissions set correctly
  - [ ] Docker build step present
  - [ ] Docker run with sleep 3600 present
  - [ ] docker cp extraction present
  - [ ] Artifact upload present

### After Push

- [ ] Workflow ran (check Actions tab)
- [ ] All steps completed (green checkmarks)
- [ ] Reports extracted (check "List reports" step)
- [ ] Artifacts uploaded (check Artifacts section)

---

## Decision: GitHub Actions vs GitLab CI?

### Choose GitHub Actions If:
✅ Repository is on GitHub
✅ Want integrated PR checks
✅ Need simple, zero-config setup
✅ Want artifact storage (30 days free)

### Choose GitLab CI If:
✅ Repository is on GitLab
✅ Need more control over runner configuration
✅ Want to use self-hosted runners
✅ Need access to private container registry
✅ Want detailed pipeline visualization

### Can You Use Both?
Yes! Both .github/workflows/docker-image.yml and .gitlab-ci.yml can exist
- GitHub Actions runs on GitHub
- GitLab CI runs on GitLab
- No conflicts, independent execution

---

## Next Steps

### Start Here:
1. ✅ Read this guide
2. ✅ Read SETUP_NOTES.md
3. ✅ Read CI_CD_QUICK_REFERENCE.md
4. Run: `git push origin main`
5. Monitor: GitHub Actions tab

### After First Successful Run:
1. Celebrate! 🎉
2. Review test results
3. Download artifacts
4. Add more tests
5. Configure notifications

### Optimize:
1. Add more test classes
2. Update testng.xml to include them
3. Parallelize test execution
4. Add performance thresholds
5. Integrate with other tools

---

**Questions?** Check the relevant guide above, or examine the configuration files directly!
