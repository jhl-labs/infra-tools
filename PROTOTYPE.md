# 클러스터 유지보수를 위한 컨테이너 이미지

## 기본 환경
- ubuntu 22.04 기반
- 인프라 관리자가 이 컨테이너 하나로 모든 클러스터 관리 및 장애 대응 가능

## 네트워크 진단 및 연결성 도구
- 기본 네트워크 도구: net-tools, dns-utils, iputils-ping, traceroute, mtr, nmap, netcat, socat
- HTTP 클라이언트: wget, curl, httpie
- DNS 도구: dnsmasq, dig, nslookup, host
- 고급 네트워크 분석: tcpdump, wireshark-cli(tshark), iperf3, netstat, ss, lsof

## 쿠버네티스 클러스터 관리 도구
- 핵심 도구: kubectl, helm, kustomize
- 컨텍스트 관리: kubectx, kubens, kubeswitch
- 대화형 관리: k9s, stern (로그 스트리밍)
- 디버깅: kubectl-debug, kubectl-tree, kubectl-view-allocations
- 정책 관리: kyverno-cli, kube-bench, kubesec
- 매니페스트 도구: kubeconform, kubeval, kubectl-neat

## 컨테이너 및 이미지 관리
- 런타임: docker-cli, podman, nerdctl
- 이미지 도구: skopeo, crane, dive (이미지 레이어 분석)
- 레지스트리: registry-cli, harbor-cli
- 취약점 스캔: trivy, grype, syft (SBOM 생성)

## 스토리지 관리 도구
- Ceph: ceph-cli, rados, rbd, cephfs-shell
- 범용 스토리지: s3cmd, mc (MinIO client), rclone
- 볼륨 관리: lvm2, parted, gdisk

## GitOps 및 CI/CD 도구
- GitOps: argocd-cli, flux, helmfile
- VCS: git, git-lfs, gh (GitHub CLI), glab (GitLab CLI)
- CI/CD: github-actions-cli, gitlab-runner

## 보안 및 시크릿 관리
- 시크릿 관리: vault, openbao, sops, age
- 인증서: openssl, cfssl, step-cli
- 보안 스캔: kubescape, kube-hunter, checkov
- 네트워크 정책: cilium-cli, calico-ctl

## 클라우드 프로바이더 CLI
- AWS: aws-cli, eksctl, aws-iam-authenticator
- GCP: gcloud, gke-gcloud-auth-plugin
- Azure: az-cli, kubelogin
- 멀티클라우드: terraform, pulumi, crossplane-cli

## IaC (Infrastructure as Code) 도구
- Terraform: terraform, terragrunt, tflint, tfsec
- 구성 관리: ansible, ansible-lint
- 정책: open-policy-agent (opa), conftest

## 모니터링 및 관찰성 도구
- 메트릭: prometheus-cli (promtool), victoria-metrics-cli
- 로그: loki-cli (logcli), fluentd, vector
- 트레이싱: jaeger-cli
- APM: grafana-cli, datadog-cli

## 로그 분석 및 처리
- 로그 뷰어: stern, kubetail, kail
- 로그 분석: awk, sed, grep, ripgrep (rg), ag (the silver searcher)
- 로그 파싱: goaccess, angle-grinder

## 데이터베이스 클라이언트
- SQL: mysql-client, postgresql-client, sqlite3
- NoSQL: redis-cli, mongodb-client, etcdctl
- 멀티 DB: usql, litecli, pgcli, mycli

## 성능 분석 및 디버깅
- 시스템 모니터링: htop, btop, glances, sysstat
- 프로세스: ps, top, pidstat, pgrep
- I/O 분석: iotop, iostat, fio
- 스트레이스: strace, ltrace
- 네트워크 성능: iftop, nethogs, bmon

## 파일 및 데이터 처리 도구
- 파일 관리: tree, fd, fzf, bat, exa (ls 대체)
- 데이터 처리: jq, yq, xq, dasel, gron
- 텍스트 편집: vim, nano, micro
- 비교: diff, colordiff, delta
- 압축: tar, gzip, bzip2, xz, zip, unzip, 7z

## 파일 전송 및 동기화
- 전송: rsync, scp, sftp
- 클라우드 동기화: rclone, s3cmd, gsutil
- 대용량 전송: aria2

## 백업 및 복구 도구
- 쿠버네티스 백업: velero-cli, k8up-cli
- 스냅샷: restic, borg, duplicity
- 데이터베이스 백업: pg_dump, mysqldump, mongodump

## AI Ops 및 자동화 도구 (AI Agent용)
- LLM CLI 도구:
  - openai-cli, anthropic-cli (Claude API)
  - ollama (로컬 LLM 실행)
  - llm (Simon Willison's CLI tool)
  - aichat (멀티 LLM CLI)
- AI 코파일럿: aider (AI pair programming)
- 자연어 처리: translate-shell, gpt-cli
- 구조화된 데이터 추출: jq, yq, dasel, htmlq, xq
- API 테스팅:
  - httpie, curl, xh
  - grpcurl, evans (gRPC)
  - k6 (부하 테스트 및 자동화)
- 자동화 스크립팅:
  - Python 3.11+ (pip, poetry, pipx)
  - Node.js (npm, npx, yarn)
  - Go runtime
  - bash, zsh, fish

## 워크플로우 자동화
- Task runners: make, task, just
- 스크립트 관리: direnv, dotenv
- 병렬 실행: parallel, xargs
- 스케줄링: cronie

## 개발 및 디버깅 유틸리티
- 버전 관리: git, tig, gh, glab
- 코드 검색: ripgrep, ag, ack
- 프로토콜: protobuf-compiler, grpcurl
- JSON/YAML 스키마: jsonschema, yamllint
- 문서화: pandoc, mdbook

## 기타 편의 도구
- 멀티플렉서: tmux, screen
- 셸 개선: zsh, oh-my-zsh, starship (프롬프트)
- 색상 출력: grc (generic colorizer), lolcat
- 벤치마크: hyperfine, ab (Apache Bench)
- UUID/랜덤: uuidgen, pwgen
- 시간 동기화: ntp, chrony 
