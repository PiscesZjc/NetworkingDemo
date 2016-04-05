//
//  WKCommonMacro.h
//
//  Created by WeiChengjiong on 13-12-4.
//  Copyright (c) 2013年 Wei, Chengjiong. All rights reserved.
//

//#import <CoreTelephony/CTTelephonyNetworkInfo.h>
//#import <CoreTelephony/CTCarrier.h>

//常用的IOS开发宏

#pragma mark - 界面 部分

// 屏幕
#define NavigationBar_HEIGHT 44
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
// 设置颜色
#define rgbaColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define rgbColor(r,g,b) rgbaColor(r,g,b,1.0)
// RGB颜色转换（16进制->10进制）
#define hexaColor(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]
#define hexColor(rgbValue) hexaColor(rgbValue,1.0)


#pragma mark - 系统 部分

// 当前设备的系统版本
#define iOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])
#define isAboveIOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define isAboveIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define isAboveIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define isAboveIOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
// 当前的设备的默认语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
// 是否是iPad
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


#pragma mark - Block

#define BackgroundThread(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MainThread(block) dispatch_async(dispatch_get_main_queue(),block)


#pragma mark - File Path

#define kHomePath        NSHomeDirectory()
#define kCachePath      [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"]
#define kDocumentFolder [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kDocumentFolder2 [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define kLibraryPath [NSHomeDirectory() stringByAppendingPathComponent:@"Library"]
#define kTempPath    NSTemporaryDirectory()
#define kMainBoundPath [[NSBundle mainBundle] bundlePath]
#define kResourcePath  [[NSBundle mainBundle] resourcePath]
#define kExecutablePath [[NSBundle mainBundle] executablePath]


#pragma mark - Setting

//// 当前系统设置国家的country iso code
//#define countryISO  [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]
//// 当前系统设置语言的iso code
//#define languageISO [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]
//
//static NSString *(^CountryNameByISO)(NSString *) = ^(NSString *iso) {
//    NSLocale *locale = [NSLocale currentLocale];
//    return [locale displayNameForKey:NSLocaleCountryCode value:iso];
//};
//
//static NSString *(^ISOCountryCodeByCarrier)() = ^() {
//    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
//    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
//    return [carrier isoCountryCode];
//};
//
//#define SimISO                  ISOCountryCodeByCarrier()
//#define CountryNameFromISO(iso) CountryNameByISO(iso)


#pragma mark - 单例

#define DeclareSingletonInterface(className)  \
+ (classname *)shared##classname

#define ImplementSingletonInterface(className) \
+ (classname *)shared##classname { \
static dispatch_once_t onceToken = 0; \
static id sharedInstance = nil; \
dispatch_once(&onceToken, ^{ \
sharedInstance = [[self alloc] init]; \
}); \
return sharedInstance; \
}


#pragma mark - 功能部分


//针对真机iPhone
#if TARGET_OS_IPHONE
//iPhone Device
#endif

//针对模拟器
#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//ARC
#if __has_feature(objc_arc)
//compiling with ARC
#define SAFE_RELEASE(x) x = nil
#else
// compiling without ARC
#define SAFE_RELEASE(x) [x release];x=nil
#endif


#define weakSelfDefinition (__weak __typeof(&*self) weakSelf = self)
#define empty4NilString(str) ((str!=nil)?str:@"")

