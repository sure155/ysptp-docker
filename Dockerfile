FROM python:3.12-alpine
ENV TZ=Asia/Shanghai \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    YSP_DATA_DIR=/app/data
RUN apk add --no-cache nodejs tzdata ca-certificates \
 && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
 && echo "Asia/Shanghai" > /etc/timezone \
 && mkdir -p /app/data
WORKDIR /app
COPY ysp-live.py epg_agg.py ysp-engine.js /app/
EXPOSE 8767
VOLUME ["/app/data"]
HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8767/health >/dev/null || exit 1
CMD ["python3", "/app/ysp-live.py", "8767"]
