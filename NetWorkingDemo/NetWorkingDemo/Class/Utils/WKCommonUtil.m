//
//  WKCommonUtil.m
//  WK
//
//  Created by Wei, Chengjiong on 9/5/12.
//  Copyright (c) 2012 Wei, Chengjiong. All rights reserved.
//

#import "WKCommonUtil.h"
#import "Reachability.h"


#define IS_IPHONE5_SCREEN   (fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)568)<DBL_EPSILON)
#define IS_IPHONE           (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPOD             (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE6_SCREEN   (fabs((double)[[UIScreen mainScreen] bounds].size.width-(double)375)<DBL_EPSILON)
#define IS_IPHONE6P_SCREEN   (fabs((double)[[UIScreen mainScreen] bounds].size.width-(double)414)<DBL_EPSILON)

@implementation WKCommonUtil

#pragma mark - Network Related

+ (BOOL)checkReachabilityWithMessage
{
	Reachability *reachability = [Reachability reachabilityForInternetConnection];
	NetworkStatus status = [reachability currentReachabilityStatus];
	if (status == NotReachable) {
		return NO;
	}
	return YES;
}

+ (WKNetWorkType)checkNetworkType
{
    return [self networkTypeFromStatusBar];
}

+ (BOOL)isInWifiNetwork
{
    return WKNetWorkTypeWifi == [self networkTypeFromStatusBar];
}

+ (BOOL)hasNetwork
{
    return WKNetWorkTypeNone != [self networkTypeFromStatusBar];
}

+ (WKNetWorkType)networkTypeFromStatusBar
{
    UIApplication *application = [UIApplication sharedApplication];
    NSArray *subviews = [[[application valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    __block UIView *dataNetworkItemView = nil;
    [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = obj;
            *stop = YES;
        }
    }];
    
    WKNetWorkType netType = WKNetWorkTypeNone;
    NSNumber *num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    if (num != nil) {
        int number = [num intValue];
        if (number == 0) {
            netType = WKNetWorkTypeNone;
        } else if (number == 1) {
            netType = WKNetWorkType2G;
        } else if (number == 2) {
            netType = WKNetWorkType3G;
        } else {
            netType = WKNetWorkTypeWifi;
        }
    }
    return netType;
}

#pragma mark - OS Related

+ (float)osVersion
{
    static float _osVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    return _osVersion;
}

+ (BOOL)isAboveOS5
{
	return [self osVersion] >= 5.0;
}

+ (BOOL)isAboveOS7
{
    return [self osVersion] >= 7.0;
}

+ (BOOL)isAboveOS8
{
    return [self osVersion] >= 8.0;
}

#pragma mark - Device Related

+ (BOOL)is4InchScreen
{
    return IS_IPHONE && IS_IPHONE5_SCREEN;
}

+ (BOOL)isIphone6screen
{
    return IS_IPHONE && IS_IPHONE6_SCREEN;
}

+ (BOOL)isIphone6Pscreen
{
    return IS_IPHONE && IS_IPHONE6P_SCREEN;
}

+ (BOOL)is2XRetina
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]
        && [[UIScreen mainScreen] scale] == 2.0) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)is3XRetina
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]
        && [[UIScreen mainScreen] scale] == 3.0) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Persistent Value

+ (BOOL)isFirstRound4Identifier:(NSString *)identifier
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isFirstRound = ![defaults boolForKey:identifier];
    return isFirstRound;
}

+ (void)markFirstRound4Identifier:(NSString *)identifier
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:identifier];
    [defaults synchronize];
}

#pragma mark - Device UUID

+ (NSString *)uuid
{
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidStringRef = CFUUIDCreateString(nil, puuid);
    NSString *uuidString = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidStringRef));
    CFRelease(puuid);
    CFRelease(uuidStringRef);
    NSDate *date = [NSDate date];
    return [NSString stringWithFormat:@"%@_%llu", uuidString, (unsigned long long)[date timeIntervalSince1970]];
}

+ (NSString *)appBundleVersion
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return version;
}

#pragma mark - Others

+ (NSString *)currentLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    return currentLang;
}

+ (BOOL)isMainThread
{
    return [NSThread isMainThread];
}

@end
