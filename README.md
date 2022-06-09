# FLOW - Automate SRC workflow

Flow 是一款基于 Docker 搭建的自动化 SRC 工作流，目前它包含了 nuclei、subfinder、naabu、httpx、notify 以及 xray，Flow 的整体工作流程为：子域名发现 -> 端口探测 -> http 服务发现 -> 漏洞扫描。

> 注：可以自行添加 xscan 开启自动化 XSS 漏洞挖掘能力

## 快速上手

```
# 克隆 Flow 到本地
git clone https://github.com/binganao/Flow.git
cd Flow

# 配置子域名发现
vim domains.txt
# 配置目标
vim targets.txt

# 启动 Flow
docker-compose up
```

## 配置

Flow 默认包含了两个配置文件：`notify.yaml`、`subfinder.yaml` 

### notify

> [Notify](https://github.com/projectdiscovery/notify) is a Go-based assistance package that enables you to stream the output of several tools (or read from a file) and publish it to a variety of supported platforms.

配置文件参考（使用 tg 推送）

```
telegram:
  - id: "tel"
    telegram_api_key: ""
    telegram_chat_id: ""
    telegram_format: "{{data}}"
```

### subfinder

