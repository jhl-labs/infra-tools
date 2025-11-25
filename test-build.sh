#!/bin/bash

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 변수 설정
IMAGE_NAME="infra-tools-test"
IMAGE_TAG="local-test"
FULL_IMAGE="${IMAGE_NAME}:${IMAGE_TAG}"

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}Docker Build Test Script${NC}"
echo -e "${YELLOW}========================================${NC}"
echo ""

# Docker 실행 확인
echo -e "${YELLOW}[1/6] Checking Docker...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    exit 1
fi

if ! docker info &> /dev/null; then
    echo -e "${RED}Error: Docker daemon is not running${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker is ready${NC}"
echo ""

# 디스크 공간 확인
echo -e "${YELLOW}[2/6] Checking disk space...${NC}"
AVAILABLE_SPACE=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
if [ "$AVAILABLE_SPACE" -lt 10 ]; then
    echo -e "${RED}Warning: Less than 10GB available. Build may fail.${NC}"
    echo -e "${YELLOW}Available space: ${AVAILABLE_SPACE}GB${NC}"
else
    echo -e "${GREEN}✓ Sufficient disk space: ${AVAILABLE_SPACE}GB${NC}"
fi
echo ""

# 기존 테스트 이미지 정리
echo -e "${YELLOW}[3/6] Cleaning up old test images...${NC}"
if docker images | grep -q "${IMAGE_NAME}"; then
    docker rmi -f $(docker images -q "${IMAGE_NAME}") 2>/dev/null || true
    echo -e "${GREEN}✓ Old test images removed${NC}"
else
    echo -e "${GREEN}✓ No old test images found${NC}"
fi
echo ""

# Docker 빌드 시작
echo -e "${YELLOW}[4/6] Building Docker image...${NC}"
echo -e "${YELLOW}This may take 10-15 minutes (200+ tools to install)${NC}"
echo ""

BUILD_START=$(date +%s)

if docker build -t "${FULL_IMAGE}" . ; then
    BUILD_END=$(date +%s)
    BUILD_TIME=$((BUILD_END - BUILD_START))
    BUILD_MINUTES=$((BUILD_TIME / 60))
    BUILD_SECONDS=$((BUILD_TIME % 60))

    echo ""
    echo -e "${GREEN}✓ Build succeeded in ${BUILD_MINUTES}m ${BUILD_SECONDS}s${NC}"
    echo ""

    # 이미지 정보 출력
    echo -e "${YELLOW}[5/6] Image Information:${NC}"
    docker images "${FULL_IMAGE}" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
    echo ""

    # 기본 테스트 실행
    echo -e "${YELLOW}[6/6] Running basic tests...${NC}"

    # 테스트 1: 컨테이너 시작 확인
    echo -e "${YELLOW}  Test 1: Container startup${NC}"
    if docker run --rm "${FULL_IMAGE}" /bin/bash -c "echo 'Container started successfully'"; then
        echo -e "${GREEN}  ✓ Container startup test passed${NC}"
    else
        echo -e "${RED}  ✗ Container startup test failed${NC}"
        exit 1
    fi

    # 테스트 2: 주요 도구 설치 확인
    echo -e "${YELLOW}  Test 2: Checking essential tools${NC}"
    TOOLS_TO_CHECK="kubectl helm k9s python3 node go jq yq"

    for tool in $TOOLS_TO_CHECK; do
        if docker run --rm "${FULL_IMAGE}" /bin/bash -c "command -v $tool &> /dev/null"; then
            echo -e "${GREEN}    ✓ $tool${NC}"
        else
            echo -e "${RED}    ✗ $tool not found${NC}"
        fi
    done

    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}Build test completed successfully!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "${YELLOW}Image: ${FULL_IMAGE}${NC}"
    echo -e "${YELLOW}Size: $(docker images ${FULL_IMAGE} --format '{{.Size}}')${NC}"
    echo ""

    # 정리 여부 확인
    echo -e "${YELLOW}Cleaning up test image...${NC}"
    docker rmi "${FULL_IMAGE}"
    echo -e "${GREEN}✓ Test image removed${NC}"
    echo ""

    echo -e "${GREEN}All done! The Dockerfile builds successfully.${NC}"
    exit 0

else
    BUILD_END=$(date +%s)
    BUILD_TIME=$((BUILD_END - BUILD_START))

    echo ""
    echo -e "${RED}========================================${NC}"
    echo -e "${RED}Build failed after ${BUILD_TIME}s${NC}"
    echo -e "${RED}========================================${NC}"
    echo ""
    echo -e "${YELLOW}Check the error messages above for details${NC}"
    exit 1
fi
