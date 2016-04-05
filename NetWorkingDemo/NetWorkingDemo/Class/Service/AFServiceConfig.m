//
//  AFServiceConfig.m
//  NetWorkingDemo
//
//  Created by zjc on 16/3/2.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import "AFServiceConfig.h"

// 单位是秒
#define DEFAULT_REQUEST_TIME_OUT 60
#define DEFAULT_CACHE_EXPIRE_INTERVAL 300
#define DEFAULT_CACHE_EXPIRE_NEVER -1

@interface AFServiceConfig ()
{
    NSString *_fullURL;
}

@end

@implementation AFServiceConfig

#pragma mark - Life Cycle

- (id)init
{
    self = [super init];
    if (self) {
        _server = nil;
        _service = nil;
        _params = [NSMutableDictionary dictionaryWithCapacity:0];
        _forceLoad = YES;
        _saveCache = NO;
        _isModel = NO;
        _isPaging = NO;
        _httpMethod = AFHttpGet;
        _requestFormatJSON = NO;
        _cacheExpireInterval = DEFAULT_CACHE_EXPIRE_INTERVAL;
        _httpTimeOut = DEFAULT_REQUEST_TIME_OUT;
        _userInfo = nil;
        _fullURL = nil;
        
    }
    return self;
}

+ (AFServiceConfig*)config
{
    AFServiceConfig  *config = [[AFServiceConfig alloc] init];
    return config;
}

#pragma mark - Convenient Method

- (NSString *)cacheKey
{
    if (!_saveCache) {
        return nil;
    }
    return self.fullUrl;
}

- (NSString *)url
{
    return [NSString stringWithFormat:@"%@%@", _server, _service];
}

- (NSString *)fullUrl
{
    if (_fullURL) {
        return _fullURL;
    }
    if (!_params || _params.count == 0) {
        _fullURL = self.url;
        return _fullURL;
    }
    NSMutableString *urlPath = [NSMutableString stringWithFormat:@"%@?",self.url];
    NSMutableArray *sortedParamKeys = [NSMutableArray arrayWithArray:_params.allKeys];
    [sortedParamKeys sortedArrayUsingSelector:@selector(compare:)];
    [sortedParamKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *key = obj;
        id valueObj = _params[key];
        NSString *value = nil;
        if ([valueObj isKindOfClass:[NSString class]]) {
            value = valueObj;
        }else if ([valueObj isKindOfClass:[NSNumber class]]){
            value = [(NSNumber*)valueObj stringValue];
        }else{
            value = @"";
        }
        [urlPath appendFormat:@"@%@=%@",key,value];
    }];
    _fullURL = urlPath;
    return _fullURL;
}

- (BOOL)isEqual:(AFServiceConfig *)config
{
    return [self.serviceKey isEqualToString:config.serviceKey] && [self.requestKey isEqualToString:config.requestKey];
}

- (id)copyWithZone:(NSZone *)zone
{
    AFServiceConfig *copy = [[AFServiceConfig alloc] init];
    if (copy) {
        copy.server = self.server;
        copy.service = self.service;
        copy.params = [self.params copyWithZone:zone];
        copy.forceLoad = self.forceLoad;
        copy.saveCache = self.saveCache;
        copy.httpMethod = self.httpMethod;
        copy.requestFormatJSON = self.requestFormatJSON;
        copy.cacheExpireInterval = self.cacheExpireInterval;
        copy.httpTimeOut = self.httpTimeOut;
        copy.userInfo = self.userInfo;
        copy.canceled = self.canceled;
        copy.serviceKey = self.serviceKey;
        copy.requestKey = self.requestKey;
        copy.isModel = self.isModel;
        copy.isPaging = self.isPaging;
    }
    return copy;
}


@end
