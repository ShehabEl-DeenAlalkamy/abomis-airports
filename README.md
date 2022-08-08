<!-- markdownlint-configure-file {
  "MD033": false,
  "MD041": false
} -->

<img src="docs/assets/imgs/abomis.png" alt="ABOMIS logo" title="ABOMIS" align="right" height="60"/>

# ABOMIS Airports Apigee API Proxy CI/CD

<div align="center">

[Key Features](#key-features) •
[Methodology](#methodology) •
[The Why?](#the-why) •
[Background](#background) •
[Getting Started](#getting-started) •
[Author](#⚔️-author)

<img src="https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg" alt="Awesome Badge"/>
<img src="https://img.shields.io/pypi/status/ansicolortags.svg" alt="Stars Badge"/>

</div>

<br />

Welcome to `abomis-airports` repository!

Within this repository you will find a reference solution for [API proxy][apigee-api-proxy] CI/CD Azure pipeline for [Apigee][apigee] using [Apigee Deploy Maven Plugin][apigee-deploy-mvn] & [Apigee Config Maven Plugin][apigee-config-mvn].

![API Management Livecycle][apigee-api-management-cicd]

> :memo: **Note:** This solution is following [apigee/devrel CI/CD][apigee-devrel-cicd] guidelines and example.

## Key Features

- Git branch dependent Apigee environment selection and proxy naming to allow deployment of feature branches as separate proxies in the same environment.
- Supports Apigee X/Hybrid.
- Supports Apigee Edge.
- Follows best practices.
- High maintainabilty.
- Cost effective as your pipeline will only trigger to changes in source code.
- Flexible.

> :memo: **Note:** Though this solution supports Apigee Edge, it's more Apigee X/Hybrid oriented.

## Methodology

### 1. Tools and Dependencies

This solution is using:

- Static Apigee proxy code analysis using [apigeelint][apigee-automation-apigeelint] (standalone via node).
- Static JS code analysis using [eslint][apigee-automation-eslint] (standalone via node).
- JS resources unit testing using [mocha][apigee-automation-mocha] (standalone via node).
- Packaging and deployment of Apigee configuration using
[Apigee Config Maven Plugin][apigee-config-mvn] (in Maven via plugin).
- Packaging and deployment of the API proxy bundle using [Apigee Deploy Maven Plugin][apigee-deploy-mvn] (in Maven via plugin).
- Integration testing of the deployed proxy using [apickli][apigee-automation-apickli] + [CucumberJS][apigee-automation-cucumberjs] (standalone via node).
- CI/CD solution using [Azure Pipelines][azure-pipelines].

### 2. Folder Structure and Naming Conventions

An API developer will have to allocate single repository per API proxy where he can manage the proxy as a code:

- The repository name should be: `{COMPANY_NAME}-{API_NAME}`.
- The API proxy name should be: `{COMPANY_NAME}-{API_NAME}`.
- The API proxy base path should be the same as your API proxy name.
- Within `pom.xml` file:
  
  ```xml
  <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <groupId>com.{COMPANY_NAME}</groupId>
    <artifactId>{PROXY_NAME}</artifactId>
    <name>{PROXY_NAME}${deployment.suffix}</name>
    ...
  </project>
  ```

  > :memo: **Note:** `${deployment.suffix}` is a property that defaults to an empty string and you can customize it.

- Folder structure:

  <pre>
  .
  ├── .eslintrc.json      // used to configure eslint tool
  ├── .gitignore.json
  ├── README.md
  ├── pom.xml
  ├── package.json
  ├── package-lock.json
  ├── apiproxy           // your api proxy source code
  │   ├── {PROXY_NAME}-{VERSION}.xml
  │   ├── policies
  │   ├── proxies
  │   └── resources
  ├── cicd
  │   ├── azure-pipelines.yaml
  │   └── templates
  ├── docs
  │   └── assets
  ├── resources
  │   └── edge            // your api proxy config files
  └── test
      ├── integration     // your functional test scripts
      └── unit            // your unit test scripts
  </pre>

  > :bulb: **Tip:** see resources/edge [multi-file config structure docs][apigee-config-mvn-folder-structure].

## The Why?

- Enterprises and teams should use source code control and CI/CD for proxy development and deployment (configuration management).
- Too easy to lose or overwrite revisions of your API when using the UI.

## Background

&nbsp;&nbsp;&nbsp;&nbsp;[Apigee][apigee] is a platform for developing and managing APIs. By fronting services with a proxy layer, Apigee provides an abstraction or facade for your backend service APIs and provides security, rate limiting, quotas, analytics, and more.

![Apigee Overview Diagram][apigee-diagram]

&nbsp;&nbsp;&nbsp;&nbsp;Apigee enables you to provide secure access to your services with a well-defined API that is consistent across all of your services, regardless of service implementation. A consistent API:

- Makes it easy for app developers to consume your services.
- Enables you to change the backend service implementation without affecting the public API.
- Enables you to take advantage of the analytics, developer portal, and other features built into Apigee.

&nbsp;&nbsp;&nbsp;&nbsp;Rather than having app developers consume your services directly, they access an [API proxy][apigee-api-proxy] created on Apigee.

![Apigee Proxy Model Diagram][apigee-proxy-model-v1]

> :bulb: **Learn More:** [Understanding APIs and API proxies][apigee-docs-understanding-apis-and-proxies].

&nbsp;&nbsp;&nbsp;&nbsp;An API proxy is a thin application program interface that exposes a stable interface for an existing service or services.

&nbsp;&nbsp;&nbsp;&nbsp;API proxies allow developers to define an API without having to change underlying services in the back end. This works by decoupling the front-end API from the back-end services, which is what shields the app from code changes on the back end. The benefit to an API proxy is that it is essentially a simple and lightweight API gateway

> An API proxy consists of a bundle of XML configuration files and code (such as JavaScript and Java).

----

## Getting Started

### 1. Prerequisites

#### 1.1. General

- Existing Apigee organization (X/Hybrid or Edge).
- Existing Apigee environment.
- Existing Azure DevOps pipeline with proper service connection.
- Technical knowledge of API proxy as code management and configuration (proxies, targets, policies, kvms,...etc).
- Technical knowledge of Azure DevOps pipelines to operate and customize the stages if needed.
- Preferred but not required to have technical knowledge of Maven's `pom.xml` file to customize your deployment if needed.
- Preferred but not required to have technical knowledge of Npm's `package.json` file to customize if needed.

#### 1.2. Apigee X/Hybrid

- GCP service account with the following roles (or a custom role with all required permissions):
  - `apigee.environmentAdmin`
  - `apigee.apiAdmin`
  - `apigee.admin` *(Required only for org-level config)*

> :bulb: **Tip:** see [Apigee roles][apigee-docs-roles-list].

- Create service account key and download it's key:

```bash
gcloud iam service-accounts keys create "${SA_NAME}"-key.json --iam-account="${SA_EMAIL}" --key-file-type=json 
```

> :bulb: **Tip:** SA_EMAIL = {SA_NAME}@{PROJECT_ID}.iam.gserviceaccount.com

#### 1.3. Apigee Edge

- Username and password.

> :memo: **Note:** Though this solution supports Apigee Edge, it's more Apigee X/Hybrid oriented.

### 2. Initialize a GitHub Repository

Create a GitHub repository

```bash
GIT_URL='https://github.com/ORG/REPO.git'
```

```bash
git clone https://github.com/ShehabEl-DeenAlalkamy/abomis-airports.git
cd abomis-airports
git init
git remote add origin2 "${GIT_URL}"
git checkout -b feature/cicd-pipeline
git add .
git commit -m "initial commit"
git push -u origin2 feature/cicd-pipeline
```

### 3. Run the Pipeline

#### Apigee X/Hybrid

- Edit [googleapi-vars.yaml][gapi-vars-file] with your values:
  - `org` - Apigee organization.
  - `env` - Apigee environment to deploy your API proxy to.
  - `envGroup` - Apigee environment group

  > :warning: **Warning:** Make sure to properly configure your DNS to route your environment group to your Apigee organization.

- Go to your pipeline and create `gcpServiceAccount` pipeline variable and paste the content of your [GCP service account](#12-apigee-xhybrid) key file as a **WHOLE**.

> :warning: **Warning:** Make sure to check "Keep this value secret".

#### Apigee Edge

- Edit [apigeeapi-vars.yaml][aapi-vars-file] with your values:
  - `org` - Apigee organization.
  - `env` - Apigee environment to deploy your API proxy to.
  - `username` - Your Apigee Edge username

- Go to your pipeline and create `edgePass` pipeline variable and paste the content of your username password.

> :warning: **Warning:** Make sure to check "Keep this value secret".

#### Next Steps

- Click on "Run Pipeline" button, choose one of the two choices:
  - `googleapi` - Apigee X/Hybrid deployment, selected by default.
  - `apigeeapi` - Apigee Edge deployment.

![Pipeline 01][ado-pipeline-01]

- Check your pipeline:

![Pipeline 02][ado-pipeline-02]

- By default, your pipeline will produce 5 artifacts. You can download them and check their content:
  - `functional-testing` - Holds integration testing reports.
  - `integration-test-scripts` - Holds target/test/integration scripts after building.
  - `proxy-bundle` - Holds your API proxy bundle zip file.
  - `static-code-analysis` - Holds your static code tests reports for both of the proxy code and your javascript resources.
  - `unit-testing` - Holds your unit testing reports.

![Artifacts][ado-pipeline-03]
*Pipeline Artifacts*

![Reports 01][artifacts-reports-01]
*Apigee Bundle Linter Report*

![Reports 02][artifacts-reports-02]
*ESLint Report*

![Reports 03][artifacts-reports-03]
*Mocha Report*

![Reports 04][artifacts-reports-04]
*Apickli + CucumberJS Report*

- Check your Apigee organization's API proxies:

![Proxies 01][apigee-proxies-01]

- Check your Apigee organization's developers:

![Developers 01][apigee-config-developers-01]

> :memo: **Note:** Within the solution I added me as a [developer][apigee-config-developers-file] inside Apigee organization.

- Test your API proxy:

![Proxies 03][apigee-proxies-live]

Congratulations! you have deployed your first API proxy successfully : )

<br />

## ⚔️ Developed By

<a href="https://www.linkedin.com/in/shehab-el-deen/"><img alt="LinkedIn" align="right" title="LinkedIn" height="24" width="24" src="docs/assets/imgs/linkedin.png"></a>

Shehab El-Deen Alalkamy

<br />

## :book: Author

Shehab El-Deen Alalkamy

<!--*********************  R E F E R E N C E S  *********************-->

<!-- * Links * -->

[apigee]: https://cloud.google.com/apigee/docs/api-platform/get-started/what-apigee
[apigee-deploy-mvn]: https://github.com/apigee/apigee-deploy-maven-plugin
[apigee-config-mvn]: https://github.com/apigee/apigee-config-maven-plugin
[apigee-api-proxy]: https://cloud.google.com/apigee/docs/api-platform/fundamentals/understanding-apis-and-api-proxies#:~:text=The%20Missing%20Link.-,What%20is%20an%20API%20proxy%3F,same%20API%20without%20any%20interruption.
[apigee-devrel-cicd]: https://github.com/apigee/devrel/tree/main/references/cicd-pipeline
[apigee-automation-apigeelint]: https://github.com/apigee/apigeelint#readme
[apigee-automation-eslint]: https://eslint.org/
[apigee-automation-mocha]: https://mochajs.org/
[apigee-automation-apickli]: https://github.com/apickli/apickli
[apigee-automation-cucumberjs]: https://github.com/cucumber/cucumber-js
[azure-pipelines]: https://azure.microsoft.com/en-us/services/devops/pipelines/
[apigee-config-mvn-folder-structure]: https://github.com/apigee/apigee-config-maven-plugin/tree/hybrid#multi-file-config
[apigee-docs-understanding-apis-and-proxies]: https://cloud.google.com/apigee/docs/api-platform/fundamentals/understanding-apis-and-api-proxies
[apigee-docs-roles-list]: https://cloud.google.com/iam/docs/understanding-roles#apigee-roles
[gapi-vars-file]: cicd/templates/vars/googleapi-vars.yaml
[aapi-vars-file]: cicd/templates/vars/apigeeapi-vars.yaml
[apigee-config-developers-file]: resources/edge/org/developers.json

<!-- * Images * -->

[pegasus]: docs/assets/imgs/pegasus-logo-png.png
[apigee-api-management-cicd]: docs/assets/imgs/apigee-api-management-cicd-.png
[apigee-diagram]: docs/assets/imgs/apigee-diagram.png
[apigee-proxy-model-v1]: docs/assets/imgs/apigee-proxy-model-v1.png
[ado-pipeline-01]: docs/assets/imgs/ado-pipeline-ui-run.png
[ado-pipeline-02]: docs/assets/imgs/ado-pipeline-run.png
[ado-pipeline-03]: docs/assets/imgs/ado-pipeline-artifacts.png
[artifacts-reports-01]: docs/assets/imgs/artifacts-reports-01.png
[artifacts-reports-02]: docs/assets/imgs/artifacts-reports-02.png
[artifacts-reports-03]: docs/assets/imgs/artifacts-reports-03.png
[artifacts-reports-04]: docs/assets/imgs/artifacts-reports-04.png
[apigee-proxies-01]: docs/assets/imgs/apigee-proxies-01.png
[apigee-config-developers-01]: docs/assets/imgs/apigee-config-developers-01.png
[apigee-proxies-live]: docs/assets/imgs/apigee-proxies-live.png
