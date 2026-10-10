#!/bin/bash
# ysp-live v9.0-sure155 一键部署脚本
set -e

REPO_URL="https://github.com/sure155/ysptp-docker.git"
TARGET_DIR="/opt/ysp-live-docker"

echo ">>> 拉取 sure155/ysptp-docker 项目..."
rm -rf "$TARGET_DIR"
git clone --depth 1 "$REPO_URL" "$TARGET_DIR"
cd "$TARGET_DIR"

echo ">>> 清理可能残留的旧容器..."
docker rm -f ysp-live ysp-live-v9.0 ysp-live-v8.1 2>/dev/null; true

echo ">>> 构建并启动容器..."
docker compose up -d --build

IP=$(curl -s --max-time 5 ifconfig.me 2>/dev/null || hostname -I | awk '{print $1}')
echo ""
echo "ysp-live 已部署完毕"
echo "订阅地址: http://$IP:8767/cctv.m3u"
echo "节目单订阅: http://$IP:8767/epg.xml"
echo "实时诊断: http://$IP:8767/diag"
echo "查看日志: docker logs -f ysp-live"

