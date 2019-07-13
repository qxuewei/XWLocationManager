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
@property (weak, nonatomic) IBOutlet UILabel *userLocationInfo;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//开启定位
- (IBAction)startLocation:(UIButton *)sender {
    
    [XWLocationManager locationCompletionCoordinate:^(double longitude, double latitude, BOOL isRejectLocation) {
       
        NSLog(@"\n\n 用户已经 %@ 位置权限, 经度(longitude): %f -- 纬度(latitude): %f \n\n",isRejectLocation ? @"拒绝" : @"授权",longitude,latitude);
        
    } addressDetail:^(XWLocationAddressDetail *address) {
       
        NSString *show;
        if (address.errorLocalizedDescription) {
            show = address.errorLocalizedDescription;
            NSLog(@"定位失败: %@",show);
        } else {
            show = [NSString stringWithFormat:@"\n\n定位成功!! \n当前地址名称(name): %@ \n国(country): %@ \n省(administrativeArea): %@ \n直辖市/地级市(locality): %@ \n县级市/区(subLocality): %@ \n街道(thoroughfare): %@ \n门牌号(subThoroughfare): %@ \n邮编(postalCode): %@ \n", address.name, address.country, address.administrativeArea, address.locality, address.subLocality, address.thoroughfare, address.subThoroughfare, address.postalCode];
            NSLog(@"%@",show);
        }
        self.userLocationInfo.text = show;
        
    }];
    
}
@end
