//
//  WKCommonUtil.h
//  WK
//
//  Created by Wei, Chengjiong on 9/5/12.
//  Copyright (c) 2012 Wei, Chengjiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <float.h>


typedef enum {
    WKNetWorkTypeNone = 0,
    WKNetWorkTypeWifi,
    WKNetWorkType3G,
    WKNetWorkType2G,
} WKNetWorkType;


@interface WKCommonUtil : NSObject

+ (BOOL)checkReachabilityWithMessage;
+ (WKNetWorkType)checkNetworkType;
+ (BOOL)isInWifiNetwork;
+ (BOOL)hasNetwork;

+ (float)osVersion;
+ (BOOL)isAboveOS5;
+ (BOOL)isAboveOS7;
+ (BOOL)isAboveOS8;
+ (BOOL)is4InchScreen;
+ (BOOL)isIphone6screen;
+ (BOOL)isIphone6Pscreen;
+ (BOOL)is2XRetina;
+ (BOOL)is3XRetina;

+ (BOOL)isFirstRound4Identifier:(NSString *)identifier;
+ (void)markFirstRound4Identifier:(NSString *)identifier;

+ (NSString *)uuid;
+ (NSString *)appBundleVersion;

/*
 * 判断手机当前语言
 */
+ (NSString *)currentLanguage;

+ (BOOL)isMainThread;

@end
