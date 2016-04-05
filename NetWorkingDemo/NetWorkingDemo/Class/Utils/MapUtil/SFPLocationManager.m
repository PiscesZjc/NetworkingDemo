//
//  SFPLocationManager.m
//  locationDemo
//
//  Created by Zjc on 14-10-23.
//  Copyright (c) 2014年 Zjc. All rights reserved.
//
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#import "SFPLocationManager.h"
#import <UIKit/UIKit.h>
#define CustomErrorDomain @"com.cwei.anniedeer.test"

#define sparkCoefficientA 6378245.0
#define sparkCoefficientEE 0.00669342162296594323

@interface SFPLocationManager ()

@property (nonatomic, copy) LocationBlock locationBlock;
@property (nonatomic, copy) NSStringBlock cityBlock;
@property (nonatomic, copy) NSStringBlock addressBlock;
@property (nonatomic,copy) NSStringBlock  subLocality;//获取区域，新增
@property (nonatomic, copy) LocationErrorBlock errorBlock;
@property (strong, nonatomic) CLPlacemark *placeMark;
@end

@implementation SFPLocationManager


+(SFPLocationManager *)shareLocation
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        _locationManager=[[CLLocationManager alloc] init];
        _locationManager.delegate=self;
        //        _locationManager.distanceFilter = 1000;
    }
    return self;
};



