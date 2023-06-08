# ocr_api_server
2022-5-30 更新

1、新增了简单数字加减乘除验证码计算

```
POST /ocr/b64/json HTTP/1.1
Host: 127.0.0.1:9898
Authorization:Basic f0ngauth
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:97.0) Gecko/20100101 Firefox/97.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
Accept-Encoding: gzip, deflate
Connection: keep-alive
Upgrade-Insecure-Requests: 1
Content-Type: application/x-www-form-urlencoded
Content-Length: 8332

{"typeid":"2","image":"<@BASE64><@IMG_RAW></@IMG_RAW></@BASE64>"}
```

typeid 定义：

1、正常识别

2、数学运算



## 原文档

使用ddddocr的最简api搭建项目，支持docker

**建议python版本3.7-3.9 64位**

再有不好好看文档的我就不管了啊！！！

# 运行方式

## 最简单运行方式

```shell
# 安装依赖
pip install -r requirements.txt -i https://pypi.douban.com/simple

# 运行  可选参数如下
# --port 9898 指定端口,默认为9898
# --ocr 开启ocr模块 默认开启
# --old 只有ocr模块开启的情况下生效 默认不开启
# --det 开启目标检测模式

# 最简单运行方式，只开启ocr模块并以新模型计算
python ocr_server.py --port 9898 --ocr

# 开启ocr模块并使用旧模型计算
python ocr_server.py --port 9898 --ocr --old

# 只开启目标检测模块
python ocr_server.py --port 9898  --det

# 同时开启ocr模块以及目标检测模块
python ocr_server.py --port 9898 --ocr --det

# 同时开启ocr模块并使用旧模型计算以及目标检测模块
python ocr_server.py --port 9898 --ocr --old --det

```

## docker运行方式(目测只能在Linux下部署)

```shell
git clone https://github.com/sml2h3/ocr_api_server.git
# docker怎么安装？百度吧

cd ocr_api_server

# 修改entrypoint.sh中的参数，具体参数往上翻，默认9898端口，同时开启ocr模块以及目标检测模块

# 编译镜像
docker build -t ocr_server:v1 .

# 运行镜像
docker run -p 9898:9898 -d ocr_server:v1

```

# 接口

**具体请看test_api.py文件**

```python
# 1、测试是否启动成功，可以通过直接GET访问http://{host}:{port}/ping来测试，如果返回pong则启动成功

# 2、OCR/目标检测请求接口格式：

# http://{host}:{port}/{opt}/{img_type}/{ret_type}
# opt：操作类型 ocr=OCR det=目标检测 slide=滑块（match和compare两种算法，默认为compare)
# img_type: 数据类型 file=文件上传方式 b64=base64(imgbyte)方式 默认为file方式
# ret_type: 返回类型 json=返回json（识别出错会在msg里返回错误信息） text=返回文本格式（识别出错时回直接返回空文本）

# 例子：

# OCR请求
# resp = requests.post("http://{host}:{port}/ocr/file", files={'image': image_bytes})
# resp = requests.post("http://{host}:{port}/ocr/b64/text", data=base64.b64encode(file).decode())

# 目标检测请求
# resp = requests.post("http://{host}:{port}/det/file", files={'image': image_bytes})
# resp = requests.post("http://{host}:{port}/det/b64/json", data=base64.b64encode(file).decode())

# 滑块识别请求
# resp = requests.post("http://{host}:{port}/slide/match/file", files={'target_img': target_bytes, 'bg_img': bg_bytes})
# jsonstr = json.dumps({'target_img': target_b64str, 'bg_img': bg_b64str})
# resp = requests.post("http://{host}:{port}/slide/compare/b64", files=base64.b64encode(jsonstr.encode()).decode())
```
