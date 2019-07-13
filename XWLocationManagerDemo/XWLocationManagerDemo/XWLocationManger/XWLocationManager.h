//
//  XWLocationManger.h
//  Spread
//
//  Created by 邱学伟 on 16/5/23.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWLocationAddressDetail : NSObject

/**
 地址简述 (例如: Apple Inc)
 */
@property (nonatomic, copy) NSString *name;

/**
 国家
 */
@property (nonatomic, copy) NSString *country;

/**
 省
 */
@property (nonatomic, copy) NSString *administrativeArea;

/**
 直辖市/地级市
 */
@property (nonatomic, copy) NSString *locality;

/**
 县级市/区
 */
@property (nonatomic, copy) NSString *subLocality;

/**
 街道
 */
@property (nonatomic, copy) NSString *thoroughfare;

/**
 门牌号
 */
@property (nonatomic, copy) NSString *subThoroughfare;

/**
 邮政编码
 */
@property (nonatomic, copy) NSString *postalCode;

/**
 定位失败的描述信息
 */
@property (nonatomic, copy) NSString *errorLocalizedDescription;

@end

typedef void(^XWLocationResultInfoCoordinate)(double longitude, double latitude, BOOL isRejectLocation);
typedef void(^XWLocationResultInfoAddressDetail)(XWLocationAddressDetail *address);

@interface XWLocationManager : NSObject

/**
 定位

 @param coordinate 经纬度回调
 @param addressDetail 编码后地址回调
 */
+ (void)locationCompletionCoordinate:(XWLocationResultInfoCoordinate)coordinate
                       addressDetail:(XWLocationResultInfoAddressDetail)addressDetail;

@end
