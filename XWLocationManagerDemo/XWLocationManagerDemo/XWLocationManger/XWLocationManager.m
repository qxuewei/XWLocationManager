//
//  XWLocationManger.m
//
//  Created by 邱学伟 on 16/5/23.
//  Copyright © 2016年 邱学伟. All rights reserved.
//  定位只支持iOS8以后->

#import "XWLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

//利用一个宏定义一个单例对象
// .h
#define XWLocationManager_single_interface(class)  + (class *)shared##class;

// .m
// \ 代表下一行也属于宏
// ## 是分隔符
#define XWLocationManager_single_implementation(class) \
static class *_instance; \
\
+ (class *)shared##class \
{ \
if (_instance == nil) { \
_instance = [[self alloc] init]; \
} \
return _instance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
}

@interface XWLocationAddressDetail ()
+ (instancetype)locationAddressDetail:(CLPlacemark *)placemark;
@end

@interface XWLocationManager ()<CLLocationManagerDelegate>
{
}

@property (nonatomic, copy) XWLocationResultInfoCoordinate coordinateInfo;
@property (nonatomic, copy) XWLocationResultInfoAddressDetail addressInfo;
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) CLGeocoder *geocoder;

XWLocationManager_single_interface(XWLocationManager)
@end

@implementation XWLocationManager
XWLocationManager_single_implementation(XWLocationManager)

+ (void)locationCompletionCoordinate:(XWLocationResultInfoCoordinate)coordinate
                       addressDetail:(XWLocationResultInfoAddressDetail)addressDetail
{
    XWLocationManager *manager = [XWLocationManager sharedXWLocationManager];
    manager.coordinateInfo = coordinate;
    manager.addressInfo = addressDetail;
    [manager startUpdatingLocation];
}

- (void)startUpdatingLocation
{
    if (![CLLocationManager locationServicesEnabled]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *AV = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位服务当前可能尚未打开，请设置打开！" preferredStyle:UIAlertControllerStyleAlert];
            [AV addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self locationFailure];
            }]];
            [AV addAction:[UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL: url];
                }
            }]];
            [[XWLocationManager currentTopViewController] presentViewController:AV animated:YES completion:nil];
        });
        
    } else {
        
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusNotDetermined){
            BOOL isHasAlwaysKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil;
            BOOL isHasWhenInUserKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil;
            if (isHasAlwaysKey) {
                [self.manager requestAlwaysAuthorization];
            } else if (isHasWhenInUserKey) {
                [self.manager requestWhenInUseAuthorization];
            } else {
                [self locationFailure];
            }
            [self.manager startUpdatingLocation];
            
        }else if(status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways ){
            [self.manager startUpdatingLocation];
            
        }else{
            // 跳转核心代码
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *AV = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位服务当前可能尚未打开，请设置打开！" preferredStyle:UIAlertControllerStyleAlert];
                [AV addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self locationFailure];
                }]];
                [AV addAction:[UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL: url];
                    }
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
                }]];
                [[XWLocationManager currentTopViewController] presentViewController:AV animated:YES completion:nil];
            });
        }
    }

}

- (void)applicationBecomeActive
{
    [self.manager startUpdatingLocation];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)locationFailure
{
    _coordinateInfo ? _coordinateInfo(0, 0, YES) : nil;
    if (_manager) {
        [_manager stopUpdatingLocation];
        _manager = nil;
    }
    _coordinateInfo = nil;
    _addressInfo = nil;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
        }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            [self.manager startUpdatingLocation];
        }
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
        {
            [self locationFailure];
        }
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    if (location.horizontalAccuracy < 0) {
        NSLog(@"location.horizontalAccuracy:%f,定位失败!!!!",location.horizontalAccuracy);
        [self locationFailure];
    }else{
        
        _coordinateInfo ? _coordinateInfo(location.coordinate.longitude, location.coordinate.latitude, NO) : nil;
        _coordinateInfo = nil;
        
        __weak __typeof(&*self) weakSelf = self;
        [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            __strong __typeof(&*weakSelf) strongSelf = weakSelf;
            if (error == nil) {
                CLPlacemark *placemark = [placemarks firstObject];
                XWLocationAddressDetail *address = [XWLocationAddressDetail locationAddressDetail:placemark];
                strongSelf.addressInfo ? strongSelf.addressInfo(address) : nil;
            }else{
                XWLocationAddressDetail *address = [XWLocationAddressDetail new];
                address.errorLocalizedDescription = error.localizedDescription;
                strongSelf.addressInfo ? strongSelf.addressInfo(address) : nil;
            }
            [strongSelf.manager stopUpdatingLocation];
            strongSelf.manager = nil;
            strongSelf.addressInfo = nil;
        }];
    }
}

- (CLLocationManager *)manager
{
    if(!_manager){
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        _manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _manager.distanceFilter = 10.0;
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            BOOL isHasAlwaysKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil;
            BOOL isHasWhenInUserKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil;
            if (!isHasAlwaysKey && !isHasWhenInUserKey) {
                NSLog(@"请检查您 info.plist 的 NSLocationWhenInUseUsageDescription 或者 NSLocationAlwaysUsageDescription 配置!!!!!");
            }
        }
    }
    return _manager;
}

- (CLGeocoder *)geocoder
{
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

+ (UIViewController *)currentTopViewController
{
    UIViewController *currentViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    while ([currentViewController presentedViewController])
        currentViewController = [currentViewController presentedViewController];
    
    if ([currentViewController isKindOfClass:[UITabBarController class]]
        && ((UITabBarController*)currentViewController).selectedViewController != nil )
    {
        currentViewController = ((UITabBarController*)currentViewController).selectedViewController;
    }
    
    while ([currentViewController isKindOfClass:[UINavigationController class]]
           && [(UINavigationController*)currentViewController topViewController])
    {
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    }
    
    return currentViewController;
}

@end


@implementation XWLocationAddressDetail

+ (instancetype)locationAddressDetail:(CLPlacemark *)placemark
{
    XWLocationAddressDetail *address = [[XWLocationAddressDetail alloc] init];
    address.name = placemark.name;
    address.country = placemark.country;
    address.administrativeArea = placemark.administrativeArea;
    address.locality = placemark.locality;
    address.subLocality = placemark.subLocality;
    address.thoroughfare = placemark.thoroughfare;
    address.subThoroughfare = placemark.subThoroughfare;
    address.postalCode = placemark.postalCode;
    return address;
}

@end
