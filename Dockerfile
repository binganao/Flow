FROM --platform=amd64 golang:1.18.2

# 设置国内代理
ENV GO111MODULE=on
ENV GOPROXY=https://goproxy.cn

# 安装所需依赖
RUN apt update && apt install -y libpcap-dev

# 安装所需工具
RUN go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest && go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest && go install -v github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest && go install -v github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest && go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest && go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest && go install -v github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest && go install -v github.com/projectdiscovery/notify/cmd/notify@latest && go install -v github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest && go install -v github.com/projectdiscovery/uncover/cmd/uncover@latest && go install -v github.com/tomnomnom/anew@latest && go install -v github.com/boy-hack/ksubdomain/cmd/ksubdomain@latest

# 安装 xscan xray
# COPY ./bin/xscan /go/bin/xscan
COPY ./bin/xray /go/bin/xray

# 复制脚本
COPY ./script/init.sh /script/init.sh
COPY ./script/auto.sh /script/auto.sh

# 工作目录
WORKDIR /script
RUN chmod +x init.sh && chmod +x auto.sh