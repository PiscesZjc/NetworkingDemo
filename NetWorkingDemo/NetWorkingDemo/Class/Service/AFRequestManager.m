//
//  AFRequestManager.m
//  NetWorkingDemo
//
//  Created by zjc on 16/3/4.
//  Copyright © 2016年 zjc. All rights reserved.
//


#import "AFRequestManager.h"


#define kDefaultCachePolicy NSURLRequestReloadIgnoringCacheData
#define kDefaultRequestTimeoutInterval 60


@implementation AFRequestManager

#pragma mark - Public Method

+ (instancetype)sharedInstance
{
    static AFRequestManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self manager];
    });
    return manager;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        self.cachePolicy = kDefaultCachePolicy;
        self.timeoutInterval = kDefaultRequestTimeoutInterval;
    }
    return self;
}

- (void)resetCachePolicy
{
    _cachePolicy = kDefaultCachePolicy;
}

- (void)resetTimeoutInterval
{
    _timeoutInterval = kDefaultRequestTimeoutInterval;
}

#pragma mark - Overwirtten Method

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                               uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                             downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                            completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler
{
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    mutableRequest.cachePolicy = _cachePolicy;
    mutableRequest.timeoutInterval = _timeoutInterval;
    NSURLSessionDataTask *task = [super dataTaskWithRequest:mutableRequest uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock completionHandler:completionHandler];
    return task;
}
@end
