//
//  LEJAppUtil.h
//  SunFlowerProvider
//
//  Created by WeiChengjiong on 7/12/14.
//  Copyright (c) 2014 9Top. All rights reserved.
//

#import <Foundation/Foundation.h>


// Convenient Object
#define AppDelegate ([[UIApplication sharedApplication] delegate])
#define AppContext ((NWDContext *)[NWDContext sharedInstance])
#define RequestManager ([WKRequestManager sharedManager])
#define AppCache ([AFCacheManage sharedInstance])
#define AppUser ([NADUserInfo currentUserInfo])
#define notifyCenter ([NSNotificationCenter defaultCenter])

// Constant identify
#define kFirstTimeOpenApp @"kFirstTimeOpenApp"

// Global font and color
#define kGlobalTextColor [UIColor colorWithRed:143/255.0 green:217/255.0 blue:255/255.0 alpha:1]
#define kGlobalFontName @"DFPLiHei-Md"
#define fGlobalFontWithSize(s) [UIFont fontWithName:kGlobalFontName size:s]


@interface LEJAppUtil : NSObject

///*
// * 资源文件CDN前缀处理
// */
//+ (NSString *)fulfillResourceUrl:(NSString *)url;
//
///*
// *图片链接根据尺寸拼接URL
// */
//+ (NSString *)spliceSouurceUrlBySize:(CGSize)size url:(NSString *)url;

/*
 * 显示一个Alert
 */
+ (void)showAlertMessage:(NSString *)message;
+ (void)showAlertMessage:(NSString *)message delegate:(id)delegate;

/*
 * 是否全是数字
 */
+ (BOOL)validateNumber:(NSString *)number;

/*
 判断邮箱是否正确
 */
+ (BOOL)isValidateEmail:(NSString *)Email;

/*
 * 返回拉伸的图片
 * 拉伸参数：
 */
+ (UIImage *)resizableImageByName:(NSString *)name;
+ (UIImage *)resizableImageByName:(NSString *)name capInsets:(UIEdgeInsets)capInsets;

/*
 * 全局的Date Formatter
 * 默认的时间格式是：yyyy-MM-dd HH:mm:ss
 */
+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format;
+ (NSDateFormatter *)serverDateFormatter;

/*
 * 时间间隔的显示
 */
+ (NSString *)formattedPublishTimeToNow:(NSDate *)fromDate;
+ (NSString *)formattedDeadlineTimeFromNow:(NSDate *)fromDate;
+ (void)setFormattedPublishTimeToNow:(NSDate *)fromDate withBlockAsync:(void(^)(NSString *, NSDictionary *))block;
+ (void)setFormattedPublishTimeToNow:(NSDate *)fromDate withBlockAsync:(void(^)(NSString *, NSDictionary *))block userInfo:(NSDictionary *)userInfo;
+ (void)setFormattedDeadlineTimeFromNow:(NSDate *)fromDate withBlockAsync:(void(^)(NSString *))block;
+ (NSDateFormatter *)dateFormatter4;
+ (NSDateFormatter *)dateFormatter3;
+ (NSDateFormatter *)dateFormatter5;
+ (NSDateFormatter *)dateFormatter6;
+ (NSDateFormatter *)dateFormatter7;
+ (NSDateComponents*)getYearDay:(NSDate*)date;////获取当前时间的年月日时分秒
//获取星期几
+ (NSDateComponents*)getWeekDay:(NSDate*)dateTime;

/*
 存储图片到本地
 */
+ (void)setImage:(UIImage *)image forURL:(NSString *)URL;
/**
 从本地取图片
 */
+ (UIImage *)getImageForURL:(NSString *)URL;

/**
 通过完整路径删除本地文件
 */
+ (void)removeLocalFile:(NSString *)URL;

/*
 * 解析、返回省份，城市和行政区划信息
 */
//+ (SFPAreaObject *)storeAreaList:(NSArray *)areaListBeforeParse;
//+ (SFPAreaObject *)storeAreaInfoFromPlist;
//+ (SFPAreaObject *)chinaArea;
+ (NSArray *)cityListInAll;
+ (NSArray *)cityListInProvince:(NSUInteger)provinceID;
//+ (SFPAreaObject *)cityByID:(NSUInteger)cityID;
+ (NSString *)cityNameByID:(NSUInteger)cityID;
+ (NSArray *)districtListInCity:(NSUInteger)cityID;
+ (NSString *)districtNameByID:(NSUInteger)districtID;
+ (void)changeTheNavgationStyle:(UIViewController *)controller
                     titleColor:(UIColor*)color
                   barTintColor:(UIColor*)tinColor;

/*
 *通过字体和内容计算label的宽度
 */
+(float)adjustWidths:(UIFont*)font content:(NSString*)content;
@end
