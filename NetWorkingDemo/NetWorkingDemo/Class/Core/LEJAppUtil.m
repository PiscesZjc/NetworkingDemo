//
//  LEJAppUtil.m
//  SunFlowerProvider
//
//  Created by WeiChengjiong on 7/12/14.
//  Copyright (c) 2014 9Top. All rights reserved.
//

#import "LEJAppUtil.h"

#define  spm_identifier  @"imagecache"

@implementation LEJAppUtil

//+ (NSString *)fulfillResourceUrl:(NSString *)url
//{
//    if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"] ) {
//        return url;
//    } else {
//        return [NSString stringWithFormat:@"%@/%@", AppContext.cdnUrl, url];
//    }
//}
//
//+ (NSString *)spliceSouurceUrlBySize:(CGSize)size url:(NSString *)url
//{
//    if(size.height!=0 && size.width!=0){
//        NSMutableString *newUrl = [NSMutableString stringWithString:url];
//        NSString *lastPart;
//        if ([UIScreen mainScreen].scale == 2.f ) {
//            lastPart = [NSString stringWithFormat:@"?imageView/2/w/%@/h/%@",[NSString stringWithFormat:@"%lu",(unsigned long)size.width*2],[NSString stringWithFormat:@"%lu",(unsigned long)size.height*2]];
//        }else if ([UIScreen mainScreen].scale == 3.f ) {
//            lastPart = [NSString stringWithFormat:@"?imageView/2/w/%@/h/%@",[NSString stringWithFormat:@"%lu",(unsigned long)size.width*3],[NSString stringWithFormat:@"%lu",(unsigned long)size.height*3]];
//        }
//        
//        [newUrl appendString:lastPart];
//        return newUrl;
//    }else{
//        return [NSString stringWithFormat:@"%@/%@", AppContext.cdnUrl, url];
//    }
//}

+ (void)showAlertMessage:(NSString *)message
{
    [self showAlertMessage:message delegate:nil];
}

+ (void)showAlertMessage:(NSString *)message delegate:(id)delegate
{
    [LEJAlertView showAlertWithMessage:message duration:1.0f];
}

+ (BOOL)validateNumber:(NSString *)number
{
    BOOL res = YES;
    NSCharacterSet *tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

+ (BOOL)isValidateEmail:(NSString *)Email
{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}

+ (UIImage *)resizableImageByName:(NSString *)name
{
    return [self resizableImageByName:name capInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
}

+ (UIImage *)resizableImageByName:(NSString *)name capInsets:(UIEdgeInsets)capInsets
{
    UIImage *image = [UIImage imageNamed:name];
    return [image resizableImageWithCapInsets:capInsets];
}

+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = format;
    return dateFormatter;
}

+ (NSDateFormatter *)serverDateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [self dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    });
    return dateFormatter;
}

+ (NSDateFormatter *)dateFormatter1
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [self dateFormatterWithFormat:@"昨天 HH:mm"];
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
    });
    return dateFormatter;
}

+ (NSDateFormatter *)dateFormatter2
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [self dateFormatterWithFormat:@"MM-dd HH:mm"];
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
    });
    return dateFormatter;
}

+ (NSDateFormatter *)dateFormatter7
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [self dateFormatterWithFormat:@"yyyy.MM.dd"];
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
    });
    return dateFormatter;
}

+ (NSDateFormatter *)dateFormatter4
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [self dateFormatterWithFormat:@"yyyy-MM-dd"];
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
    });
    return dateFormatter;
}

+ (NSDateFormatter *)dateFormatter3
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [self dateFormatterWithFormat:@"yyyy-MM-dd HH:mm"];
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
    });
    return dateFormatter;
}

+ (NSDateFormatter *)dateFormatter5
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [self dateFormatterWithFormat:@"HH"];
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
    });
    return dateFormatter;
}

+ (NSDateFormatter *)dateFormatter6
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [self dateFormatterWithFormat:@"HH:mm"];
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
    });
    return dateFormatter;
}


