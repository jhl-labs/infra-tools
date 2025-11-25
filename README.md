# Infrastructure Tools Container

클러스터 유지보수 및 AI Ops를 위한 종합 인프라 도구 컨테이너 이미지

## 개요

이 컨테이너는 인프라 관리자가 **단 하나의 이미지**로 모든 클러스터 관리, 장애 대응, 디버깅, 백업/복구 작업을 수행할 수 있도록 설계되었습니다. 또한 AI Agent가 AI Ops를 수행할 수 있는 모든 CLI 도구와 런타임 환경을 제공합니다.

### 주요 특징

- **Ubuntu 22.04 기반**: 안정적이고 널리 사용되는 환경
- **200+ 도구 포함**: 네트워크 진단부터 클라우드 관리까지 포괄적인 도구 세트
- **AI Ops 준비**: LLM CLI 도구, Python, Node.js, Go 런타임 포함
- **즉시 사용 가능**: 별도의 설치 없이 컨테이너 실행 즉시 모든 도구 사용 가능
- **멀티 클라우드 지원**: AWS, GCP, Azure CLI 및 관련 도구 포함

## 포함된 도구

### 네트워크 진단 및 연결성
- **기본 도구**: net-tools, dns-utils, iputils-ping, traceroute, mtr, nmap, netcat, socat
- **HTTP 클라이언트**: wget, curl, httpie
- **고급 분석**: tcpdump, tshark, iperf3, lsof, ss, netstat

### Kubernetes 클러스터 관리
- **핵심 도구**: kubectl (v1.29.1), helm (v3.14.0), kustomize
- **컨텍스트 관리**: kubectx, kubens
- **대화형 관리**: k9s, stern (로그 스트리밍)
- **디버깅**: kubectl-debug, kubectl-tree
- **정책 관리**: kyverno-cli, kube-bench, kubesec, kubescape
- **매니페스트 도구**: kubeconform, kubeval

### 컨테이너 및 이미지 관리
- **이미지 도구**: skopeo, crane, dive (레이어 분석)
- **취약점 스캔**: trivy, grype, syft (SBOM 생성)
- **레지스트리**: harbor-cli, registry-cli

### 스토리지 관리
- **Ceph**: ceph-cli, rados, rbd, cephfs-shell
- **오브젝트 스토리지**: s3cmd, mc (MinIO), rclone
- **볼륨 관리**: lvm2, parted, gdisk

### GitOps 및 CI/CD
- **GitOps**: argocd-cli, flux, helmfile
- **VCS**: git, gh (GitHub CLI), glab (GitLab CLI)

### 보안 및 시크릿 관리
- **시크릿 관리**: vault, openbao, sops, age
- **인증서**: openssl, cfssl, step-cli
- **보안 스캔**: kubescape, kube-hunter
- **네트워크 정책**: cilium-cli

### 클라우드 프로바이더 CLI
- **AWS**: aws-cli, eksctl, aws-iam-authenticator
- **GCP**: gcloud, gke-gcloud-auth-plugin
- **Azure**: az-cli, kubelogin

### IaC (Infrastructure as Code)
- **Terraform**: terraform (v1.7.0), terragrunt, tflint, tfsec
- **구성 관리**: ansible, ansible-lint
- **정책**: open-policy-agent (opa), conftest

### 모니터링 및 관찰성
- **메트릭**: prometheus-cli (promtool)
- **로그**: loki-cli (logcli), stern
- **트레이싱**: jaeger-cli

### 데이터베이스 클라이언트
- **SQL**: mysql-client, postgresql-client, sqlite3
- **NoSQL**: redis-cli, mongodb-client, etcdctl
- **고급 CLI**: usql, litecli, pgcli, mycli

### 성능 분석 및 디버깅
- **시스템 모니터링**: htop, btop, glances, sysstat
- **I/O 분석**: iotop, iostat, fio
- **네트워크 성능**: iftop, nethogs, bmon
- **스트레이스**: strace, ltrace

### 파일 및 데이터 처리
- **파일 관리**: tree, fd, fzf, bat, exa
- **데이터 처리**: jq, yq, xq, dasel, gron
- **텍스트 편집**: vim, nano, micro
- **비교**: diff, delta

### 백업 및 복구
- **Kubernetes 백업**: velero-cli
- **스냅샷**: restic, borg
- **데이터베이스 백업**: pg_dump, mysqldump, mongodump

