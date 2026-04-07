# ProductionSetup

                🌐 Internet
                     |
              AWS Load Balancer
                     |
            Ingress Controller
                     |
     ---------------------------------
     |        |        |             |
 Jenkins   Grafana   SonarQube   Nexus
     |        |        |             |
           Kubernetes Cluster                         

-----------------------------------------------------------------------------------------------------------


DevOps-Production-Setup/
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf (optional)
│   ├── outputs.tf (optional)
│
├── jenkins/
│   ├── userdata.sh
│   ├── jenkins.yaml
│   ├── plugins.txt
│
├── README.md
├── .gitignore


---------------------------------------------------------------------------------------------------------------------

Developer → GitHub → Jenkins
            ↓
        Build Docker Image
            ↓
        Push to DockerHub
            ↓
        Deploy to Kubernetes
            ↓
Ingress → Application
            ↓
Prometheus → Metrics
Grafana → Dashboard
SonarQube → Code Quality


------------------------------------------------------------------------------------------------------------------------
           

# DevOps Production Setup

## 🚀 Stack
- Terraform
- Jenkins (JCasC)
- Docker
- Kubernetes (kubeadm)
- Helm
- Prometheus & Grafana
- SonarQube
- Nexus

## 📂 Structure
- terraform/ → Infra
- jenkins/ → Jenkins automation

## ▶️ Usage

```bash
terraform init
terraform apply
