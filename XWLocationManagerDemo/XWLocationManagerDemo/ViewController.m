//
//  ViewController.m
//  XWLocationManagerDemo
//
//  Created by carayfire－Develop on 16/5/24.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "ViewController.h"
#import "XWLocationManager.h"
@interface ViewController ()

/** 用户位置信息 */
@property (weak, nonatomic) IBOutlet UILabel *userLocationInfo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//开启定位
- (IBAction)startLocation:(UIButton *)sender {
    [[XWLocationManager sharedXWLocationManager] getCurrentLocation:^(CLLocation *location, CLPlacemark *placeMark, NSString *error) {
        if (error) {
            NSLog(@"定位出错,错误信息:%@",error);
        }else{
            
            NSString *printStr = [NSString stringWithFormat:@"定位成功:经度:%f 纬度:%lf 当前地址:%@  \n\n 地址数据:国: %@ 省/市: %@  区: %@ 街道: %@  子街道: %@ \n\n location详细信息:%@ \n ",location.coordinate.latitude, location.coordinate.longitude, placeMark.name, placeMark.country, placeMark.locality, placeMark.subLocality, placeMark.thoroughfare ,placeMark.subAdministrativeArea,location];
            NSLog(@"%@",printStr);
            [self.userLocationInfo setText:printStr];
        }
    } onViewController:self];
}


/*
 @property (nonatomic, readonly, copy, nullable) NSString *name; // eg. Apple Inc.
 @property (nonatomic, readonly, copy, nullable) NSString *thoroughfare; // street name, eg. Infinite Loop
 @property (nonatomic, readonly, copy, nullable) NSString *subThoroughfare; // eg. 1
 @property (nonatomic, readonly, copy, nullable) NSString *locality; // city, eg. Cupertino
 @property (nonatomic, readonly, copy, nullable) NSString *subLocality; // neighborhood, common name, eg. Mission District
 @property (nonatomic, readonly, copy, nullable) NSString *administrativeArea; // state, eg. CA
 @property (nonatomic, readonly, copy, nullable) NSString *subAdministrativeArea; // county, eg. Santa Clara
 @property (nonatomic, readonly, copy, nullable) NSString *postalCode; // zip code, eg. 95014
 @property (nonatomic, readonly, copy, nullable) NSString *ISOcountryCode; // eg. US
 @property (nonatomic, readonly, copy, nullable) NSString *country; // eg. United States
 @property (nonatomic, readonly, copy, nullable) NSString *inlandWater; // eg. Lake Tahoe
 @property (nonatomic, readonly, copy, nullable) NSString *ocean; // eg. Pacific Ocean
 @property (nonatomic, readonly, copy, nullable) NSArray<NSString *> *areasOfInterest; // eg. Golden Gate Park
 
 NSLog(@"name = %@",placeMark.name);                                    //  位置名
 NSLog(@"thoroughfare = %@",placeMark.thoroughfare);                    //  街道
 NSLog(@"subAdministrativeArea = %@",placeMark.subAdministrativeArea);  //  子街道
 NSLog(@"locality = %@",placeMark.locality);                            //  市
 NSLog(@"subLocality = %@",placeMark.subLocality);                      //  区
 NSLog(@"country = %@",placeMark.country);                              //  国家
 */

@end
