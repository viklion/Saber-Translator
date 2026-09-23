# 使用 Debian slim
FROM python:3.10-slim

LABEL name="Saber Translator"

WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    gosu \
    tzdata \
    libgl1 \
    libglib2.0-0 && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd -g 666 translator && \
    useradd -u 666 -g translator -d /app -s /bin/bash translator

# 复制 requirements
COPY --chmod=755 requirements-cpu.txt .

# 升级 pip + 安装依赖
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements-cpu.txt

# 复制文件
COPY --chmod=755 . /app/
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["python", "app.py"]