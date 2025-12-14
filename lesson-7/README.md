# Lesson 7 — Kubernetes, Terraform, Helm

У цьому завданні я описую інфраструктуру в AWS через Terraform і деплой Django-застосунку в EKS за допомогою Helm.

---

## Структура проєкту

lesson-7/  
├── backend.tf  
├── main.tf  
├── outputs.tf  
├── modules/  
│  ├── s3-backend/  
│  ├── vpc/  
│  ├── ecr/  
│  └── eks/  
└── charts/  
   └── django-app/  
      ├── Chart.yaml  
      ├── values.yaml  
      └── templates/  
         ├── deployment.yaml  
         ├── service.yaml  
         ├── configmap.yaml  
         └── hpa.yaml  

---

## Terraform-модулі

**1. s3-backend**

- S3 bucket для зберігання Terraform state-файла  
- Увімкнене версіонування для історії стейтів  
- DynamoDB-таблиця для блокування (lock)  

**2. vpc**

- VPC з основним CIDR блоком  
- 3 публічні та 3 приватні підмережі  
- Internet Gateway для публічних subnet  
- NAT Gateway для приватних subnet  
- Route tables і маршрути для публічної та приватної частини  

**3. ecr**

- ECR-репозиторій для Docker-образу Django  
- Увімкнене сканування образів при push  
- Виводжу URL репозиторію в outputs  

**4. eks**

- EKS-кластер у вже створеній VPC  
- Node group для запуску подів  
- Виводжу ім’я кластера та дані для підключення через kubectl  

---

## Helm-чарт `django-app`

У каталозі `charts/django-app` описаний деплой Django-застосунку в EKS.

- `deployment.yaml` — Pod’и з образом з ECR, змінні середовища підтягуються через ConfigMap (`envFrom`).  
- `service.yaml` — Service типу `LoadBalancer` для зовнішнього доступу до застосунку.  
- `configmap.yaml` — змінні середовища (env), перенесені з попереднього Django/ Docker-завдання.  
- `hpa.yaml` — Horizontal Pod Autoscaler: масштабування від 2 до 6 pod при завантаженні CPU > 70%.  
- `values.yaml` — образ, теги, параметри сервісу, autoscaler та налаштування для ConfigMap.  

---

## Команди для роботи

### Terraform (інфраструктура в AWS)

З каталогу `lesson-7`:

1. Ініціалізація (локально, без бекенду S3 — для валідації коду):

$ terraform init -backend=false  

2. Форматування й перевірка:

$ terraform fmt  
$ terraform validate  

3. Реальний запуск з бекендом S3 (коли вже створений bucket і DynamoDB):

$ terraform init -reconfigure  
$ terraform plan  
$ terraform apply  

4. Видалення ресурсів після перевірки:

$ terraform destroy  

---

### Docker-образ і ECR

1. Зібрати образ локально (приклад):

$ docker build -t my-django-app:latest .  

2. Залогінитися в ECR (команду логіну дає AWS CLI):

$ aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <ecr-url>  

3. Притегати й запушити образ:

$ docker tag my-django-app:latest <ecr-url>:latest  
$ docker push <ecr-url>:latest  

---

### Підключення до EKS і Helm-деплой

1. Підтягнути kubeconfig для EKS:

$ aws eks update-kubeconfig --region <region> --name <eks_cluster_name>  

2. Перевірити доступ:

$ kubectl get nodes  

3. Встановити Helm-чарт:

$ helm install django-app ./charts/django-app  

4. Оновлення релізу (якщо змінюю values чи шаблони):

$ helm upgrade django-app ./charts/django-app  

5. Перевірити, що все піднялося:

$ kubectl get pods  
$ kubectl get svc  
$ kubectl get hpa  

---

## Примітки

- Після `terraform destroy` S3 bucket і DynamoDB для стейтів теж видаляються. Для повторного запуску інфраструктури треба знову створити backend-ресурси та виконати:

$ terraform init -reconfigure  

- Всі назви bucket / репозиторію / кластера вказані як змінні в модулях, їх можна підлаштувати під свій акаунт AWS.
