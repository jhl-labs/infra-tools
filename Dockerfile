FROM ubuntu:22.04

LABEL maintainer="Infrastructure Team"
LABEL description="Comprehensive infrastructure toolkit for cluster management and AI Ops"

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV PATH="/usr/local/go/bin:/root/.local/bin:/root/.cargo/bin:${PATH}"

# 버전 설정
ENV KUBECTL_VERSION=1.29.1
ENV HELM_VERSION=3.14.0
ENV TERRAFORM_VERSION=1.7.0
ENV K9S_VERSION=0.32.0
ENV ARGOCD_VERSION=2.10.0
ENV TRIVY_VERSION=0.48.0
ENV GO_VERSION=1.22.0
ENV NODE_VERSION=20.x
ENV PYTHON_VERSION=3.11

# 기본 패키지 및 네트워크 진단 도구 설치
RUN apt-get update && apt-get install -y \
    # 기본 도구
    ca-certificates \
    curl \
    wget \
    git \
    vim \
    nano \
    micro \
    tmux \
    screen \
    unzip \
    zip \
    tar \
    gzip \
    bzip2 \
    xz-utils \
    p7zip-full \
    gnupg \
    lsb-release \
    software-properties-common \
    apt-transport-https \
    # 네트워크 진단 도구
    net-tools \
    dnsutils \
    iputils-ping \
    traceroute \
    mtr \
    nmap \
    netcat \
    socat \
    tcpdump \
    tshark \
    iperf3 \
    lsof \
    # HTTP 클라이언트
    httpie \
    # DNS 도구
    dnsmasq-base \
    # 파일 관리
    tree \
    fd-find \
    fzf \
    bat \
    # 데이터 처리
    jq \
    # 텍스트 처리
    ripgrep \
    silversearcher-ag \
    # 시스템 모니터링
    htop \
    sysstat \
    strace \
    ltrace \
    iotop \
    iftop \
    # 압축 도구
    zip \
    unzip \
    # 파일 전송
    rsync \
    openssh-client \
    # 기타 유틸리티
    uuid-runtime \
    pwgen \
    chrony \
    make \
    parallel \
    && rm -rf /var/lib/apt/lists/*

# Python 3.11 및 관련 도구 설치
RUN add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && \
    apt-get install -y \
    python${PYTHON_VERSION} \
    python${PYTHON_VERSION}-dev \
    python${PYTHON_VERSION}-venv \
    python3-pip \
    libpq-dev \
    default-libmysqlclient-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/python python /usr/bin/python${PYTHON_VERSION} 1 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PYTHON_VERSION} 1

# pip 도구 설치
RUN python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir \
    poetry \
    pipx \
    ansible \
    ansible-lint \
    yamllint \
    httpie \
    glances \
    s3cmd \
    psycopg2-binary \
    litecli \
    pgcli \
    mycli

# Node.js 설치
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn npm@latest && \
    rm -rf /var/lib/apt/lists/*

# Go 설치
RUN wget -q https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    rm go${GO_VERSION}.linux-amd64.tar.gz

# Rust 설치 (일부 도구 빌드에 필요)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# kubectl 설치
RUN curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Helm 설치
RUN curl -fsSL https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar -xz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rm -rf linux-amd64

# Kubernetes 관리 도구
RUN wget -q https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx -O /usr/local/bin/kubectx && \
    wget -q https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens -O /usr/local/bin/kubens && \
    chmod +x /usr/local/bin/kubectx /usr/local/bin/kubens

# k9s 설치
RUN wget -q https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_amd64.tar.gz && \
    tar -xzf k9s_Linux_amd64.tar.gz -C /usr/local/bin k9s && \
    rm k9s_Linux_amd64.tar.gz

# stern (로그 스트리밍) 설치
RUN curl -sL https://github.com/stern/stern/releases/latest/download/stern_linux_amd64 -o /usr/local/bin/stern && \
    chmod +x /usr/local/bin/stern

# kustomize 설치
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && \
    mv kustomize /usr/local/bin/

# ArgoCD CLI 설치
RUN curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v${ARGOCD_VERSION}/argocd-linux-amd64 && \
    chmod +x /usr/local/bin/argocd

# Flux CLI 설치
RUN curl -s https://fluxcd.io/install.sh | bash

# Terraform 설치
RUN wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Vault CLI 설치
RUN wget -q https://releases.hashicorp.com/vault/1.15.0/vault_1.15.0_linux_amd64.zip && \
    unzip vault_1.15.0_linux_amd64.zip && \
    mv vault /usr/local/bin/ && \
    rm vault_1.15.0_linux_amd64.zip

# AWS CLI 설치
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

# eksctl 설치
RUN curl -sL "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp && \
    mv /tmp/eksctl /usr/local/bin

# Google Cloud SDK 설치
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update && apt-get install -y google-cloud-sdk google-cloud-sdk-gke-gcloud-auth-plugin && \
    rm -rf /var/lib/apt/lists/*

# Azure CLI 설치
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# GitHub CLI 설치
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
    tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && apt-get install -y gh && \
    rm -rf /var/lib/apt/lists/*

# GitLab CLI 설치
RUN wget -q https://gitlab.com/gitlab-org/cli/-/releases/v1.36.0/downloads/glab_1.36.0_Linux_x86_64.tar.gz && \
    tar -xzf glab_1.36.0_Linux_x86_64.tar.gz -C /usr/local/bin bin/glab && \
    rm glab_1.36.0_Linux_x86_64.tar.gz

# 컨테이너 이미지 도구
# Trivy (취약점 스캔) 설치
RUN wget -q https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz && \
    tar -xzf trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz -C /usr/local/bin trivy && \
    rm trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz

# Skopeo 설치
RUN apt-get update && apt-get install -y skopeo && rm -rf /var/lib/apt/lists/*

# Crane 설치
RUN go install github.com/google/go-containerregistry/cmd/crane@latest && \
    mv /root/go/bin/crane /usr/local/bin/

# Dive (이미지 레이어 분석) 설치
RUN wget -q https://github.com/wagoodman/dive/releases/download/v0.12.0/dive_0.12.0_linux_amd64.tar.gz && \
    tar -xzf dive_0.12.0_linux_amd64.tar.gz -C /usr/local/bin dive && \
    rm dive_0.12.0_linux_amd64.tar.gz

# Grype (취약점 스캔) 설치
RUN curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin

# Syft (SBOM 생성) 설치
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin

# 데이터베이스 클라이언트
RUN apt-get update && apt-get install -y \
    mysql-client \
    postgresql-client \
    redis-tools \
    sqlite3 \
    mongodb-clients \
    && rm -rf /var/lib/apt/lists/*

# etcdctl 설치
RUN ETCD_VER=v3.5.11 && \
    wget -q https://github.com/etcd-io/etcd/releases/download/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz && \
    tar -xzf etcd-${ETCD_VER}-linux-amd64.tar.gz && \
    mv etcd-${ETCD_VER}-linux-amd64/etcdctl /usr/local/bin/ && \
    rm -rf etcd-${ETCD_VER}-linux-amd64*

# yq 설치
RUN curl -sL https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq

# Prometheus CLI (promtool) 설치
RUN PROM_VER=2.48.0 && \
    wget -q https://github.com/prometheus/prometheus/releases/download/v${PROM_VER}/prometheus-${PROM_VER}.linux-amd64.tar.gz && \
    tar -xzf prometheus-${PROM_VER}.linux-amd64.tar.gz && \
    mv prometheus-${PROM_VER}.linux-amd64/promtool /usr/local/bin/ && \
    rm -rf prometheus-${PROM_VER}.linux-amd64*

# Loki CLI (logcli) 설치
RUN wget -q https://github.com/grafana/loki/releases/download/v2.9.3/logcli-linux-amd64.zip && \
    unzip logcli-linux-amd64.zip && \
    mv logcli-linux-amd64 /usr/local/bin/logcli && \
    chmod +x /usr/local/bin/logcli && \
    rm logcli-linux-amd64.zip

# Grafana CLI (grafana-cli는 일반적으로 Grafana 서버와 함께 제공되므로 스킵)

# MinIO Client 설치
RUN wget -q https://dl.min.io/client/mc/release/linux-amd64/mc -O /usr/local/bin/mc && \
    chmod +x /usr/local/bin/mc

# rclone 설치
RUN curl https://rclone.org/install.sh | bash

# Velero CLI 설치
RUN wget -q https://github.com/vmware-tanzu/velero/releases/download/v1.12.0/velero-v1.12.0-linux-amd64.tar.gz && \
    tar -xzf velero-v1.12.0-linux-amd64.tar.gz && \
    mv velero-v1.12.0-linux-amd64/velero /usr/local/bin/ && \
    rm -rf velero-v1.12.0-linux-amd64*

# Restic 설치
RUN wget -q https://github.com/restic/restic/releases/download/v0.16.2/restic_0.16.2_linux_amd64.bz2 && \
    bunzip2 restic_0.16.2_linux_amd64.bz2 && \
    mv restic_0.16.2_linux_amd64 /usr/local/bin/restic && \
    chmod +x /usr/local/bin/restic

# Cilium CLI 설치
RUN curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz && \
    tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin && \
    rm cilium-linux-amd64.tar.gz

# Kubescape 설치
RUN curl -s https://raw.githubusercontent.com/kubescape/kubescape/master/install.sh | /bin/bash

# SOPS 설치
RUN wget -q https://github.com/getsops/sops/releases/download/v3.8.1/sops-v3.8.1.linux.amd64 -O /usr/local/bin/sops && \
    chmod +x /usr/local/bin/sops

# Age 설치
RUN wget -q https://github.com/FiloSottile/age/releases/download/v1.1.1/age-v1.1.1-linux-amd64.tar.gz && \
    tar -xzf age-v1.1.1-linux-amd64.tar.gz && \
    mv age/age /usr/local/bin/ && \
    mv age/age-keygen /usr/local/bin/ && \
    rm -rf age age-v1.1.1-linux-amd64.tar.gz

# grpcurl 설치
RUN go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest && \
    mv /root/go/bin/grpcurl /usr/local/bin/

# k6 설치
RUN go install go.k6.io/k6@latest && \
    mv /root/go/bin/k6 /usr/local/bin/

# Terragrunt 설치
RUN wget -q https://github.com/gruntwork-io/terragrunt/releases/download/v0.54.0/terragrunt_linux_amd64 -O /usr/local/bin/terragrunt && \
    chmod +x /usr/local/bin/terragrunt

# tflint 설치
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# OPA (Open Policy Agent) 설치
RUN curl -L -o /usr/local/bin/opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64 && \
    chmod +x /usr/local/bin/opa

# Conftest 설치
RUN wget -q https://github.com/open-policy-agent/conftest/releases/download/v0.49.0/conftest_0.49.0_Linux_x86_64.tar.gz && \
    tar -xzf conftest_0.49.0_Linux_x86_64.tar.gz -C /usr/local/bin conftest && \
    rm conftest_0.49.0_Linux_x86_64.tar.gz

# Helmfile 설치
RUN wget -q https://github.com/helmfile/helmfile/releases/download/v0.161.0/helmfile_0.161.0_linux_amd64.tar.gz && \
    tar -xzf helmfile_0.161.0_linux_amd64.tar.gz -C /usr/local/bin helmfile && \
    rm helmfile_0.161.0_linux_amd64.tar.gz

# Step CLI (인증서 관리) 설치
RUN wget -q https://dl.smallstep.com/gh-release/cli/gh-release-header/v0.25.0/step-cli_0.25.0_amd64.deb && \
    dpkg -i step-cli_0.25.0_amd64.deb && \
    rm step-cli_0.25.0_amd64.deb

# AI Ops 도구
# Ollama 설치 (로컬 LLM)
RUN curl -fsSL https://ollama.com/install.sh | sh

# LLM CLI 도구 (Simon Willison) 설치
RUN pipx install llm && \
    pipx install aichat

# Exa (ls 대체) 설치
RUN wget -q https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-v0.10.1.zip && \
    unzip exa-linux-x86_64-v0.10.1.zip && \
    mv bin/exa /usr/local/bin/ && \
    rm -rf bin exa-linux-x86_64-v0.10.1.zip

# Delta (diff 도구) 설치
RUN wget -q https://github.com/dandavison/delta/releases/download/0.17.0/git-delta_0.17.0_amd64.deb && \
    dpkg -i git-delta_0.17.0_amd64.deb && \
    rm git-delta_0.17.0_amd64.deb

# Starship (프롬프트) 설치
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

# btop 설치 (최신 시스템 모니터)
RUN wget -q https://github.com/aristocratos/btop/releases/download/v1.3.0/btop-x86_64-linux-musl.tbz && \
    tar -xjf btop-x86_64-linux-musl.tbz -C /usr/local && \
    ln -s /usr/local/btop/bin/btop /usr/local/bin/btop && \
    rm btop-x86_64-linux-musl.tbz

# Task runner 설치
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

# Just 설치
RUN curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin

# Hyperfine (벤치마크) 설치
RUN wget -q https://github.com/sharkdp/hyperfine/releases/download/v1.18.0/hyperfine_1.18.0_amd64.deb && \
    dpkg -i hyperfine_1.18.0_amd64.deb && \
    rm hyperfine_1.18.0_amd64.deb

# Direnv 설치
RUN curl -sfL https://direnv.net/install.sh | bash

# Zsh 및 Oh My Zsh 설치
RUN apt-get update && apt-get install -y zsh && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    rm -rf /var/lib/apt/lists/*

# 작업 디렉토리 설정
WORKDIR /workspace

# Starship 프롬프트 기본 설정
RUN echo 'eval "$(starship init bash)"' >> /root/.bashrc && \
    echo 'eval "$(starship init zsh)"' >> /root/.zshrc

# kubectl 자동완성 설정
RUN echo 'source <(kubectl completion bash)' >> /root/.bashrc && \
    echo 'source <(kubectl completion zsh)' >> /root/.zshrc && \
    echo 'alias k=kubectl' >> /root/.bashrc && \
    echo 'alias k=kubectl' >> /root/.zshrc && \
    echo 'complete -F __start_kubectl k' >> /root/.bashrc

# 기본 셸을 zsh로 설정
ENV SHELL=/bin/zsh

# 헬스체크
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD kubectl version --client || exit 1

CMD ["/bin/zsh"]
