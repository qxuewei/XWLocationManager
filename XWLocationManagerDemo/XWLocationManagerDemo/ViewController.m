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
    // Do any additional setup after loading the view, typically from a nib.
//    self.userLocationInfo setn
}

//开启定位
- (IBAction)startLocation:(UIButton *)sender {
    [[XWLocationManager sharedXWLocationManager] getCurrentLocation:^(CLLocation *location, CLPlacemark *placeMark, NSString *error) {
        if (error) {
            NSLog(@"定位出错,错误信息:%@",error);
        }else{
            NSLog(@"定位成功:经度:%f 纬度:%lf 当前地址:%@  \n location详细信息:%@ \n ",location.coordinate.latitude, location.coordinate.longitude, placeMark.name, location);
            [self.userLocationInfo setText:[NSString stringWithFormat:@"定位成功:经度:%f 纬度:%lf 当前地址:%@  \n location详细信息:%@ \n ",location.coordinate.latitude, location.coordinate.longitude, placeMark.name, location]];
        }
    } onViewController:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
