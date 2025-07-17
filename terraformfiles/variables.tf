variable "project_name" {
  description = "Project name prefix for AWS resources"
  type        = string
}

/* ---------- Images pushed to ECR ---------- */
variable "backend_image" {
  description = "Full ECR URI for the backend image (e.g. 123456789012.dkr.ecr.us-east-1.amazonaws.com/backend-repo:latest)"
  type        = string
}

variable "frontend_image" {
  description = "Full ECR URI for the frontend image (e.g. 123456789012.dkr.ecr.us-east-1.amazonaws.com/frontend-repo:latest)"
  type        = string
}

/* ---------- Fargate sizing ---------- */
variable "cpu" {
  description = "Fargate task CPU units"
  type        = number
  default     = 256        # 0.25 vCPU
}

variable "memory" {
  description = "Fargate task memory (in MiB)"
  type        = number
  default     = 512
}

/* ---------- Networking ---------- */
variable "subnet_ids" {
  description = "List of public subnet IDs where ECS tasks will run"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the VPC used by the public subnets"
  type        = string
}

/* ---------- Names injected into main.tf  ---------- */
variable "ecs_cluster_name" {
  description = "Name to give the ECS Cluster"
  type        = string
}

variable "backend_service_name" {
  description = "ECS Service name for the backend task"
  type        = string
}

variable "frontend_service_name" {
  description = "ECS Service name for the frontend task"
  type        = string
}

