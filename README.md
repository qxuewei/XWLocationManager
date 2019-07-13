# XWLocationManager

### **一行代码获取当前经纬度和位置信息**

![显示效果](https://github.com/qxuewei/XWLocationManager/raw/master/GIF/XWLocationManagerGIF.gif)  

### 使用方式

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


#### **[个人技术博客](http://blog.csdn.net/qxuewei)**
