# Final DevOps Project (AWS + Terraform + Kubernetes)

Це мій фінальний DevOps-проєкт на AWS.  
Інфраструктура описана через Terraform і складається з таких компонентів:

- VPC (публічні та приватні підмережі)
- EKS кластер
- RDS / Aurora база даних (через універсальний модуль rds)
- ECR для Docker-образів
- Jenkins (CI, встановлення через Helm)
- Argo CD (GitOps, синхронізація Helm-чарта)
- Django-застосунок у окремій директорії

## Структура проєкту

Project/
├── backend.tf
├── main.tf
├── outputs.tf
│
├── modules/
│  ├── s3-backend/
│  ├── vpc/
│  ├── ecr/
│  ├── eks/
│  ├── rds/
│  ├── jenkins/
│  └── argo_cd/
│
├── charts/
│  └── django-app/
│     ├── Chart.yaml
│     ├── values.yaml
│     └── templates/
│        ├── deployment.yaml
│        ├── service.yaml
│        ├── configmap.yaml
│        └── hpa.yaml
│
└── Django/
   ├── Dockerfile
   ├── docker-compose.yaml
   ├── Jenkinsfile
   └── код Django-застосунку

## Terraform

Перед роботою перевіряю конфіг:

terraform init -backend=false
terraform fmt
terraform validate

Для реального запуску інфраструктури з бекендом у S3:

terraform init
terraform plan
terraform apply

Після apply будуть створені: S3 + DynamoDB (бекенд), VPC, EKS, RDS/Aurora, ECR, Jenkins, Argo CD.

## Kubernetes та сервіси

Після створення EKS оновлюю kubeconfig:

aws eks update-kubeconfig --name final-eks --region us-west-2

Перевіряю:

kubectl get nodes
kubectl get all -n jenkins
kubectl get all -n argocd

### Jenkins

kubectl port-forward svc/jenkins 8080:8080 -n jenkins

Інтерфейс буде доступний за адресою:

http://localhost:8080

Pipeline в Django/Jenkinsfile:

- збирає Docker-образ Django;
- пушить його в ECR;
- оновлює тег образу в Helm-чарті;
- пушить зміни в Git.

### Argo CD

kubectl port-forward svc/argocd-server 8081:443 -n argocd

Панель:

https://localhost:8081

Argo CD слідкує за репозиторієм і папкою Project/charts/django-app і автоматично застосовує зміни в кластері.

## Модуль RDS / Aurora

Модуль modules/rds універсальний:

- use_aurora = true — створюється Aurora Cluster + інстанси;
- use_aurora = false — одна aws_db_instance.

Загальне:

- aws_db_subnet_group на приватних підмережах;
- aws_security_group для доступу;
- parameter group з базовими параметрами.

Основні змінні:

- use_aurora — переключення між Aurora і звичайною RDS;
- engine, engine_version;
- instance_class / aurora_instances;
- db_name, master_username, master_password;
- vpc_id, private_subnet_ids, allowed_cidr_blocks.

## Видалення ресурсів

Щоб не тримати зайві ресурси в AWS:

terraform destroy

При terraform destroy також видаляється S3-бакет і DynamoDB-таблиця зі стейтом.  
Якщо потім потрібно підняти інфраструктуру знову — бекенд потрібно налаштувати повторно.
