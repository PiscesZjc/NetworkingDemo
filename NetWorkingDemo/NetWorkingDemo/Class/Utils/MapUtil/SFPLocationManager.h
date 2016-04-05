//
//  SFPLocationManager.h
//  locationDemo
//
//  Created by Zjc on 14-10-23.
//  Copyright (c) 2014年 Zjc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
typedef void (^LocationBlock)(CLLocationCoordinate2D locationCorrrdinate);
typedef void (^LocationErrorBlock) (NSError *error);
typedef void(^NSStringBlock)(NSString *cityString);
typedef void(^NSStringBlock)(NSString *addressString);
typedef void(^NSStringBlock)(NSString *subLocality);


@interface SFPLocationManager : NSObject<CLLocationManagerDelegate>

typedef enum {
    LEJlocationDisable =0,
    LEJlocationNotAllow,
    LEJSmulator//模拟器
}LEJlocationFailed;
@property (nonatomic) CLLocationCoordinate2D lastCoordinate;
@property(nonatomic,strong)NSString *lastCity;
@property (nonatomic,strong) NSString *lastAddress;
@property (nonatomic,strong)NSString *lastSubLocality;
@property (strong, nonatomic) CLLocationManager *locationManager;

+(SFPLocationManager *)shareLocation;
-(void)stopLocation;

/**
 *地球坐标转火星坐标
 *
 */
+(CLLocationCoordinate2D)transformEarthToSpark:(CLLocationCoordinate2D)locationCorrrdinate;

//火星转百度
+(CLLocationCoordinate2D)transformSparkToBaidu:(CLLocationCoordinate2D)locationCorrrdinate;

/**
 *  获取坐标
 *
 *  @param locaiontBlock locaiontBlock description
 */
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock;
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock Address:(NSStringBlock)addressBlock error:(LocationErrorBlock) errorBlock;

/**
 *  获取坐标
 *
 *  @param locaiontBlock locaiontBlock description
 */
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock error:(LocationErrorBlock) errorBlock;

/**
 *  获取坐标和地址
 *
 *  @param locaiontBlock locaiontBlock description
 *  @param addressBlock  addressBlock description
 */
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock;

/**
 *  获取地址
 *
 *  @param addressBlock addressBlock description
 */
- (void) getAddress:(NSStringBlock)addressBlock error:(LocationErrorBlock) errorBlock;

/**
 *  获取城市
 *
 *  @param cityBlock cityBlock description
 */
- (void) getCity:(NSStringBlock)cityBlock;

/**
 *  获取城市和定位失败
 *
 *  @param cityBlock  cityBlock description
 *  @param errorBlock errorBlock description
 */
- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock;

/**
 获取区域
 坐标
 **/
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock SubLocality:(NSStringBlock)subLocalityBlock error:(LocationErrorBlock) errorBlock;

/**
 **/
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock SubLocality:(NSStringBlock)subLocalityBlock city:(NSStringBlock)city error:(LocationErrorBlock) errorBlock;
@end
