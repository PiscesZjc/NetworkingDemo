//
//  AFServiceConfig.h
//  NetWorkingDemo
//
//  Created by zjc on 16/3/2.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AFHttpGet = 0,
    AFHttpPost,
    AFHttpMultiPartPost,
    AFHttpPut,
    AFHttpDelete,
    AFHttpHead,
    AFHttpPatch,
} AFHttpMethod;

@interface AFServiceConfig : NSObject

//服务器地址 请求方法 以及参数
@property (nonatomic,copy) NSString *server;
@property (nonatomic,copy) NSString *service;
@property (nonatomic) NSMutableDictionary *params;
@property (nonatomic) AFHttpMethod httpMethod;
@property (nonatomic) BOOL requestFormatJSON;
@property (nonatomic) NSTimeInterval httpTimeOut;

@property (nonatomic) BOOL forceLoad; //是否强制从服务器下载，默认为YES；
@property (nonatomic) BOOL saveCache; //是否将返回结果存入缓存，默认No;
@property (nonatomic) NSTimeInterval cacheExpireInterval; //缓存有效时间

@property (nonatomic) BOOL isModel; //返回的数据是否封装成CoreData对象，默认NO
@property (nonatomic) BOOL isPaging; //是否分页，默认NO;

@property (nonatomic,strong)id userInfo;
@property (nonatomic) BOOL canceled;

//convenient method
@property (nonatomic,readonly) NSString *url;
@property (nonatomic,readonly) NSString *fullUrl;
@property (nonatomic,readonly) NSString *cacheKey;

// service identify
// can be used by the out world to identify service, it won't be used in service manager
@property (nonatomic) NSUInteger serviceType;
// used by service manager, can't be used by the out world
@property (nonatomic, copy) NSString *serviceKey;
@property (nonatomic, copy) NSString *requestKey;


+(AFServiceConfig *)config;

- (BOOL)isEqual:(AFServiceConfig *)config;
@end
