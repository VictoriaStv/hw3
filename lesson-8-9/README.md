# CI/CD з Jenkins, Terraform, Helm і Argo CD (lesson-8-9)

Цей проєкт — продовження попередніх ДЗ по AWS.  
Тут я зібрала повний ланцюжок CI/CD для Django-застосунку на EKS:

- інфраструктура через Terraform;
- збірка Docker-образу й пуш в Amazon ECR через Jenkins;
- оновлення Helm-чарта;
- автодеплой у кластер EKS через Argo CD.

---

## Структура проєкту

У директорії `lesson-8-9`:

- `backend.tf`, `main.tf`, `outputs.tf` — основні файли Terraform.
- `modules/`:
  - `s3-backend/` — S3 + DynamoDB для Terraform state.
  - `vpc/` — VPC, підмережі, маршрути.
  - `ecr/` — репозиторій в Amazon ECR.
  - `eks/` — кластер Kubernetes (EKS).
  - `jenkins/` — установка Jenkins через Helm.
  - `argo_cd/` — установка Argo CD через Helm + Helm-чарт для applications.
- `charts/django-app/` — Helm-чарт Django-застосунку:
  - `templates/deployment.yaml`
  - `templates/service.yaml`
  - `templates/configmap.yaml`
  - `templates/hpa.yaml`
  - `Chart.yaml`
  - `values.yaml`

---

## Terraform

Базові команди для роботи з інфраструктурою:

  $ cd lesson-8-9
  $ terraform init
  $ terraform fmt
  $ terraform validate
  $ terraform plan
  $ terraform apply

Terraform створює:

- S3-бакет і DynamoDB для стейтів;
- VPC, публічні та приватні підмережі, Internet/NAT Gateway;
- ECR-репозиторій;
- EKS-кластер;
- Jenkins (через Helm);
- Argo CD (через Helm).

Щоб все видалити після перевірки:

  $ terraform destroy

Після `destroy` S3-бакет і DynamoDB для Terraform state також видаляються.  
При новому запуску інфраструктури треба заново виконати `terraform init`.

---

## Jenkins (CI)

Jenkins встановлюється як Helm release у модулі `modules/jenkins`.

Доступ до Jenkins (приклад):

  $ kubectl get pods -n jenkins
  $ kubectl port-forward svc/jenkins 8080:8080 -n jenkins

Інтерфейс:

- браузер: `http://localhost:8080`

Пароль адміністратора можна взяти з секрету в namespace `jenkins` або з логів pod’а.

### Логіка Jenkins pipeline (Jenkinsfile)

Пайплайн робить таке:

1. Збирає Docker-образ Django із `Dockerfile`.
2. Логіниться в ECR і пушить образ з новим тегом.
3. Оновлює тег образу в `values.yaml` Helm-чарта в Git-репозиторії.
4. Комітить і пушить зміни в гілку `main`/`master`.

Після цього оновлений образ підхоплює вже Argo CD.

---

## Argo CD (CD)

Argo CD встановлюється через Helm у модулі `modules/argo_cd`.

Приклад команд для доступу:

  $ kubectl get pods -n argocd
  $ kubectl port-forward svc/argocd-server 8081:443 -n argocd

Інтерфейс:

- браузер: `https://localhost:8081`

У модулі `argo_cd` є Helm-чарт, який створює:

- Argo CD Application, що вказує на Git-репозиторій та шлях до `charts/django-app`;
- (за потреби) Argo CD Repository з описом репозиторію.

Коли Jenkins оновлює `values.yaml` і пушить зміни:

- Argo CD бачить новий коміт,
- оновлює реліз у кластері,
- деплоїть новий образ у EKS.

---

## Helm-чарт `django-app`

У `charts/django-app` описаний сам застосунок:

- `deployment.yaml` — pod’и з контейнером Django, образ із ECR, тег із `values.yaml`;
- `service.yaml` — сервіс (тип `LoadBalancer` або `ClusterIP`);
- `configmap.yaml` — змінні середовища (env, перенесені з попередніх ДЗ);
- `hpa.yaml` — Horizontal Pod Autoscaler:
  - мінімум 2 pod’и;
  - максимум 6 pod’ів;
  - таргет ~70% по CPU.

Основні параметри (образ, тег, тип сервісу, параметри autoscaling) задаються в `values.yaml`.

---

## Як перевірити CI/CD

### 1. Terraform

- підняти інфраструктуру:

  $ cd lesson-8-9
  $ terraform apply

- перевірити, що ресурси є в кластері:

  $ kubectl get pods --all-namespaces

### 2. Jenkins

- зайти в UI Jenkins (`http://localhost:8080`);
- створити pipeline із `Jenkinsfile`;
- запустити job і впевнитися, що:
  - образ зібрався;
  - образ відправився в ECR;
  - тег у `values.yaml` оновився;
  - зміни запушились у Git.

### 3. Argo CD

- зайти в UI Argo CD (`https://localhost:8081`);
- знайти application для `django-app`;
- перевірити, що статус `Synced` і `Healthy`;
- переконатися, що в Deployment використовується новий тег образу.

---

## Нагадування про витрати

Після завершення перевірки:

- бажано виконати `terraform destroy`, щоб не тримати зайві ресурси в AWS;
- при новому запуску не забути знову зробити `terraform init` для бекенду S3 + DynamoDB.