+ (NSString *)formattedPublishTimeToNow:(NSDate *)fromDate
{
    if (!fromDate) {
        return @"";
    }
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit1 = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    int unit2 = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *delta = [calendar components:unit1 fromDate:fromDate toDate:now options:0];
    NSDateComponents *fromCmps = [calendar components:unit2 fromDate:fromDate];
    NSDateComponents *toCmps = [calendar components:unit2 fromDate:now];
    
    if (fromCmps.year == toCmps.year) {
        // 今年
        if (fromCmps.month == toCmps.month && fromCmps.day == toCmps.day) {
            // 今天
            if (delta.hour >= 1) {
                // 至少是一个小时之前发布的
                return [NSString stringWithFormat:@"%ld小时前", (long)delta.hour];
            } else if (delta.minute >= 1) {
                // 1~59分钟之前发布的
                return [NSString stringWithFormat:@"%ld分钟前", (long)delta.minute];
            } else {
                // 1分钟内发布的
                return @"刚刚";
            }
        } else if (fromCmps.month == toCmps.month && fromCmps.day == toCmps.day - 1) {
            // 昨天
            NSDateFormatter *format = [self dateFormatter1];
            return [format stringFromDate:fromDate];
        } else {
            // 前天及以前
            NSDateFormatter *format = [self dateFormatter2];
            return [format stringFromDate:fromDate];
        }
    } else {
        // 往年
        NSDateFormatter *format = [self dateFormatter3];
        return [format stringFromDate:fromDate];
    }
}
//获取当前时间的年月日时分秒
+ (NSDateComponents*)getYearDay:(NSDate*)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    return comps;
}

//获取星期几
+ (NSDateComponents*)getWeekDay:(NSDate*)dateTime
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:dateTime];
    return comps;
}

+ (void)setFormattedPublishTimeToNow:(NSDate *)fromDate withBlockAsync:(void(^)(NSString *, NSDictionary *))block
{
    [self setFormattedPublishTimeToNow:fromDate withBlockAsync:block userInfo:nil];
}

+ (void)setFormattedPublishTimeToNow:(NSDate *)fromDate withBlockAsync:(void(^)(NSString *, NSDictionary *))block userInfo:(NSDictionary *)userInfo
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *formattedTime = [self formattedPublishTimeToNow:fromDate];
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(formattedTime, userInfo);
            });
        }
    });
}

+ (NSString *)formattedDeadlineTimeFromNow:(NSDate *)fromDate
{
    if (!fromDate) {
        return @"";
    }
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *fromCmps = [calendar components:unit fromDate:fromDate];
    NSDateComponents *toCmps = [calendar components:unit fromDate:now];
    
    if (fromCmps.year == toCmps.year) {
        // 今年
        NSDateFormatter *format = [self dateFormatter2];
        return [format stringFromDate:fromDate];
    } else {
        // 其他时间
        NSDateFormatter *format = [self dateFormatter3];
        return [format stringFromDate:fromDate];
    }
}

+ (void)setFormattedDeadlineTimeFromNow:(NSDate *)fromDate withBlockAsync:(void(^)(NSString *))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *formattedTime = [self formattedDeadlineTimeFromNow:fromDate];
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(formattedTime);
            });
        }
    });
}

+ (void)setImage:(UIImage *)image forURL:(NSString *)URL {
    
    NSString *cachePath = [[WKFileUtil deviceCachePath] stringByAppendingPathComponent:spm_identifier];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:spm_identifier]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSData *imageData = nil;
    NSString *fileExtension = [[URL componentsSeparatedByString:@"."] lastObject];
    fileExtension = fileExtension.lowercaseString;
    
    if([fileExtension isEqualToString:@"png"]) {
        imageData = UIImagePNGRepresentation(image);
    } else if([fileExtension isEqualToString:@"jpg"] || [fileExtension isEqualToString:@"jpeg"]) {
        imageData = UIImageJPEGRepresentation(image, 1.f);
    } else return;
    [imageData writeToFile:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu.%@", (unsigned long)URL.hash, fileExtension]] atomically:YES];
}

+ (UIImage *)getImageForURL:(NSString *)URL {
    
    NSString *cachePath = [[ WKFileUtil deviceCachePath] stringByAppendingPathComponent:spm_identifier];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:spm_identifier]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSString *fileExtension = [[URL componentsSeparatedByString:@"."] lastObject];
    fileExtension = fileExtension.lowercaseString;
    NSString *path = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu.%@", (unsigned long)URL.hash, fileExtension]];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
    }
    return nil;
}

