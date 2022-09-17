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
[Author](#book-author)

<img src="https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg" alt="Awesome Badge"/>
<img src="https://img.shields.io/pypi/status/ansicolortags.svg" alt="Stars Badge"/>

</div>

<br />

Welcome to `abomis-airports` repository!

Within this repository you will find a reference solution for [API proxy][apigee-api-proxy] CI/CD Azure pipeline for [Apigee][apigee] using [Apigee Deploy Maven Plugin][apigee-deploy-mvn] & [Apigee Config Maven Plugin][apigee-config-mvn].

![API Management Livecycle][apigee-api-management-cicd]

> :memo: **Note:** This solution is following [apigee/devrel CI/CD][apigee-devrel-cicd] guidelines and example.

## Key Features

- Supports Apigee X / Hybrid.
- Follows best practices.
- Decoupled CI/CD.
- High maintainabilty.
- Cost effective as your pipeline will only trigger to changes in source code.
- Highly flexible.

## Methodology

### 1. Tools and Dependencies

This solution is using:

- Static Apigee proxy code analysis using [apigeelint][apigee-automation-apigeelint] (standalone via node).
- Static JS code analysis using [eslint][apigee-automation-eslint] (standalone via node).
- JS resources unit testing using [mocha][apigee-automation-mocha] (standalone via node).
- Creation of Apigee configurations using [Apigee Config Maven Plugin][apigee-config-mvn] (in Maven via plugin).
- Packaging and deployment of the API proxy bundle using [Apigee Deploy Maven Plugin][apigee-deploy-mvn] (in Maven via plugin).
- Integration testing of the deployed proxy using [apickli][apigee-automation-apickli] + [CucumberJS][apigee-automation-cucumberjs] (standalone via node).
- CI/CD solution using [Azure Pipelines][azure-pipelines].

### 2. Folder Structure and Naming Conventions

An API developer will have to allocate single repository per API proxy where he can manage the proxy as a code:

- The repository name should be: `{COMPANY_NAME}-{API_NAME}`.
- The API proxy name on the organization should be: `{COMPANY_NAME}-{API_NAME}-{API_VERSION}`.
- The API proxy base path should be the same as your API proxy name.
- The API proxy base path should be: `/{COMPANY_NAME}-{API_NAME}/{API_VERSION}`.
- Within `pom.xml` file:
  
  ```xml
  <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <groupId>{GROUP_ID}</groupId>
    <artifactId>{PROXY_NAME}</artifactId>
    <version>{API_VERSION}</version>
    <name>{PROXY_NAME}${deployment.suffix}-${project.version}</name>
    ...
    <properties>
        <proxy.filename>{API_PROXY_ROOT_FILE}</proxy.filename>
        ...
    </properties>    
  </project>
  ```

  > :memo: **Notes:**

  - `{GROUP_ID}`: uniquely identifies your project across all projects. A group ID should follow Java's package naming rules. This means it starts with a reversed domain name you control. For example `com.abomis`.
  - `{PROXY_NAME}` should be your API proxy name without appending the version. For example `abomis-airports`.
  - `{VERSION}` should be your API version. For example `v1`.
  - `${deployment.suffix}` is a property that defaults to an empty string and you can customize it.
  - `{API_PROXY_ROOT_FILE}` should be equal to the name of the `.xml` file found at `apiproxy/` dir. For example `abomis-airports-v1.xml`.
  - Make sure that you update the following when you release a new API version:
    1. `<version></version>` within `pom.xml`.
    2. `<proxy.filename></proxy.filename>` with the new API proxy root file within the `pom.xml`
    3. Base path within your proxy source code with the new version.

- Folder structure:

  <pre>
  .
  ├── .eslintrc.json      // used to configure eslint tool
  ├── .gitignore.json
  ├── README.md
  ├── pom.xml
  ├── package.json
  ├── package-lock.json
  ├── apiproxy/           // your api proxy source code
  │   ├── {PROXY_NAME}-{VERSION}.xml
  │   ├── policies/
  │   ├── proxies/
  │   └── resources/
  ├── cicd/
  │   ├── build.yaml
  │   ├── release.yaml
  │   └── templates/
  ├── docs/
  │   └── assets/
  ├── resources
  │   └── edge/            // your api proxy config files
  └── test/
      ├── integration/     // your functional test scripts
      └── unit/            // your unit test scripts
  </pre>

  > :bulb: **Tip:** see resources/edge [multi-file config structure docs][apigee-config-mvn-folder-structure].

## The Why?

- Enterprises and teams should use source code control and CI/CD for proxy development and deployment (configuration management).
- Too easy to lose or overwrite revisions of your API when using the UI.

## Background

&nbsp;&nbsp;&nbsp;&nbsp;[Apigee][apigee] is a platform for developing and managing APIs. By fronting services with a proxy layer, Apigee provides an abstraction or facade for your backend service APIs and provides security, rate limiting, quotas, analytics, and more.

<div align="center">

![Apigee Overview Diagram][apigee-diagram]

</div>

&nbsp;&nbsp;&nbsp;&nbsp;Apigee enables you to provide secure access to your services with a well-defined API that is consistent across all of your services, regardless of service implementation. A consistent API:

- Makes it easy for app developers to consume your services.
- Enables you to change the backend service implementation without affecting the public API.
- Enables you to take advantage of the analytics, developer portal, and other features built into Apigee.

&nbsp;&nbsp;&nbsp;&nbsp;Rather than having app developers consume your services directly, they access an [API proxy][apigee-api-proxy] created on Apigee.

<div align="center">

![Apigee Proxy Model Diagram][apigee-proxy-model-v1]

:bulb: **Learn More:** [Understanding APIs and API proxies][apigee-docs-understanding-apis-and-proxies].

</div>

&nbsp;&nbsp;&nbsp;&nbsp;An API proxy is a thin application program interface that exposes a stable interface for an existing service or services.

&nbsp;&nbsp;&nbsp;&nbsp;API proxies allow developers to define an API without having to change underlying services in the back end. This works by decoupling the front-end API from the back-end services, which is what shields the app from code changes on the back end. The benefit to an API proxy is that it is essentially a simple and lightweight API gateway.

> An API proxy consists of a bundle of XML configuration files and code (such as JavaScript and Java).

----

## Getting Started

### 1. Prerequisites

- Existing Apigee X / Hybrid organization.
- Existing Apigee environment(s) & environment group(s).
- Existing two Azure DevOps pipelines with proper service connections:
  1. One for the build, suggested naming convention: `<REPO_NAME>-ci`.
  2. One for the release, suggesting naming convention: `<REPO_NAME>-cd`.
- Existing Azure DevOps environment(s).
- Technical knowledge of API proxy as code management and configuration (proxies, targets, policies, kvms,...etc).
- Technical knowledge of Azure DevOps pipelines to operate and customize the stages if needed.
- Preferred but not required to have technical knowledge of Maven's `pom.xml` file to customize your deployment if needed.
- Preferred but not required to have technical knowledge of Npm's `package.json` file to customize if needed.
- GCP service account with the following roles (or a custom role with all required permissions):
  - `apigee.environmentAdmin`
  - `apigee.apiAdmin`
  - `apigee.admin` *(Required only for **org-level** config)*

> :bulb: **Tip:** see [Apigee roles][apigee-docs-roles-list].

- Create service account key and download it's key:

```bash
gcloud iam service-accounts keys create "${SA_NAME}"-key.json --iam-account="${SA_EMAIL}" --key-file-type=json 
```

> :bulb: **Tip:** SA_EMAIL = {SA_NAME}@{PROJECT_ID}.iam.gserviceaccount.com

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

- Create Variable Groups for your pipeline following these naming conventions:
  - `<REPO_NAME>-common`:
    - For common variables that are the same on all environments.
    - Should contain:
      - `org`: Apigee's organization.
      - `proxyDesc`: Contains your API proxy description.
      - `gcpServiceAccount`: paste the content of your your GCP service account key file as a **WHOLE**.
      > :warning: **Warning:** Make sure to check "Keep this value secret".
  - `<REPO_NAME>-{ENVIRONMENT}-env`:
    - For variables that are environment dependent.
    - Should contain:
      - `env`: Apigee environment to deploy your API proxy to.
      - `hostname`: Your specified hostname within your environment group.
      > :warning: **Warning:** Make sure to properly configure your DNS to route your `hostname` to your Apigee organization.

- Update:
  - [build pipeline][build-pipeline-file] `variableGroups` param with your created `<REPO_NAME>-common` variable group.
  
  - [release pipeline][release-pipeline-file]:
    - The following are the supported params:
  
      ```yaml
      parameters:
        releaseProfile: {{ release_profile }} # which Azure DevOps environments to deploy to, currently 'custom-release' is the only supported value
        deploymentProfile: {{ deployment_profile }} # how to deploy your API proxy, currently 'mvn-plugins' is the only supported value
        artifactAlias: {{ build_pipeline_resource_identifier }} # can be specified in resources.pipelines[0].pipeline
        artifactName: {{ proxy_bundle_artifact_name }} # by default it is named 'proxy-bundle-artifacts' in your build pipeline
        commonVariableGroups:
          - {{ <REPO_NAME>-common }} # your common variables, for example 'abomis-airports-common'
        releaseList: # required for 'custom-release' release profile, specify list of your deployment environments
          - stageName: {{ stage_name }} # identifier for you stage, for example 'Dev'
            displayName: {{ display_name }} # display name shown in your release pipeline run, for example 'Dev'
            variableGroup: {{ <REPO_NAME>-<ENVIRONMENT>-env }} # your environment specific variables, for example 'abomis-airports-dev-env'
            environment: {{ azure_devops_environment }} # your deployment environment, for example 'abomis-dev'
          ...
        apigeeConfigList: # required if deploymentConfig.customApigeeConfig is true, contains all the list of configurations you wish to create only regardless of source code
          - {{ apigee_config_item }} # supported values are [references, keystores, aliases, targetservers, keyvaluemaps, resourcefiles, apiproducts, developers, reports, flowhooks]
          ...
        deploymentConfig: # (optional) alters the deployment templates framework behavior
          customApigeeConfig: {{ true || false }} # enable/disable custom apigee configuration creation, default is false and will attempt to create all the supported configs
      ```

- Configure:

  - Build pipeline YAML source to be at: `cicd/build.yaml`.
  
  - Release pipeline YAML source to be at: `cicd/release.yaml`.

- Run your build pipeline by clicking on "Run Pipeline" button.

- Check your build pipeline:

<div align="center">

![Pipeline 01][ado-pipeline-01]

</div>

- By default, your build pipeline was built to follow best practices by consuming all of the tests results to have a unified UI to see the tests results. It was also built to generate a coverage report to help you determine the proportion of your project's code that is actually being tested by your unit tests. click on the **"Tests"** tab:

<div align="center">

![Reports 01][ado-pipeline-02]
*Tests Results (Static Code Analysis + Unit Tests)*

</div>

<div align="center">

![Reports 02][ado-pipeline-03]
*Code Coverage Report*

</div>

- Your build pipeline produces two artifacts by default:
  - `proxy-bundle-artifacts` - Contains all of the artifacts needed by your release pipeline to deploy.
  - `Code Coverage Report_<id>` - Autogenerated by the build pipeline for your coverage report.

<div align="center">

![Artifacts][ado-pipeline-04]
*Pipeline Artifacts*

</div>

- On your `main`/`master`, your release pipeline will be auto triggered and start releasing your API proxy to your specified `releaseList` environments.

- Check your release pipeline:

<div align="center">

![Pipeline 02][ado-pipeline-release-01]

</div>

<div align="center">

![Pipeline 03][ado-pipeline-release-02]
*Production environment has been configured to require manual approval*

</div>

<div align="center">

![Pipeline 04][ado-pipeline-release-03]

</div>

- You can check your functional testing results in the **'Tests'** tab:

<div align="center">

![Reports 03][ado-pipeline-release-04]
*Tests Results (Functional Testing for 3 environments)*

</div>

- Check your Apigee organization's API proxies:

<div align="center">

![Proxies 01][apigee-proxies-01]

</div>

<div align="center">

![Proxies 02][apigee-proxies-02]

</div>

- Check your Apigee organization's developers:

<div align="center">

![Developers 01][apigee-config-developers-01]

</div>

<div align="center">

![Developers 02][apigee-config-developers-02]

</div>

> :memo: **Note:** Within the solution I added me as a [developer][apigee-config-developers-file] inside Apigee organization.

- Test your API proxy on all of your environments:

<div align="center">

![Proxies 03][apigee-proxies-live-dev]

</div>

<div align="center">

![Proxies 04][apigee-proxies-live-test]

</div>

<div align="center">

![Proxies 05][apigee-proxies-live-prod]

</div>

Congratulations! you have deployed your first API proxy successfully : )

