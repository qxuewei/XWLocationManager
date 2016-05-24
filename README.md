# XWLocationManager
一行代码获取用户地理位置和逆地理编码后的所在地址,用block方式替代原生代理方法

显示效果 ＜/br＞

![](https://github.com/qxuewei/XWLocationManager/raw/master/GIF/XWLocationManagerGIF.gif)  

使用方法:
    1.在iOS8.0之后定位, 必须在info.plist, 配置NSLocationWhenInUseUsageDescription 或者 NSLocationAlwaysUsageDescription
    2.在需要获取用户位置的地方
    <code><pre>
            [[XWLocationManager sharedXWLocationManager] getCurrentLocation:^(CLLocation *location, CLPlacemark *placeMark, NSString *error) {
                if (error) {
                    NSLog(@"定位出错,错误信息:%@",error);
                }else{
                    NSLog(@"定位成功:经度:%f 纬度:%lf 当前地址:%@  \n location详细信息:%@ \n ",location.coordinate.latitude, location.coordinate.longitude, placeMark.name, location);
                    [self.userLocationInfo setText:[NSString stringWithFormat:@"定位成功:经度:%f 纬度:%lf 当前地址:%@  \n location详细信息:%@ \n ",location.coordinate.latitude, location.coordinate.longitude, placeMark.name, location]];
                    }
            } onViewController:self];
    <code/><pre/>
    即可获取用户当前位置的经纬度和当前所在地址.


[ 我的博客 ]( http://blog.csdn.net/qxuewei )