+ (void)removeLocalFile:(NSString *)URL
{
    NSString *cachePath = [[ WKFileUtil deviceCachePath] stringByAppendingPathComponent:spm_identifier];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:spm_identifier]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSString *fileExtension = [[URL componentsSeparatedByString:@"."] lastObject];
    fileExtension = fileExtension.lowercaseString;
    NSString *path = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu.%@", (unsigned long)URL.hash, fileExtension]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *err;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&err ];
    }
}


#define kCityList @"CityList"

//+ (void)archiveAreaList:(SFPAreaObject *)chinaArea
//{
//    NSString *path = [[WKFileUtil deviceDocumentsPath] stringByAppendingPathComponent:kCityList];
//    if (![NSKeyedArchiver archiveRootObject:chinaArea toFile:path]) {
//        DDLogError(@"<Disk Error> save area object fail!");
//    }
//}
//
//+ (SFPAreaObject *)unarchiveAreaList
//{
//    NSString *path = [[WKFileUtil deviceDocumentsPath] stringByAppendingPathComponent:kCityList];
//    SFPAreaObject *chinaArea = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//    if (!chinaArea) {
//        chinaArea = [LEJAppUtil storeAreaInfoFromPlist];
//    }
//    return chinaArea;
//}

//+ (SFPAreaObject *)storeAreaList:(NSArray *)areaListBeforeParse
//{
//    if (!areaListBeforeParse) {
//        SFPAreaObject *chinaArea = [self unarchiveAreaList];
//        if (chinaArea) {
//            // 如果系统中已经有缓存了，那么不再做解析
//            return chinaArea;
//        } else {
//            // 如果没有传入区域列表，并且文件系统中没有缓存，那么使用city.plist配置文件
//            areaListBeforeParse = [WKFileUtil arrayFromConfig:@"city.plist"];
//        }
//    }
//    // 解析参数中的地区列表
//    SFPAreaObject *chinaArea = [[SFPAreaObject alloc] init];
//    [areaListBeforeParse enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        // 省份信息
//        NSDictionary *province = obj;
//        SFPAreaObject *provinceArea = [[SFPAreaObject alloc] init];
//        provinceArea.code = [(NSNumber *)province[@"area_code"] stringValue];
//        provinceArea.oldCode = province[@"old_id"];
//        provinceArea.name = province[@"name"];
//        NSArray *cities = province[@"children"];
//        [cities enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            // 城市信息
//            NSDictionary *city = obj;
//            SFPAreaObject *cityArea = [[SFPAreaObject alloc] init];
//            cityArea.code = [(NSNumber *)city[@"area_code"] stringValue];
//            cityArea.oldCode = city[@"old_id"];
//            cityArea.name = city[@"name"];
//            NSArray *districts = city[@"children"];
//            __block NSString *smallestDistrictID = @"999999";
//            [districts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                // 区信息
//                NSDictionary *district = obj;
//                SFPAreaObject *districtArea = [[SFPAreaObject alloc] init];
//                districtArea.code = [(NSNumber *)district[@"area_code"] stringValue];
//                districtArea.oldCode = district[@"old_id"];
//                districtArea.name = district[@"name"];
//                if (districtArea.code.intValue < smallestDistrictID.intValue) {
//                    smallestDistrictID = [districtArea.code copy];
//                }
//                [cityArea addChildArea:districtArea];
//            }];
//            cityArea.defaultChildAreaCode = smallestDistrictID;
//            [provinceArea addChildArea:cityArea];
//        }];
//        [chinaArea addChildArea:provinceArea];
//    }];
//    // 存储到文件系统中
//    [self archiveAreaList:chinaArea];
//    return chinaArea;
//}

