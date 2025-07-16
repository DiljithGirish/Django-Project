# ────────── AWS & project scaffold ──────────
aws_region            = "us-east-1"
project_name          = "Django-Nextjs-Project"

# ECS logical names (must match what you’ll reference in CI/CD)
ecs_cluster_name      = "django-nextjs-cluster"
backend_service_name  = "backend-service"
frontend_service_name = "frontend-service"

# ────────── Container images (full ECR URIs) ──────────
backend_image  = "830105350342.dkr.ecr.us-east-1.amazonaws.com/backend-repository:latest"
frontend_image = "830105350342.dkr.ecr.us-east-1.amazonaws.com/frontend-repository:latest"

# ────────── Fargate task sizing (can override later) ──────────
cpu    = 256   # 0.25 vCPU
memory = 512   # MiB

# ────────── Networking ──────────
vpc_id = "vpc-01086682b94dd1db1"

subnet_ids = [
  "subnet-003d1169a097a3436",
  "subnet-0c83fa94eb3630c1d"
]

