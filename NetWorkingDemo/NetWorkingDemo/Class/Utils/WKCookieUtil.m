//
//  WKCookieUtil.m
//
//  Created by Wei, Chengjiong on 13-11-10.
//  Copyright (c) 2013年 Wei, Chengjiong. All rights reserved.
//

#import "WKCookieUtil.h"

@implementation WKCookieUtil

+ (NSDictionary *)allKeyValuePairCookies
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableDictionary *cookies = [NSMutableDictionary dictionaryWithCapacity:cookieJar.cookies.count];
    for (NSHTTPCookie *cookie in cookieJar.cookies) {
        [cookies setObject:cookie.value forKey:cookie.name];
    }
    return cookies;
}

+ (NSArray *)allCookies
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    return cookieJar.cookies;
}

+ (BOOL)isCookieExisted:(NSString *)cookieName
{
    __block BOOL cookieExisted = NO;
    NSArray *cookies = [self allCookies];
    [cookies enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSHTTPCookie *cookie = obj;
        if ([cookie.name isEqualToString:cookieName]) {
            cookieExisted = YES;
            *stop = YES;
        }
    }];
    return cookieExisted;
}

+ (NSHTTPCookie *)cookieByName:(NSString *)cookieName
{
    __block NSHTTPCookie *namedCookie = nil;
    NSArray *cookies = [self allCookies];
    [cookies enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSHTTPCookie *cookie = obj;
        if ([cookie.name isEqualToString:cookieName]) {
            namedCookie = cookie;
            *stop = YES;
        }
    }];
    return namedCookie;
}

+ (void)removeCookieByName:(NSString *)cookieName
{
    NSHTTPCookie *cookie = [self cookieByName:cookieName];
    if (cookie) {
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [cookieJar deleteCookie:cookie];
    }
}

+ (void)clearCookies
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieJar.cookies enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [cookieJar deleteCookie:obj];
    }];
}

@end