/**
 *  获取坐标
 *
 *  @param locaiontBlock locaiontBlock description
 */
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock
{
    self.locationBlock = locaiontBlock;
    [self startLocation];
}
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock Address:(NSStringBlock)addressBlock error:(LocationErrorBlock) errorBlock
{
    self.locationBlock = locaiontBlock;
    self.addressBlock = addressBlock;
    self.errorBlock = errorBlock;
    [self startLocation];
}
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock error:(LocationErrorBlock) errorBlock{
    self.locationBlock = locaiontBlock;
    self.errorBlock = errorBlock;
    [self startLocation];
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock
{
    self.locationBlock = locaiontBlock;
    self.addressBlock = addressBlock;
    [self startLocation];
}

- (void) getAddress:(NSStringBlock)addressBlock error:(LocationErrorBlock) errorBlock
{
    self.addressBlock = addressBlock;
    self.errorBlock = errorBlock;
    [self startLocation];
}

- (void) getCity:(NSStringBlock)cityBlock
{
    self.cityBlock = cityBlock;
    [self startLocation];
}

- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock
{
    self.cityBlock = cityBlock;
    self.errorBlock = errorBlock;
    [self startLocation];
}
//
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock SubLocality:(NSStringBlock)subLocalityBlock error:(LocationErrorBlock) errorBlock

{
    self.locationBlock = locaiontBlock;
    self.subLocality = subLocalityBlock;
    self.errorBlock = errorBlock;
    [self startLocation];
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock SubLocality:(NSStringBlock)subLocalityBlock city:(NSStringBlock)city error:(LocationErrorBlock) errorBlock{
    self.locationBlock = locaiontBlock;
    self.subLocality = subLocalityBlock;
    self.cityBlock = city;
    self.errorBlock = errorBlock;
    [self startLocation];
}

-(void)startLocation
{
    [_locationManager startUpdatingLocation];
    if (IS_OS_8_OR_LATER) {
        [_locationManager requestWhenInUseAuthorization];
    }
    NSError *error = nil;
    NSDictionary *userInfo;
    
    if(TARGET_IPHONE_SIMULATOR){//区分是模拟器还是真机
        
        userInfo = [NSDictionary dictionaryWithObject:@"is a error test"                                                                      forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:CustomErrorDomain code:LEJSmulator userInfo:userInfo];
        if (_errorBlock) {
            _errorBlock(error);
            _errorBlock = nil;
        }
        [self stopLocation];
        
        
    }else if(![CLLocationManager locationServicesEnabled]){
        userInfo = [NSDictionary dictionaryWithObject:@"is a error test"                                                                      forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:CustomErrorDomain code:LEJlocationDisable userInfo:userInfo];
        if (_errorBlock) {
            _errorBlock(error);
            _errorBlock = nil;
        }
        [self stopLocation];
    }
}

-(void)stopLocation
{
    [_locationManager stopUpdatingLocation];
}


#pragma mark - CCLocationManagerDelegate
//当用户改变位置的时候，CLLocationManager回调的方法
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.lastCoordinate=newLocation.coordinate;
    //TODO:因为地理位置需要反编码一旦网络错误或者访问次数太多就会出问题 kCLErrorDomain Code=2 现在项目不需要反编码 就直接去掉
    //    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //    CLLocationCoordinate2D myCoOrdinate=newLocation.coordinate;
    //
    //    CLLocation *location = [[CLLocation alloc] initWithLatitude:myCoOrdinate.latitude longitude:myCoOrdinate.longitude];
    //    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
    //     {
    //         if (error)
    //         {
    //             DDLogError(@"failed with error: %@", error);
    //             return;
    //         }
    //         if(placemarks.count > 0)
    //         {
    //             NSString *MyAddress = @"";
    //             NSString *city = @"";
    //             NSString *subLocality = @"";
    //             CLPlacemark * placemark=placemarks[0];
    //             if([placemark.addressDictionary objectForKey:@"FormattedAddressLines"] != NULL)
    //                 MyAddress = [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
    //             else
    //                 MyAddress = @"Address Not founded";
    //
    //             if([placemark.addressDictionary objectForKey:@"SubAdministrativeArea"] != NULL)
    //                 city = [placemark.addressDictionary objectForKey:@"SubAdministrativeArea"];
    //             else if([placemark.addressDictionary objectForKey:@"City"] != NULL)
    //                 city = [placemark.addressDictionary objectForKey:@"City"];
    //             else if([placemark.addressDictionary objectForKey:@"Country"] != NULL)
    //                 city = [placemark.addressDictionary objectForKey:@"Country"];
    //             else
    //                 city = @"City Not founded";
    //
    //             if([placemark.addressDictionary objectForKey:@"SubLocality"] !=NULL)
    //                 subLocality = [placemark.addressDictionary objectForKey:@"SubLocality"];
    //             else
    //                 subLocality = @"SubLocality Not founded";
    //
    //             self.lastCity = city;
    //             self.lastAddress= MyAddress;
    //             self.lastSubLocality = subLocality;
    //         }
    //
    //         [self stopLocation];
    //
    //         if (_cityBlock) {
    //             _cityBlock(_lastCity);
    //             _cityBlock = nil;
    //         }
    //
    //         if (_locationBlock) {
    //             _locationBlock(_lastCoordinate);
    //             _locationBlock = nil;
    //         }
    //
    //         if (_addressBlock) {
    //             _addressBlock(_lastAddress);
    //             _addressBlock = nil;
    //         }
    //
    //         if (_subLocality){
    //             _subLocality(_lastSubLocality);
    //             _subLocality = nil;
    //         }
    //
    //     }];
    
    
    [self stopLocation];
    if (_locationBlock) {
        _locationBlock(_lastCoordinate);
        _locationBlock = nil;
    }
}


//当iPhone无法获得当前位置的信息时，所回调的方法是
-(void)locationManager: (CLLocationManager *)manager didFailLoadWithError:(NSError *)error
{
    if (_errorBlock) {
        _errorBlock(error);
        _errorBlock = nil;
    }
    
    [self stopLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSError *error = nil;
    NSDictionary *userInfo;
    
    if (status == kCLAuthorizationStatusDenied) {
        
        userInfo = [NSDictionary dictionaryWithObject:@"is a error test"                                                                      forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:CustomErrorDomain code:LEJlocationNotAllow userInfo:userInfo];
        if (_errorBlock) {
            _errorBlock(error);
            _errorBlock = nil;
        }
        [self stopLocation];
        
    }else if (status == kCLAuthorizationStatusRestricted){
        userInfo = [NSDictionary dictionaryWithObject:@"is a error test"                                                                      forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:CustomErrorDomain code:LEJlocationDisable userInfo:userInfo];
        if (_errorBlock) {
            _errorBlock(error);
            _errorBlock = nil;
        }
        [self stopLocation];
    }
    
}



- (void) getReverseGeocode
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocationCoordinate2D myCoOrdinate=self.lastCoordinate;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:myCoOrdinate.latitude longitude:myCoOrdinate.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error)
         {
             DDLogError(@"failed with error: %@", error);
             return;
         }
         if(placemarks.count > 0)
         {
             NSString *MyAddress = @"";
             NSString *city = @"";
             NSString *subLocality = @"";
             CLPlacemark * placemark=placemarks[0];
             if([placemark.addressDictionary objectForKey:@"FormattedAddressLines"] != NULL)
                 MyAddress = [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             else
                 MyAddress = @"Address Not founded";
             
             if([placemark.addressDictionary objectForKey:@"SubAdministrativeArea"] != NULL)
                 city = [placemark.addressDictionary objectForKey:@"SubAdministrativeArea"];
             else if([placemark.addressDictionary objectForKey:@"City"] != NULL)
                 city = [placemark.addressDictionary objectForKey:@"City"];
             else if([placemark.addressDictionary objectForKey:@"Country"] != NULL)
                 city = [placemark.addressDictionary objectForKey:@"Country"];
             else
                 city = @"City Not founded";
             
             if([placemark.addressDictionary objectForKey:@"SubLocality"] !=NULL)
                 subLocality = [placemark.addressDictionary objectForKey:@"SubLocality"];
             else
                 subLocality = @"SubLocality Not founded";
             
             self.lastCity = city;
             self.lastAddress=MyAddress;
             self.lastSubLocality = subLocality;
         }
         
         [self stopLocation];
     }];
    
}

