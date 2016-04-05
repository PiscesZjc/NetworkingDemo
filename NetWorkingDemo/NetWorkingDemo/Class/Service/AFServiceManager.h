//
//  AFServiceManager.h
//  NetWorkingDemo
//
//  Created by zjc on 16/3/2.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFServiceProtocol.h"

typedef enum {
    AFServiceResultCodeSucceed = 0,
    AFServiceResultCodeNeedLogin = 1101,
    AFServiceResultCodeNoAuth = 1102,
    AFServiceResultCodeHitCache = -9999,
    AFServiceResultCodeServiceError = -10000,
    AFServiceResultCodeBrokenJson = -10001,
    AFServiceResultCodeInvalidResponseFormat = -10002,
    AFServiceResultCodeSaveCacheError = -10003,
} AFServiceResultCode;

@interface AFServiceManager : NSObject


+ (instancetype)sharedInstance;

- (AFServiceConfig *)launch:(id<AFServiceProtocol>)service;
- (void)launch:(id<AFServiceProtocol>)service config:(AFServiceConfig*)config;
//取消该service实体发出的所有请求
- (void)cancel:(id<AFServiceProtocol>)service;
//取消该config对应的一个请求
- (void)cancel:(id<AFServiceProtocol>)service config:(AFServiceConfig*)config;

@end