//+ (SFPAreaObject *)storeAreaInfoFromPlist
//{
//    NSArray *areaListBeforeParse = [WKFileUtil arrayFromConfig:@"city.plist"];
//    return [self storeAreaList:areaListBeforeParse];
//}
//
//+ (SFPAreaObject *)chinaArea
//{
//    return [self unarchiveAreaList];
//}
//
//+ (NSArray *)cityListInAll
//{
//    SFPAreaObject *chinaArea = [self unarchiveAreaList];
//    NSMutableArray *cityList = [NSMutableArray arrayWithCapacity:3];
//    NSDictionary *provinceList = chinaArea.childAreas;
//    [provinceList enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        SFPAreaObject *provinceArea = obj;
//        [provinceArea.childAreas enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//            [cityList addObject:obj];
//        }];
//    }];
//    return cityList;
//}
//
//+ (NSArray *)cityListInProvince:(NSUInteger)provinceID
//{
//    SFPAreaObject *chinaArea = [self unarchiveAreaList];
//    SFPAreaObject *provinceArea = [chinaArea areaByCode:[NSString stringWithFormat:@"%lu", (unsigned long)provinceID]];
//    NSMutableArray *cityList = [NSMutableArray arrayWithCapacity:3];
//    [provinceArea.childAreas enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        [cityList addObject:obj];
//    }];
//    return cityList;
//}

//+ (SFPAreaObject *)cityByID:(NSUInteger)cityID
//{
//    SFPAreaObject *chinaArea = [self unarchiveAreaList];
//    NSString *cityCode = [NSString stringWithFormat:@"%lu", (unsigned long)cityID];
//    NSString *provinceCode = [NSString stringWithFormat:@"%@0000", [cityCode substringWithRange:NSMakeRange(0, 2)]];
//    SFPAreaObject *provinceArea = [chinaArea areaByCode:provinceCode];
//    SFPAreaObject *cityArea = [provinceArea areaByCode:cityCode];
//    return cityArea;
//}

//+ (NSString *)cityNameByID:(NSUInteger)cityID
//{
//    if (cityID == 0) {
//        return @"";
//    }
//    SFPAreaObject *cityArea = [self cityByID:cityID];
//    return cityArea.name;
//}
//
//+ (NSArray *)districtListInCity:(NSUInteger)cityID
//{
//    SFPAreaObject *chinaArea = [self unarchiveAreaList];
//    NSString *cityCode = [NSString stringWithFormat:@"%lu", (unsigned long)cityID];
//    NSString *provinceCode = [NSString stringWithFormat:@"%@0000", [cityCode substringWithRange:NSMakeRange(0, 2)]];
//    SFPAreaObject *provinceArea = [chinaArea areaByCode:provinceCode];
//    SFPAreaObject *cityArea = [provinceArea areaByCode:cityCode];
//    NSMutableArray *districtList = [NSMutableArray arrayWithCapacity:3];
//    [cityArea.childAreas enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        [districtList addObject:obj];
//    }];
//    return districtList;
//}
//
//+ (NSString *)districtNameByID:(NSUInteger)districtID
//{
//    if (districtID == 0) {
//        return @"";
//    }
//    SFPAreaObject *chinaArea = [self unarchiveAreaList];
//    NSString *districtCode = [NSString stringWithFormat:@"%lu", (unsigned long)districtID];
//    NSString *cityCode = [NSString stringWithFormat:@"%@00", [districtCode substringWithRange:NSMakeRange(0, 4)]];
//    NSString *provinceCode = [NSString stringWithFormat:@"%@0000", [districtCode substringWithRange:NSMakeRange(0, 2)]];
//    SFPAreaObject *provinceArea = [chinaArea areaByCode:provinceCode];
//    SFPAreaObject *cityArea = [provinceArea areaByCode:cityCode];
//    SFPAreaObject *districtArea = [cityArea areaByCode:districtCode];
//    return districtArea.name;
//}

+ (void)changeTheNavgationStyle:(UIViewController *)controller titleColor:(UIColor*)color barTintColor:(UIColor*)tinColor
{
    
    UIFont *font;
    font = [UIFont fontWithName:@"AdobeHeitiStd-Regular" size:18.0];//字体 HYXiZhongYuanJ 、huxiaobo-meixin
    
    NSDictionary* textAttributes = @{NSFontAttributeName:font,
                                     NSForegroundColorAttributeName:color};
    controller.navigationController.navigationBar.titleTextAttributes = textAttributes;
    controller.navigationController.navigationBar.barTintColor = tinColor;
    controller.navigationController.navigationBar.translucent = NO;//TODO:要注意全透明的情况
}

+(float)adjustWidths:(UIFont*)font content:(NSString*)content
{
    CGSize constraintSize = CGSizeMake(3000, 3000);
    CGRect textRect = [content boundingRectWithSize:constraintSize
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:font}
                                                    context:nil];
    return  textRect.size.width;
}

@end
