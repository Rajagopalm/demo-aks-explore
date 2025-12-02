# Microservices Application Deployment with Docker & Kubernetes (AKS) Using Helm Charts

This project demonstrates a **microservices-based web application** deployed on **Azure Kubernetes Service (AKS)**. It integrates a modern DevOps lifecycle — from containerization to orchestration — using cloud-native tools and practices.

---

##  Architecture And Workflow
![Alt text](diagram-images/diagram1.png)

![Alt text](diagram-images/ss1.png)

![Alt text](diagram-images/ss2.png)

##  Project Overview

The application consists of multiple microservices:
- **Frontend Service** – A user-facing web interface built with modern frontend technologies.
- **Auth Service** – Handles user authentication.
- **User Service** – Manages user profiles and related data.
- **Survey Service** – Provides survey creation, participation, and results management.
- **Database** – MySQL used as the persistent data store.

Each service has its own **Dockerfile**, Kubernetes **Deployment**, **Service**, **ConfigMap**, **Horizontal Pod Autoscaler**, and **Secret** configuration.

---

##  Key Features

- Fully containerized microservices using **Docker**
- Managed orchestration using **Kubernetes (AKS)**
- **Helm Charts** for simplified deployment and management
- Secure environment variables using **ConfigMaps** and **Secrets**
- **Ingress Controller** for unified access to services
- **Horizontal Pod Autoscaling (HPA)** for scalability
- **Namespace isolation** for better environment organization
- Includes **frontend**, **backend microservices**, and **database integration**
- Configured **MySQL** an external environments (Railway/infinityFree/azure db service)
- Learned and implemented **debugging**, **cluster monitoring**, and **service discovery**

---

##  Kubernetes Components Used

| Component     | Description |
|----------------|-------------|
| **Deployment** | Defines pod replicas and manages application updates |
| **ReplicaSet (RS)** | Ensures the desired number of pod replicas are running |
| **Service** | Exposes the application to other pods or externally |
| **ConfigMap** | Stores non-sensitive configuration data |
| **Secret** | Stores sensitive information like database credentials |
| **Ingress** | Manages external access to the cluster |
| **HorizontalPodAutoscaler (HPA)** | Automatically scales pods based on CPU utilization |
| **Namespace** | Segregates and organizes cluster resources logically |
| **Helm Chart** | Package manager for Kubernetes deployments |

---

## Tools & Technologies

- **Docker** – Containerization
- **Kubernetes (AKS)** – Orchestration and deployment
- **Helm** – Kubernetes package manager for simplified deployments
- **MySQL** – Database management
- **Nginx Ingress Controller** – Routing and load balancing
- **kubectl** – Kubernetes CLI for managing resources
- **VS Code** – Development environment
- **Railway / Local MySQL** – Database hosting and testing

---

##  Helm Chart Deployment

### Helm Chart Structure
<pre>
helm-code-k8s/
├── Chart.yaml              # Chart metadata
├── values.yaml             # Configuration values
├── templates/              # Kubernetes manifest files
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── ingress.yaml
│   ├── _helpers.tpl
│   ├── hpa.yaml
│   └── services/
│       ├── auth.yaml
│       ├── user.yaml
│       ├── survey.yaml
│       ├── payment.yaml
│       ├── api-gateway.yaml
│       └── frontend.yaml
</pre>

text

### Quick Start with Helm

```bash
# Install the Helm chart
helm install microservice-app ./helm-code-k8s

# Check the deployment status
helm list
kubectl get all -n microservice-application

# Upgrade with custom values
helm upgrade microservice-app ./helm-code-k8s \
  --set ingress.host=myapp.yourdomain.com \
  --set services.auth.hpa.minReplicas=3

# Uninstall the chart
helm uninstall microservice-app
Customizing Deployment

# Create a custom values.yaml file for environment-specific configurations:
# custom-values.yaml
global:
  namespace: microservice-application
  
ingress:
  host: myapp.production.com
  
database:
  host: production-db.net
  password: "BASE64_ENCODED_PASSWORD"

services:
  auth:
    hpa:
      minReplicas: 3
      maxReplicas: 10
  frontend:
    hpa:
      minReplicas: 3
      maxReplicas: 8

# Deploy with custom values:
helm install microservice-app ./helm-code-k8s -f custom-values.yaml
```

