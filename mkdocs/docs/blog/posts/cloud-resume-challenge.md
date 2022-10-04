---
hide:
  - navigation
  - toc
---

# Cloud Resume Challenge

## The project

This project is my take on the [Cloud Resume Challenge](https://cloudresumechallenge.dev){:target="_blank"}.
This is a 16-step project that aims to familiarize its participants with the fundaments of modern cloud architecture.

It started as a basic HTML page with a bit of CSS and a basic Javascript counter using https://api.countapi.xyz.

It growed into a static site generator with a self hosted counter (in progress).

## Pre-requisite
IAM user for Terraform with Access keys and permissions to Route53, API Gateway, CloudFront, CertificateManager, KeyManagementService, DynamoDB,S3,Lambda, CloudWatch, IAM.

## Workflow

```
insert diagram here
```

- Terraform Cloud: When I push -> Deploy ressources with Terraform
- Gitlab Actions: When I push -> Generate site folder -> copy to s3 bucket -> invalidate CloudFront



## To-do

- access-keys is bad, SSO?
- <del>fix gitlab workflow<del>
- fix invalidate in CloudFront
- fix terraform running "module.lambda.null_resource.archive[0]" on each run.
- <del>fix blog path: /blog/index.html<del>
- <del>fix security headers<del>
