//
//  AFBaseService.m
//  NetWorkingDemo
//
//  Created by zjc on 16/3/2.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import "AFBaseService.h"
#import "AFServiceManager.h"

#define ServiceManager ([AFServiceManager sharedInstance])

@implementation AFBaseService
@synthesize config = _config;

#pragma mark - Life Cycle

- (id)initWithDelegate:(id<AFBaseServiceDelegate>)delegate
{
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}


- (AFServiceConfig*)defaultServiceConfig
{
    AFServiceConfig *config =[AFServiceConfig config];
    config.httpMethod = AFHttpGet;
    config.requestFormatJSON = NO;
    config.forceLoad = NO;
    config.saveCache = YES;
    config.isModel = YES;
    config.server = AppContext.serverAddress;
    config.params[@"app_version"] = [WKCommonUtil appBundleVersion];
    config.canceled = NO;
    return config;
}

#pragma mark - service Trigger Method

- (void)load:(AFServiceConfig *)config
{
    _config = config;
     [ServiceManager launch:self config:config];
}

- (void)cancelAllRequestsAndRemoveDelegate
{
    _delegate = nil;
    [ServiceManager cancel:self];
    
}
- (void)cancelRequestAndRemoveDelegate:(AFServiceConfig *)config{
    _delegate = nil;
    [ServiceManager cancel:self config:config];
}

- (NSString*)generateServiceKey:(id<AFServiceProtocol>)service
{
    NSString *key  = [NSString stringWithFormat:@"%@_%p",NSStringFromClass(service.class),service];
    return key;
}


#pragma mark - Service Protocol Methods

- (BOOL)service:(AFServiceConfig *)config isResponseValid:(AFServiceResponse *)response
{
    NSDictionary *responseJson = response.object;
    
    id resultObject = responseJson[@"result"];
    if (!resultObject || ![resultObject isKindOfClass:NSDictionary.class]) {
        AFServiceResult *result = [AFServiceResult resultWithCode:AFServiceResultCodeInvalidResponseFormat message:@"Wrong result format!" info:nil];
        response.object = nil;
        response.result = result;
        return NO;
    }
    int resultCode = [resultObject[@"code"] intValue];
    NSString *resultMessage  = resultObject[@"message"];
    AFServiceResult *result = [AFServiceResult resultWithCode:resultCode message:resultMessage info:nil];
    if (resultCode != AFServiceResultCodeSucceed) {
        // 这里我们直接使用WKServiceManager预定义好的code对应未登录和没有权限这两个错误，所以在service:failure:回调中也要用这两个code来处理
        response.object = nil;
        response.result = result;
    }
    return YES;
}

- (id)service:(AFServiceConfig *)config parse:(AFServiceResponse *)response inContext:(NSManagedObjectContext *)context
{
    NSDictionary *responseJson = response.object;
    //result
    NSDictionary *resultObject = responseJson[@"result"];
    int resultCode = [resultObject[@"code"] intValue];
    NSString *resultMessage = resultObject[@"message"];
    AFServiceResult *result = [AFServiceResult resultWithCode:resultCode message:resultMessage info:nil];
    response.result = result;
    
    //parse main json
    id responseObject = responseJson[@"response"];
    id parseObject = [self onParse:responseObject config:config inContext:context];
    return parseObject;
    
}

- (void)service:(AFServiceConfig *)config success:(AFServiceResponse *)response
{
    if ([_delegate respondsToSelector:@selector(service:didLoadResponse:)]) {
        [_delegate service:self didLoadResponse:response];
    }
    [self logServiceInfo:YES response:response];
}

- (void)service:(AFServiceConfig *)config failure:(AFServiceResponse *)response{
    NSInteger resultCode = response.result.code;
    //提示用户需要登录
    DDLogWarn(@"[Auth Error] User needs login!");
    [notifyCenter postNotificationName:notificationServerNeedLogin object:nil];
    if ([_delegate respondsToSelector:@selector(service:needLogin:)]) {
        [_delegate service:self needLogin:response.result];
    }else if (resultCode == AFServiceResultCodeNoAuth){
        //提示用户没有访问
        DDLogWarn(@"[Auth Error] User needs authorization!");
        if ([_delegate respondsToSelector:@selector(service:needAuth:)]) {
            [_delegate service:self needAuth:response.result];
        }
    }else{
        if ([_delegate respondsToSelector:@selector(service:failLoadResponse:)]) {
            [_delegate service:self failLoadResponse:response.result];
        }
    }
    [self logServiceInfo:NO response:response];
}

- (void)serviceWillLoadFromServer:(AFServiceConfig *)config
{
    if ([self.delegate respondsToSelector:@selector(serviceWillLoadFromServer:)]) {
        [self.delegate serviceWillLoadFromServer:self];
    }
}

- (void)serviceDidLoadFromServer:(AFServiceConfig *)config{
    if ([self.delegate respondsToSelector:@selector(serviceDidLoadFromServer:)]) {
        [self.delegate serviceDidLoadFromServer:self];
    }
}


#pragma mark - Sub-class Method: can overWritten
- (id)onParse:(id)response config:(AFServiceConfig *)config inContext:(NSManagedObjectContext *)context
{
    return [response isKindOfClass:NSDictionary.class]? response:nil;
}


#pragma mark - Service Log Method
- (void)logServiceInfo:(BOOL)succeed response:(AFServiceResponse*)response
{
    //打印网络日志
    NSString *httpMethod = nil;
    if (response.fromCache) {
        httpMethod = @"CACHE";
    }else{
        switch (response.config.httpMethod) {
            case AFHttpGet:
            {
                httpMethod = @"GET";
            }
                break;
                
            case AFHttpPost:
            {
                httpMethod = @"POST";
            }
                break;
            case AFHttpPut:
            {
                httpMethod = @"AFHttpPut";
            }
                break;
            case AFHttpDelete:
            {
                httpMethod = @"AFHttpDelete";
            }
                break;
            case AFHttpPatch:
            {
                httpMethod = @"PATCH";
            }
                break;
            case AFHttpMultiPartPost:
            {
                httpMethod = @"MultiPart POST";
            }
                break;
            default:
                
            {
                httpMethod = @"UNKNOWN";
            }
                
                break;
        }
    }
    DDLogVerbose(@"[%@][%@]: %@", succeed?@"succeed":@"fail", httpMethod, response.config.fullUrl);
}
@end