### AI Ops 및 자동화 도구
- **LLM CLI 도구**:
  - ollama (로컬 LLM 실행)
  - llm (Simon Willison's CLI tool)
  - aichat (멀티 LLM CLI)
- **AI 코파일럿**: aider (AI pair programming)
- **API 테스팅**: httpie, grpcurl, k6
- **자동화 런타임**:
  - Python 3.11+ (pip, poetry, pipx 포함)
  - Node.js 20.x (npm, yarn 포함)
  - Go 1.22

### 워크플로우 자동화
- **Task runners**: make, task, just
- **스크립트 관리**: direnv
- **병렬 실행**: parallel, xargs

### 기타 편의 도구
- **멀티플렉서**: tmux, screen
- **셸 개선**: zsh, oh-my-zsh, starship (프롬프트)
- **벤치마크**: hyperfine

## 이미지 가져오기

### GitHub Container Registry에서 바로 사용

GitHub Actions CI/CD를 통해 자동으로 빌드된 이미지를 바로 사용할 수 있습니다:

```bash
# 최신 이미지 pull
docker pull ghcr.io/jhl-labs/infra-tools:latest

# 바로 실행
docker run -it --rm ghcr.io/jhl-labs/infra-tools:latest
```

### CI/CD 자동 빌드

이 레포지토리는 GitHub Actions를 통해 자동으로 이미지를 빌드하고 GHCR에 푸시합니다:

- **트리거**: `main` 브랜치에 push, Pull Request, 또는 태그 생성 시
- **레지스트리**: GitHub Container Registry (ghcr.io)
- **태그 전략**:
  - `latest`: main 브랜치의 최신 버전
  - `main`: main 브랜치 이미지
  - `v*.*.*`: semantic versioning 태그 (예: v1.0.0)
  - `SHA`: 커밋 해시 기반 태그

워크플로우 상태: [![Build and Push to GHCR](https://github.com/jhl-labs/infra-tools/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/jhl-labs/infra-tools/actions/workflows/docker-publish.yml)

## 로컬 빌드 방법

필요한 경우 로컬에서 직접 빌드할 수 있습니다:

### 이미지 빌드

```bash
docker build -t infra-tools:latest .
```

### 태그 및 푸시 (선택사항)

```bash
# GHCR에 푸시
docker tag infra-tools:latest ghcr.io/jhl-labs/infra-tools:latest
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
docker push ghcr.io/jhl-labs/infra-tools:latest

# Docker Hub에 푸시
docker tag infra-tools:latest your-registry/infra-tools:latest
docker push your-registry/infra-tools:latest

# Harbor 레지스트리에 푸시
docker tag infra-tools:latest harbor.example.com/platform/infra-tools:latest
docker push harbor.example.com/platform/infra-tools:latest
```

## 사용 방법

### 1. 로컬 Docker 실행

```bash
# 기본 실행
docker run -it --rm ghcr.io/jhl-labs/infra-tools:latest

# kubeconfig 마운트하여 실행
docker run -it --rm \
  -v ~/.kube:/root/.kube:ro \
  ghcr.io/jhl-labs/infra-tools:latest

# 작업 디렉토리 마운트
docker run -it --rm \
  -v $(pwd):/workspace \
  -v ~/.kube:/root/.kube:ro \
  ghcr.io/jhl-labs/infra-tools:latest
```

### 2. Kubernetes Pod으로 실행

#### 임시 디버그 Pod 생성

```bash
kubectl run debug-pod \
  --rm -it \
  --image=ghcr.io/jhl-labs/infra-tools:latest \
  --restart=Never \
  -- /bin/zsh
```

#### 영구 배포

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: infra-tools
  namespace: default
spec:
  containers:
  - name: infra-tools
    image: ghcr.io/jhl-labs/infra-tools:latest
    command: ["/bin/zsh"]
    stdin: true
    tty: true
    resources:
      requests:
        memory: "512Mi"
        cpu: "250m"
      limits:
        memory: "2Gi"
        cpu: "1000m"
    volumeMounts:
    - name: workspace
      mountPath: /workspace
  volumes:
  - name: workspace
    emptyDir: {}
```

배포 후 접속:

```bash
kubectl exec -it infra-tools -- /bin/zsh
```

### 3. Kubernetes Job으로 실행 (AI Ops)

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: ai-ops-task
spec:
  template:
    spec:
      containers:
      - name: infra-tools
        image: ghcr.io/jhl-labs/infra-tools:latest
        command: ["/bin/bash", "-c"]
        args:
          - |
            # AI Ops 스크립트 실행
            python3 /workspace/ai-ops-script.py
      restartPolicy: Never
      volumes:
      - name: scripts
        configMap:
          name: ai-ops-scripts
      - name: kubeconfig
        secret:
          secretName: kubeconfig
```

## 사용 예제

### 클러스터 진단

```bash
# Pod 실행
kubectl run debug --rm -it --image=ghcr.io/jhl-labs/infra-tools:latest -- /bin/zsh

# 클러스터 상태 확인
kubectl get nodes
kubectl get pods -A

# k9s로 대화형 관리
k9s

# 네트워크 연결성 테스트
ping google.com
nmap -sP 10.0.0.0/24

# DNS 문제 진단
nslookup kubernetes.default
dig @10.96.0.10 kubernetes.default.svc.cluster.local
```

### 보안 스캔

```bash
# 클러스터 보안 스캔
kubescape scan --submit

# 컨테이너 이미지 취약점 스캔
trivy image nginx:latest

# SBOM 생성
syft nginx:latest -o json > nginx-sbom.json
```

### 백업 및 복구

```bash
# Velero로 네임스페이스 백업
velero backup create my-backup --include-namespaces default

# Restic으로 데이터 백업
restic -r s3:s3.amazonaws.com/my-backup-bucket init
restic -r s3:s3.amazonaws.com/my-backup-bucket backup /data

# PostgreSQL 백업
pg_dump -h postgres-host -U admin mydb > mydb-backup.sql
```

### AI Ops 작업

```bash
# Python으로 클러스터 자동화
python3 <<EOF
import subprocess
import json

# kubectl을 통해 Pod 정보 수집
result = subprocess.run(['kubectl', 'get', 'pods', '-A', '-o', 'json'],
                       capture_output=True, text=True)
pods = json.loads(result.stdout)

# Pod 상태 분석
for item in pods['items']:
    name = item['metadata']['name']
    status = item['status']['phase']
    print(f"Pod: {name}, Status: {status}")
EOF

# Ollama로 로컬 LLM 실행 (AI 분석)
ollama pull llama2
echo "Analyze this Kubernetes event log" | ollama run llama2

# aider로 AI 코드 생성
aider --model gpt-4 "Create a Python script to monitor pod health"
```

### GitOps 워크플로우

```bash
# ArgoCD 애플리케이션 배포
argocd app create my-app \
  --repo https://github.com/org/repo \
  --path k8s \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default

# Flux 설치 및 부트스트랩
flux bootstrap github \
  --owner=my-org \
  --repository=fleet-infra \
  --path=clusters/my-cluster

# Helmfile로 여러 차트 배포
helmfile sync
```

### 성능 분석

```bash
# 시스템 리소스 모니터링
btop

# 네트워크 대역폭 모니터링
iftop

# I/O 성능 테스트
fio --name=test --size=1G --rw=randrw --bs=4k --direct=1

# 벤치마크
hyperfine 'kubectl get pods' 'kubectl get pods --chunk-size=500'
```

## 환경 변수

컨테이너 실행 시 설정할 수 있는 주요 환경 변수:

```bash
docker run -it --rm \
  -e KUBECONFIG=/root/.kube/config \
  -e AWS_PROFILE=default \
  -e AWS_REGION=us-west-2 \
  -e GOOGLE_APPLICATION_CREDENTIALS=/root/.gcp/credentials.json \
  -e AZURE_CONFIG_DIR=/root/.azure \
  -v ~/.kube:/root/.kube:ro \
  -v ~/.aws:/root/.aws:ro \
  -v ~/.gcp:/root/.gcp:ro \
  -v ~/.azure:/root/.azure:ro \
  infra-tools:latest
```

## 보안 고려사항

### 1. 최소 권한 원칙

Kubernetes에서 실행 시 ServiceAccount와 RBAC를 적절히 설정하세요:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: infra-tools-sa
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: infra-tools-role
rules:
- apiGroups: [""]
  resources: ["pods", "services"]
  verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: infra-tools-binding
subjects:
- kind: ServiceAccount
  name: infra-tools-sa
roleRef:
  kind: Role
  name: infra-tools-role
  apiGroup: rbac.authorization.k8s.io
```

### 2. 시크릿 관리

민감한 정보는 Kubernetes Secret으로 마운트:

```yaml
volumeMounts:
- name: secrets
  mountPath: /root/.secrets
  readOnly: true
volumes:
- name: secrets
  secret:
    secretName: infra-tools-secrets
```

### 3. 네트워크 정책

필요한 경우 NetworkPolicy로 통신 제한:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: infra-tools-netpol
spec:
  podSelector:
    matchLabels:
      app: infra-tools
  policyTypes:
  - Egress
  egress:
  - to:
    - namespaceSelector: {}
```

## 트러블슈팅

### 이미지 빌드 실패

빌드 중 네트워크 문제나 타임아웃이 발생하면:

```bash
# 프록시 사용
docker build --build-arg HTTP_PROXY=http://proxy:8080 -t infra-tools:latest .

# 빌드 타임아웃 증가
docker build --network=host -t infra-tools:latest .
```

### kubectl 권한 문제

```bash
# ServiceAccount 토큰 확인
kubectl exec -it infra-tools -- cat /var/run/secrets/kubernetes.io/serviceaccount/token

# 권한 확인
kubectl auth can-i get pods --as=system:serviceaccount:default:infra-tools-sa
```

### AI Ops LLM 설정

```bash
# Ollama 서비스 시작 (백그라운드)
ollama serve &

# 모델 다운로드
ollama pull llama2

# OpenAI API 키 설정
export OPENAI_API_KEY=your-api-key

# Anthropic API 키 설정
export ANTHROPIC_API_KEY=your-api-key
```

## 기여 방법

개선 사항이나 추가할 도구가 있다면:

1. PROTOTYPE.md에 도구 추가
2. Dockerfile에 설치 스크립트 추가
3. README.md 문서 업데이트
4. Pull Request 생성

## 라이선스

이 프로젝트는 포함된 각 도구의 라이선스를 따릅니다. 상용 환경에서 사용하기 전에 각 도구의 라이선스를 확인하세요.

## 문의

- 이슈 트래커: GitHub Issues
- 문서: [PROTOTYPE.md](./PROTOTYPE.md)

---

**이 컨테이너 하나로 모든 인프라 작업을 수행하세요!** 🚀