/**
 *地球坐标转火星坐标
 *
 */

+(CLLocationCoordinate2D)transformEarthToSpark:(CLLocationCoordinate2D)locationCorrrdinate{
    double wgLat = locationCorrrdinate.latitude;
    double wgLon = locationCorrrdinate.longitude;
    if ([self outOfChina:locationCorrrdinate])
    {
        return locationCorrrdinate;
    }
    double dLat = [self transformLat:(wgLon - 105.0) laty:(wgLat - 35.0)];
    double dLon = [self transformLon:(wgLon - 105.0) lony:(wgLat - 35.0)];
    double radLat = wgLat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - sparkCoefficientEE * magic * magic;
    double sqrtMagic = sqrt(magic);
    
    //加点盐
    dLat = (dLat * 180.0) / ((sparkCoefficientA * (1 - sparkCoefficientEE)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (sparkCoefficientA / sqrtMagic * cos(radLat) * M_PI);
    double mgLat = wgLat + dLat;
    double mgLon = wgLon + dLon;
    
    CLLocationCoordinate2D newLocationCorrrdinate = CLLocationCoordinate2DMake(mgLat, mgLon);
    
    //    double dLat = transformLat(wgLon - 105.0, wgLat - 35.0);
    //    double dLon = transformLon(wgLon - 105.0, wgLat - 35.0);
    //    double radLat = wgLat / 180.0 * pi;
    //    double magic = Math.Sin(radLat);
    //    magic = 1 - ee * magic * magic;
    //    double sqrtMagic = Math.Sqrt(magic);
    //    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    //    dLon = (dLon * 180.0) / (a / sqrtMagic * Math.Cos(radLat) * pi);
    //    mgLat = wgLat + dLat;
    //    mgLon = wgLon + dLon;
    
    return newLocationCorrrdinate;
}

/**
 *是否在国内
 *
 */
+(BOOL)outOfChina:(CLLocationCoordinate2D)locationCorrrdinate
{
    if (locationCorrrdinate.longitude < 72.004 || locationCorrrdinate.longitude > 137.8347)
        return true;
    if (locationCorrrdinate.latitude < 0.8293 || locationCorrrdinate.latitude > 55.8271)
        return true;
    return false;
}

/**
 *转换latitude坐标
 *
 */
+(double)transformLat:(double)x laty:(double)y
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

/**
 *转换longitude坐标
 *
 */
+(double)transformLon:(double)x lony:(double)y
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}


+(CLLocationCoordinate2D)transformSparkToBaidu:(CLLocationCoordinate2D)locationCorrrdinate
//void bd_encrypt(double gg_lat, double gg_lon, double &bd_lat, double &bd_lon)
{
    double x = locationCorrrdinate.longitude, y = locationCorrrdinate.latitude;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) + 0.000003 * cos(x * M_PI);
    double bd_lon = z * cos(theta) + 0.0065;
    double bd_lat = z * sin(theta) + 0.006;
    return CLLocationCoordinate2DMake(bd_lat, bd_lon);
}

@end
