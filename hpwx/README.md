# HPWX接口文档

## API列表


0. 协议整体说明
1. 获取打印机列表
2. 提交「企业打印优享会」信息
3. 提交「免费使用申请」信息

## 协议整体说明

cliet每次请求，server都会返回一个json串，形如

```javascript
{
    "content": {}, // or list
    "msg": "ok",
    "rst": 200
}
```

介绍如下：

|名称 |类型 |含义 |
|---|:----:|---:|
|rst | int| 返回状态，参考http 状态码|
|msg | str| 对于状态的补充，例如标示缺失字段|
|content | 字典或者列表| 真正的返回内容，后面分接口介绍|

## 获取打印机列表

### URI

`GET /hp/printers`

### content 内容

`content` 是一个由`打印机详情`字典组成的列表

### 打印机详情
`打印机详情`是一个字典，例如：
```javascript
{
  "adv": "最经济的A3彩色多功能一体机",
  "url": "http://www8.hp.com/cn/zh/products/printers/product-detail.html?oid=5153791&jumpid=reg_r1002_cnzh_c-001_title_r0002#!tab=features",
  "model": "HP Officejet 7610",
  "img": "http://product-images.www8-hp.com/digmedialib/prodimg/lowres/c03670169.png",
  "desc": "宽幅面数码云打印技术多功能一体机"
}
```

每个字段介绍如下：

|名称|类型|含义|是否允许为空|
|----|:----:|:----:|----:|
|adv| str | 宣传语 | N |
|url| str | 产品链接 | N |
|model| str | 打印机型号 | N |
|img| str | 打印机图片链接 | N |
|desc| str | 打印机描述 | N |

## 提交「企业打印优享会」信息

###URI

`POST /hp/ent_pnt`

### 提交参数

|名称|类型|含义|是否允许为空|
|----|:----:|:----:|----:|
|name| str | 姓名 | N |
|gender| int | 0: 女；1: 男 | N |
|org| str | 公司名称 | N |
|cell| str | 手机号 | N |
|expect_feature| str | 期望功能， [A-E] | N |
|wanted_models| str | 期望体验的打印机型号，多个型号使用逗号分割 | N |
|buy_points| str | 采购关注点 [A-H]+ | N |
|ad_source| str | 何种渠道获取信息， [A-F] | N |  
|attend| int | 是否愿意参加免费试用 [01] | N |

### content内容

* rst为200，忽略content内容
* rst不为200，一般是因为字段缺失或者参数有误，可以将「msg」提示给用户

## 提交「免费使用申请」信息

### URI

`POST /hp/free_trail`

### 提交参数

|名称|类型|含义|是否允许为空|
|----|:----:|:----:|----:|
|prov| str | 省份 | N |
|name| str | 姓名 | N |
|cell| str | 手机号 | N |
|email| str | 电子信箱 | N |
|model| str | 机型名称 | N |


### content内容

* rst不为200，一般是因为字段缺失或者参数有误，可以将「msg」提示给用户
* rst为200，content是一个字典，key列表如下：

|名称|类型|含义|
|----|:----:|----:|
|apply_succ| int | 是否申请成功。 1: 成功；0: 失败|
|apply_msg| str | 申请失败原因|
|apply_code| str | 兑换码 |
|apply_value| int | 代金券金额 |




