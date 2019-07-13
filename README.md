# XWLocationManager

![显示效果](https://github.com/qxuewei/XWLocationManager/raw/master/GIF/XWLocationManagerGIF.gif)  

## **一行代码获取当前经纬度和位置信息**

### 使用方式

#### 1.使用 CocoaPods
`pod 'XWLocationManager'`

#### 2.手动导入文件
将 `XWLocationManager` 文件夹添加到项目中

导入主头文件 `#import "XWLocationManager.h"`

##### 1. info.plist 配置 `NSLocationWhenInUseUsageDescription` 、`NSLocationAlwaysUsageDescription` 、 `NSLocationWhenInUseUsageDescription` 三项

eg:

```
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>请打开定位权限以便在发布信息时上传当前位置</string>
    <key>NSLocationAlwaysUsageDescription</key>
    <string>请打开定位权限以便在发布信息时上传当前位置</string>
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>请打开定位权限以便在发布信息时上传当前位置</string>
```

##### 2. 在需要获取位置处调用此方法

```
[XWLocationManager locationCompletionCoordinate:^(double longitude, double latitude, BOOL isRejectLocation) { 
    
} addressDetail:^(XWLocationAddressDetail *address) {
    
}];
```

###### 控制台打印示例：

```
2019-07-13 17:40:35.985424+0800 123[19494:5033743] 

用户已经 授权 位置权限, 经度(longitude): 116.307507 -- 纬度(latitude): 39.977254 

2019-07-13 17:40:37.052853+0800 123[19494:5033743] 

定位成功!! 
当前地址名称(name): 知音楼 
国(country): 中国 
省(administrativeArea): (null) 
直辖市/地级市(locality): 北京市 
县级市/区(subLocality): 海淀区 
街道(thoroughfare): 丹棱街6号中关村金融大厦12层 
门牌号(subThoroughfare): (null) 
邮编(postalCode): (null)

```

#### **[个人技术博客](http://blog.csdn.net/qxuewei)**
