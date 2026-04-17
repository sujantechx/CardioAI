# CardioAI Deployment Guide

## 📋 Table of Contents
1. [Local Development](#local-development)
2. [Docker Deployment](#docker-deployment)
3. [Railway Deployment](#railway-deployment)
4. [AWS Deployment](#aws-deployment)
5. [Google Cloud Run](#google-cloud-run)
6. [DigitalOcean](#digitalocean)
7. [Production Checklist](#production-checklist)

---

## 🏠 Local Development

### Backend Setup

```bash
# Navigate to backend directory
cd backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run development server
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

**Access Points:**
- API: `http://localhost:8000`
- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

### Frontend Setup

```bash
# Get Flutter dependencies
flutter pub get

# Run on connected device or emulator
flutter run

# For web development
flutter run -d web-server --web-port=5000
```

---

## 🐳 Docker Deployment

### Using Docker Compose (Easiest)

```bash
# Build and start all services
docker-compose up --build

# Run in background
docker-compose up -d --build

# View logs
docker-compose logs -f backend

# Stop services
docker-compose down
```

### Manual Docker Build

```bash
# Build image
docker build -t cardioai-backend:latest .

# Run container
docker run -d \
  --name cardioai-backend \
  -p 8000:8000 \
  -e DEVICE=cpu \
  -e LOG_LEVEL=INFO \
  cardioai-backend:latest

# View logs
docker logs -f cardioai-backend

# Stop container
docker stop cardioai-backend
docker rm cardioai-backend
```

### Push to Docker Registry

```bash
# Docker Hub
docker tag cardioai-backend:latest your-username/cardioai-backend:latest
docker push your-username/cardioai-backend:latest

# AWS ECR
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin \
  123456789.dkr.ecr.us-east-1.amazonaws.com

docker tag cardioai-backend:latest \
  123456789.dkr.ecr.us-east-1.amazonaws.com/cardioai-backend:latest

docker push 123456789.dkr.ecr.us-east-1.amazonaws.com/cardioai-backend:latest
```

---

## 🚀 Railway Deployment (Recommended for MVP)

### Step 1: Prepare Repository
```bash
git init
git add .
git commit -m "Initial CardioAI commit"
git branch -M main
git remote add origin https://github.com/your-username/cardioai.git
git push -u origin main
```

### Step 2: Connect to Railway

1. Go to [railway.app](https://railway.app)
2. Sign up with GitHub
3. Create new project → "Deploy from GitHub repo"
4. Select your CardioAI repository
5. Railway auto-detects Dockerfile

### Step 3: Configure Environment Variables

In Railway Dashboard:
```
DEVICE=cpu
LOG_LEVEL=INFO
PYTHONUNBUFFERED=1
```

### Step 4: Custom Domain (Optional)

1. In Railway: Project → Settings → Domains
2. Add custom domain or use Railway-provided domain
3. Update Flutter app with new API endpoint

### Cost Estimate
- **Free Tier**: $5 credit/month
- **Pay-as-you-go**: ~$0.10/hour for standard compute
- **Monthly estimate**: $5-20

---

## 🏢 AWS Deployment (Production-Grade)

### Architecture
```
ALB (Application Load Balancer)
  ↓
ECS Fargate (Containerized Backend)
  ↓
RDS (Optional, for database)
S3 (For model storage)
CloudWatch (Monitoring)
```

### Step 1: Create ECS Cluster

```bash
# Create cluster
aws ecs create-cluster --cluster-name cardioai-cluster

# Create task definition
aws ecs register-task-definition --cli-input-json file://ecs-task-def.json
```

**ecs-task-def.json:**
```json
{
  "family": "cardioai-backend",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "512",
  "memory": "1024",
  "containerDefinitions": [
    {
      "name": "cardioai-backend",
      "image": "123456789.dkr.ecr.us-east-1.amazonaws.com/cardioai-backend:latest",
      "portMappings": [
        {
          "containerPort": 8000,
          "hostPort": 8000,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {"name": "DEVICE", "value": "cpu"},
        {"name": "LOG_LEVEL", "value": "INFO"}
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/cardioai-backend",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
}
```

### Step 2: Create Load Balancer & Service

```bash
# Create service
aws ecs create-service \
  --cluster cardioai-cluster \
  --service-name cardioai-service \
  --task-definition cardioai-backend \
  --desired-count 2 \
  --launch-type FARGATE \
  --load-balancers targetGroupArn=arn:aws:elasticloadbalancing:...,containerName=cardioai-backend,containerPort=8000
```

### Cost Estimate
- **ECS Fargate**: ~$30/month (512 CPU, 1GB RAM)
- **ALB**: ~$16/month
- **Data Transfer**: ~$5-20/month
- **Total**: ~$50-70/month

---

## ☁️ Google Cloud Run

### Step 1: Build & Push Image

```bash
# Configure gcloud
gcloud auth configure-docker

# Build image
docker build -t gcr.io/your-project/cardioai-backend:latest .

# Push to GCR
docker push gcr.io/your-project/cardioai-backend:latest
```

### Step 2: Deploy to Cloud Run

```bash
gcloud run deploy cardioai-backend \
  --image gcr.io/your-project/cardioai-backend:latest \
  --platform managed \
  --region us-central1 \
  --memory 1Gi \
  --cpu 1 \
  --timeout 300 \
  --set-env-vars DEVICE=cpu,LOG_LEVEL=INFO \
  --allow-unauthenticated
```

### Cost Estimate
- **Per 1M requests**: $0.40
- **Compute time**: $0.00002400 per vCPU-second
- **Typical monthly**: $5-30 (depending on usage)

---

## 💧 DigitalOcean

### Step 1: Create Droplet

```bash
# Create via doctl CLI
doctl compute droplet create cardioai-backend \
  --region nyc3 \
  --image docker-20-04 \
  --size s-1vcpu-1gb
```

### Step 2: SSH & Deploy

```bash
# SSH into droplet
ssh root@your_droplet_ip

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Clone repository
git clone https://github.com/your-username/cardioai.git
cd cardioai

# Deploy
docker-compose up -d
```

### Configure Reverse Proxy (Nginx)

```bash
# Install Nginx
apt-get update && apt-get install -y nginx certbot python3-certbot-nginx

# Create config file
cat > /etc/nginx/sites-available/cardioai << 'EOF'
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

# Enable config
ln -s /etc/nginx/sites-available/cardioai /etc/nginx/sites-enabled/
nginx -t
systemctl reload nginx

# Get SSL certificate
certbot --nginx -d your-domain.com
```

### Cost Estimate
- **1vCPU, 1GB RAM Droplet**: $6/month
- **Floating IP** (optional): $3/month
- **Backups** (optional): +$1.20/month
- **Total**: ~$12-15/month

---

## ✅ Production Checklist

### Backend API
- [ ] Enable HTTPS/TLS
- [ ] Setup API authentication (JWT)
- [ ] Implement rate limiting
- [ ] Add request logging
- [ ] Setup error tracking (Sentry)
- [ ] Configure CORS properly
- [ ] Use environment variables for secrets
- [ ] Setup database for persistence
- [ ] Implement caching (Redis)
- [ ] Add monitoring & alerting
- [ ] Setup automated backups
- [ ] Test all API endpoints
- [ ] Load test the API
- [ ] Setup CI/CD pipeline

### Database (if using)
- [ ] Use managed database service
- [ ] Enable automated backups
- [ ] Setup read replicas for scaling
- [ ] Configure SSL connections
- [ ] Setup connection pooling
- [ ] Monitor query performance

### Security
- [ ] Run vulnerability scanner
- [ ] Use secrets manager (AWS Secrets Manager, HashiCorp Vault)
- [ ] Enable DDoS protection
- [ ] Setup WAF (Web Application Firewall)
- [ ] Implement input validation
- [ ] Use secure headers
- [ ] Regular security audits

### Monitoring & Logging
- [ ] Setup centralized logging (CloudWatch, ELK, Datadog)
- [ ] Configure performance monitoring (New Relic, Datadog)
- [ ] Setup alerting for errors
- [ ] Monitor resource usage (CPU, Memory, Disk)
- [ ] Track API response times
- [ ] Log all API requests

### Flutter App
- [ ] Update API endpoint to production URL
- [ ] Disable debug logs
- [ ] Enable code obfuscation
- [ ] Setup crash reporting
- [ ] Test on multiple devices
- [ ] Optimize app size
- [ ] Setup app versioning

### Deployment
- [ ] Setup automated deployments
- [ ] Create rollback procedures
- [ ] Document deployment process
- [ ] Train team on deployment
- [ ] Test disaster recovery
- [ ] Setup health checks
- [ ] Monitor uptime

---

## 🔄 CI/CD Pipeline Example (GitHub Actions)

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy CardioAI

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: |
          cd backend
          pip install -r requirements.txt
      
      - name: Run tests
        run: |
          cd backend
          pytest tests/ -v

  build-and-push:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Build Docker image
        run: docker build -t cardioai-backend:${{ github.sha }} .
      
      - name: Push to registry
        run: |
          docker login -u ${{ secrets.DOCKER_USERNAME }} -p ${{ secrets.DOCKER_PASSWORD }}
          docker tag cardioai-backend:${{ github.sha }} \
            ${{ secrets.DOCKER_USERNAME }}/cardioai-backend:latest
          docker push ${{ secrets.DOCKER_USERNAME }}/cardioai-backend:latest

  deploy:
    needs: build-and-push
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to Railway
        env:
          RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN }}
        run: |
          npm install -g @railway/cli
          railway up --service cardioai-backend
```

---

## 📊 Cost Comparison

| Platform | Monthly Cost | Setup Time | Scalability | Best For |
|----------|-------------|-----------|------------|----------|
| **Railway** | $5-20 | <10 min | ⭐⭐⭐ | MVP, Startups |
| **AWS** | $50-200 | 30 min | ⭐⭐⭐⭐⭐ | Production |
| **GCP Cloud Run** | $5-50 | 15 min | ⭐⭐⭐⭐ | Variable load |
| **DigitalOcean** | $12-25 | 20 min | ⭐⭐⭐ | Small teams |

---

## 🆘 Troubleshooting

### Model Loading Issues
```bash
# Check if models exist
ls -la backend/lib/model/

# Download models if missing
python backend/core/model_repository.py --download
```

### GPU Not Available
```bash
# Check CUDA installation
nvidia-smi

# Run with CPU fallback
export DEVICE=cpu
docker-compose up
```

### Memory Issues
```bash
# Increase container memory limits
# In docker-compose.yml:
deploy:
  resources:
    limits:
      memory: 2G
    reservations:
      memory: 1G
```

---

## 📞 Support

For deployment issues:
1. Check logs: `docker-compose logs backend`
2. Test health endpoint: `curl http://localhost:8000/health`
3. Check API docs: `http://localhost:8000/docs`

---

**Last Updated**: March 2026

