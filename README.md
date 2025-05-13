## Webhostmost在Node.js环境搭建vless-ws-tls脚本

1、UUID=你的uuid PORT=服务器可使用的端口 都是非必填，自动随机，但DOMAIN=服务器域名 是必填的

2、快捷方式```bash ndjs.sh```，如果想变更uuid、端口、服务器域名，可将变量放在快捷方式前面快速执行

3、默认自动安装cron保活

Webhostmost专用一键脚本(无交互)：

```
wget -N https://raw.githubusercontent.com/yonggekkk/vless-nodejs/main/ndjs.sh && DOMAIN=服务器域名 bash ndjs.sh
```
----------------------------------------------------------

## Claw.Cloud在Node.js环境搭建vless-ws-tls脚本

填写UUID、端口、域名三个变量再运行脚本，现实一键无交互运行，每次重装后输出节点信息不变

Claw.Cloud专用一键脚本(无交互)：

```
wget -N https://raw.githubusercontent.com/yonggekkk/vless-nodejs/main/app.js && UUID=你的uuid PORT=服务器可使用的端口 DOMAIN=服务器域名 node app.js
```
----------------------------------------------------------

#### 相关教程可参考甬哥博客，视频教程如下：

[Claw.cloud免费VPS搭建代理最终教程：全网最简单 | 两大无交互回车脚本 | 套CDN优选IP | workers反代 | ArgoSB隧道搭建](https://youtu.be/Esofirx8xrE)

更新中……

----------------------------------------------------------

### 交流平台：[甬哥博客地址](https://ygkkk.blogspot.com)、[甬哥YouTube频道](https://www.youtube.com/@ygkkk)、[甬哥TG电报群组](https://t.me/+jZHc6-A-1QQ5ZGVl)、[甬哥TG电报频道](https://t.me/+DkC9ZZUgEFQzMTZl)

----------------------------------------------------------
### 感谢支持！微信打赏甬哥侃侃侃ygkkk
![41440820a366deeb8109db5610313a1](https://github.com/user-attachments/assets/e5b1f2c0-bd2c-4b8f-8cda-034d3c8ef73f)

----------------------------------------------------------
### 感谢你右上角的star🌟
[![Stargazers over time](https://starchart.cc/yonggekkk/vless-nodejs.svg)](https://starchart.cc/yonggekkk/vless-nodejs)

### 声明：所有代码来源于Github社区与ChatGPT的整合 [qwer-search](https://github.com/qwer-search/Webhostmost-ws-nodejs)