<br />

## ⚔️ Developed By

<a href="https://www.linkedin.com/in/shehab-el-deen/" target="_blank"><img alt="LinkedIn" align="right" title="LinkedIn" height="24" width="24" src="docs/assets/imgs/linkedin.png"></a>

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
[build-pipeline-file]: cicd/build.yaml
[release-pipeline-file]: cicd/release.yaml
[apigee-config-developers-file]: resources/edge/org/developers.json

<!-- * Images * -->

[apigee-api-management-cicd]: docs/assets/imgs/apigee-api-management-cicd-.png
[apigee-diagram]: docs/assets/imgs/apigee-diagram.png
[apigee-proxy-model-v1]: docs/assets/imgs/apigee-proxy-model-v1.png
[ado-pipeline-01]: docs/assets/imgs/ado-pipeline-run.png
[ado-pipeline-02]: docs/assets/imgs/ado-pipeline-tests.png
[ado-pipeline-03]: docs/assets/imgs/ado-pipeline-coverage-report.png
[ado-pipeline-04]: docs/assets/imgs/ado-pipeline-artifacts.png
[ado-pipeline-release-01]: docs/assets/imgs/ado-pipeline-release-01.png
[ado-pipeline-release-02]: docs/assets/imgs/ado-pipeline-release-02.png
[ado-pipeline-release-03]: docs/assets/imgs/ado-pipeline-release-run.png
[ado-pipeline-release-04]: docs/assets/imgs/ado-pipeline-release-tests.png
[apigee-proxies-01]: docs/assets/imgs/apigee-proxies-01.png
[apigee-proxies-02]: docs/assets/imgs/apigee-proxies-02.png
[apigee-config-developers-01]: docs/assets/imgs/apigee-config-developers-01.png
[apigee-config-developers-02]: docs/assets/imgs/apigee-config-developers-02.png
[apigee-proxies-live-dev]: docs/assets/imgs/apigee-proxies-live-dev.png
[apigee-proxies-live-test]: docs/assets/imgs/apigee-proxies-live-test.png
[apigee-proxies-live-prod]: docs/assets/imgs/apigee-proxies-live-prod.png