### Chart Features
| Feature | Description |
|---------|-------------|
| **Parameterized Configurations** | All service settings configurable via values.yaml |
| **Automatic HPA** | Built-in Horizontal Pod Autoscaling for all microservices |
| **Environment Customization** | Easy customization for different environments (dev/staging/prod) |
| **Unified Deployment** | Single command to deploy all microservices |
| **Easy Scaling** | Simplified scaling and updates through Helm commands |

## ⚙️ Deployment Options

### Option 1: Traditional Manifest Deployment (Manual)

```bash
# 1️⃣ Build Docker Images for All Services
docker build -t myapp/frontend ./frontend
docker build -t myapp/auth-service ./auth-service
docker build -t myapp/user-service ./user-service
docker build -t myapp/survey-service ./survey-service

# 2️⃣ Push Images to Container Registry (Docker Hub, ACR)
docker push <registry>/myapp/frontend
docker push <registry>/myapp/auth-service
docker push <registry>/myapp/user-service
docker push <registry>/myapp/survey-service

# 3️⃣ Apply Kubernetes Namespace and Configurations
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml

# 4️⃣ Deploy All Microservices and Components
kubectl apply -f k8s/

# 5️⃣ Verify Deployment Status
kubectl get pods -n microservice-app
kubectl get svc -n microservice-app
kubectl get ingress -n microservice-app
```

Option 2: Helm Chart Deployment
```
# 1️⃣ Package and deploy with Helm
helm package ./microservice-helm
helm install microservice-app microservice-application-0.1.0.tgz

# 2️⃣ Verify Helm release
helm status microservice-app

# 3️⃣ Check all deployed resources
kubectl get all -n microservice-application

# 4️⃣ View configured values
helm get values microservice-app

# 5️⃣ Access the application
# For AKS or Cloud Environment:
# Access via Ingress Domain
# Example: http://myapp.example.com
```

```
Benefits of Helm Deployment
Single command deployment of all microservices

Version control for deployments

Easy rollback to previous versions

Configuration management through values.yaml

Reusable templates across environments

Simplified updates with helm upgrade
```

Operations & Maintenance
```
# Manual scaling
kubectl scale deployment auth-deployment --replicas=3 -n microservice-application

# Helm-based scaling (update values and upgrade)
helm upgrade microservice-app ./microservice-helm \
  --set services.auth.replicas=3 \
  --set services.user.replicas=2

# Check pod status and resource usage
kubectl top pods -n microservice-application

# View HPA status
kubectl get hpa -n microservice-application

# Check logs
kubectl logs -f deployment/auth-deployment -n microservice-application
# Troubleshooting

# Describe resources for detailed info
kubectl describe pod <pod-name> -n microservice-application
kubectl describe ingress -n microservice-application

# Debug services
kubectl get events -n microservice-application --sort-by='.lastTimestamp'
kubectl port-forward service/frontend-service 8080:80 -n microservice-application
```
## 📫 Contact & Support

### About Me
**Habibullah Jubair**  
DevOps Practitioner | Cloud & Kubernetes Enthusiast  
*Actively learning and implementing cloud-native technologies*

### Connect With Me
-  LinkedIn: [linkedin.com/in/habibullah-jubair](https://linkedin.com/in/habibullah-jubair)
-  GitHub: [github.com/jubair2002](https://github.com/jubair2002)
-  Email: habibullah.jubair2002@outlook.com

### Learning Journey
- Currently focusing on Cloud-Native architectures
- Exploring Kubernetes and Container Orchestration
- Building practical DevOps implementations
- Open to collaboration and knowledge sharing