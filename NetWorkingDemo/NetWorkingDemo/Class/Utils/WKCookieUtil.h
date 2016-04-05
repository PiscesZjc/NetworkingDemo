//
//  WKCookieUtil.h
//
//  Created by Wei, Chengjiong on 13-11-10.
//  Copyright (c) 2013年 Wei, Chengjiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKCookieUtil : NSObject

+ (NSDictionary *)allKeyValuePairCookies;
+ (NSArray *)allCookies;
+ (BOOL)isCookieExisted:(NSString *)cookieName;
+ (NSHTTPCookie *)cookieByName:(NSString *)cookieName;
+ (void)removeCookieByName:(NSString *)cookieName;
+ (void)clearCookies;

@end
