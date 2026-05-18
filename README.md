# AI Digital Twin

> An AI-powered chatbot that represents me — answering questions about my background, skills, and experience as if you were talking to me directly.

Built as a full-stack, cloud-native application and deployed entirely on AWS, this project demonstrates end-to-end ownership: from infrastructure-as-code and serverless backend to a modern React frontend, with a fully automated CI/CD pipeline using GitHub Actions and OIDC.

---

## Portfolio

This project is featured on my portfolio at **[okeyobia.com](https://okeyobia.com)**, which includes a link to this repo and a full architecture breakdown.

---

## What It Does

The AI Digital Twin is a chatbot that knows who I am — my skills, work history, current projects, and interests. Visitors can have a natural conversation with it as if speaking to me directly. The agent is powered by Amazon Bedrock and maintains per-session conversation memory in S3, so responses stay context-aware throughout the session.

---

## Architecture

```text
User
 │
 ▼
CloudFront (CDN + HTTPS)
 │
 ├──► S3 (Next.js static frontend)
 │
 └──► API Gateway (HTTP API)
          │
          ▼
       Lambda (Python / FastAPI)
          │
          ├──► Amazon Bedrock (Nova Micro — AI responses)
          │
          └──► S3 (conversation memory per session)
```

Infrastructure is fully modularized in Terraform across six focused modules: `s3`, `acm`, `cloudfront`, `lambda`, `api_gateway`, and `dns`.

---

## Tech Stack

| Layer          | Technology                                          |
| -------------- | --------------------------------------------------- |
| Frontend       | Next.js 16, React 19, TypeScript, Tailwind CSS 4   |
| Backend        | Python, FastAPI, Mangum (Lambda adapter)            |
| AI             | Amazon Bedrock — Amazon Nova Micro                  |
| Hosting        | AWS S3 + CloudFront                                 |
| API            | AWS API Gateway (HTTP API)                          |
| Compute        | AWS Lambda (Python 3.12)                            |
| Memory         | AWS S3 (per-session JSON)                           |
| IaC            | Terraform (modular)                                 |
| CI/CD          | GitHub Actions + OIDC (keyless AWS auth)            |
| Package Manager| uv (Python), npm (Node)                             |

---

## Project Structure

```text
twin/
├── frontend/              # Next.js application
│   ├── app/               # App Router pages
│   └── components/        # UI components
├── backend/               # Python Lambda function
│   ├── server.py          # FastAPI application
│   ├── lambda_handler.py  # Lambda entrypoint (Mangum)
│   ├── context.py         # Memory & session management
│   ├── resources.py       # AWS resource helpers
│   ├── me.txt             # AI personality / system prompt
│   └── deploy.py          # Lambda packaging script
├── terraform/             # Infrastructure as Code
│   ├── main.tf            # Root module — wires everything together
│   ├── variables.tf
│   ├── outputs.tf
│   └── modules/
│       ├── s3/            # Memory + frontend buckets
│       ├── acm/           # ACM certificate + DNS validation
│       ├── cloudfront/    # CloudFront distribution
│       ├── lambda/        # IAM role + Lambda function
│       ├── api_gateway/   # HTTP API + routes
│       └── dns/           # Route53 alias records
├── scripts/
│   ├── deploy.sh          # Full deploy: Lambda → Terraform → Frontend
│   └── destroy.sh         # Tear down environment
└── .github/workflows/
    ├── deploy.yml         # CI/CD: deploy on push to main
    └── destroy.yml        # Manual: destroy an environment
```

---

## CI/CD Pipeline

Every push to `main` triggers a fully automated deployment:

```text
Push to main
     │
     ▼
GitHub Actions
     │
     ├── Assume AWS role via OIDC (no long-lived credentials)
     ├── Package Lambda (uv + Python 3.12)
     ├── Terraform init → plan → apply
     ├── Build Next.js static site
     ├── Sync to S3
     └── Invalidate CloudFront cache
```

Authentication uses **GitHub OIDC** — no AWS access keys are stored as secrets. The GitHub Actions runner exchanges a short-lived OIDC token for temporary AWS credentials via `sts:AssumeRoleWithWebIdentity`.

Environments (`dev`, `test`, `prod`) are managed via Terraform workspaces and GitHub Environments.

---

## Local Development

### Prerequisites

- Node.js 20+
- Python 3.12+
- [uv](https://github.com/astral-sh/uv)
- Terraform 1.0+
- AWS CLI configured

### Backend

```bash
cd backend
uv sync
uv run uvicorn server:app --reload --port 8000
```

### Frontend

```bash
cd frontend
npm install
echo "NEXT_PUBLIC_API_URL=http://localhost:8000" > .env.local
npm run dev
```

---

## Deployment

### First-time setup

Copy the environment config and configure your AWS credentials:

```bash
cp .env.example .env
# Edit .env with your AWS account ID and region
```

### Deploy to dev

```bash
./scripts/deploy.sh dev
```

This script:

1. Packages the Lambda function
2. Runs `terraform apply` to provision/update infrastructure
3. Builds the Next.js static site
4. Syncs the build to S3

### Destroy an environment

```bash
./scripts/destroy.sh dev
```

### Environment variables

| Variable             | Description                                  |
| -------------------- | -------------------------------------------- |
| `AWS_ACCOUNT_ID`     | Your AWS account ID                          |
| `DEFAULT_AWS_REGION` | Target AWS region (e.g. `us-east-2`)         |
| `PROJECT_NAME`       | Resource name prefix (default: `twin`)       |

---

## Infrastructure Highlights

- **Modular Terraform** — six purpose-scoped modules with clean input/output contracts, no circular dependencies
- **Keyless CI/CD** — GitHub OIDC eliminates the need for long-lived AWS credentials in secrets
- **CloudFront + S3** — static frontend served globally with HTTPS enforced
- **Serverless backend** — Lambda scales to zero, no idle compute cost
- **Per-session memory** — conversation history persisted in S3, enabling context-aware responses across turns
- **Custom domain support** — optional ACM + Route53 wiring via `use_custom_domain = true`

---

## About Me

I'm a DevOps Cloud Engineer focused on building scalable infrastructure, automating delivery pipelines, and exploring the intersection of AI and platform engineering.

This project is a live demonstration of those skills. Visit my portfolio to see the architecture and find a link to this repo, or dive straight into the code.

**[okeyobia.com](https://okeyobia.com) · [LinkedIn](https://linkedin.com/in/okeyobia) · [GitHub](https://github.com/okeyobia)**
