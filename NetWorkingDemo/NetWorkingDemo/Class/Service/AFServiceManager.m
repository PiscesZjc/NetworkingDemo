//
//  AFServiceManager.m
//  NetWorkingDemo
//
//  Created by zjc on 16/3/2.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import "AFServiceManager.h"
#import "AFRequestManager.h"

#define CacheManager ([AFCacheManage sharedInstance])

/*----- Store Service Info -----*/
@interface AFServiceInfo : NSObject
@property (nonatomic) AFServiceConfig *config;
@property (nonatomic,weak) id<AFServiceProtocol>service;
@end

@implementation AFServiceInfo


@end

@interface AFServiceManager()
{
    NSMutableDictionary *_serviceInfos;
    NSMutableDictionary *_classNameCounts;
}

@end

@implementation AFServiceManager

- (id)init
{
    self = [super init];
    if (self) {
        _serviceInfos = [NSMutableDictionary dictionaryWithCapacity:20];
        _classNameCounts = [NSMutableDictionary dictionaryWithCapacity:20];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static AFServiceManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AFServiceManager alloc] init];
    });
    return sharedInstance;
}

- (AFServiceConfig *)launch:(id<AFServiceProtocol>)service
{
    if (![service respondsToSelector:@selector(serviceConfig)]) {
        return nil;
    }
    AFServiceConfig *config = [service serviceConfig];
    [self launch:service config:config];
    return config;
}

- (void)launch:(id<AFServiceProtocol>)service config:(AFServiceConfig*)config
{
    //    check if config is valid
    if (![self isServiceConfigValid:config ]) {
        return;
    }
    //store config and make a copy
    AFServiceConfig *configRun = [self storeServiceInfo:service config:config];
    
    static dispatch_queue_t queue;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        queue = dispatch_queue_create("com.hq51.app.request", NULL);
    });
    // // sequence run the threads
    dispatch_async(queue, ^{
        if (configRun.canceled) {
            return ;
        }
        if (!configRun.forceLoad && configRun.saveCache) {
            BOOL isCacheValid  = [ self checkCacheAndReturnIfPossible:configRun];
            if (!isCacheValid) {
                [self visitServer:configRun];
            }
        }else{
            [self visitServer:configRun];
        }
    });
    
}

- (void)cancel:(id<AFServiceProtocol>)service
{
    [self cancelRequestsByService:service];
    
}
- (void)cancel:(id<AFServiceProtocol>)service config:(AFServiceConfig *)config{
    [self cancelRequestInService:service byConfig:config];
}

- (void)cancelRequestsByService:(id<AFServiceProtocol>)service
{
    NSString *serviceKey = [self generateServiceKey:service];
    [_serviceInfos[serviceKey] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AFServiceInfo *serviceInfo = obj;
        serviceInfo.config.canceled = YES;
    }];
    [_serviceInfos removeObjectForKey:serviceKey];
}

- (void)cancelRequestInService:(id<AFServiceProtocol>)service byConfig:(AFServiceConfig *)config
{
    NSString *serviceKey = [self generateServiceKey:service];
    if (![serviceKey isEqualToString:config.serviceKey]) {
        DDLogWarn(@"[SERVICE WARNING] service and config don't match!");
        return;
    }
    AFServiceInfo *serviceInfo = _serviceInfos[config.serviceKey][config.requestKey];
    serviceInfo.config.canceled = YES;
    [self removeServiceWithConfig:config];
}

#pragma mark - Request Method

- (void)visitServer:(AFServiceConfig*)config
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self requestWillLoadFromServerReporter:config];
    });
    AFRequestManager *manager = [AFRequestManager manager];
    //config request parameters fromat
    if (config.requestFormatJSON) {
        manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    }
    //config response format
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // config cache policy to always discard cache
    manager.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    manager.timeoutInterval = config.httpTimeOut;
    
    //send request
    switch (config.httpMethod) {
        case AFHttpGet:
        {
            [manager GET:config.url parameters:config.params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                [self request:task didSuccess:responseObject withConfig:config];
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                
            }];
        }
            break;
            
        case AFHttpPost:
        {
            [manager POST:config.url parameters:config.params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                [self request:task didSuccess:responseObject withConfig:config];
            } failure:^(NSURLSessionDataTask * task, NSError *error) {
                [self request:task didFailure:error withConfig:config];
            }];
        }
            break;
            
        case AFHttpMultiPartPost:
        {
            [manager POST:config.url parameters:config.params constructingBodyWithBlock:^(id<AFMultipartFormData>formData) {
                id<AFServiceProtocol>service = [self retrieveServiceWithConfig:config];
                if ([service respondsToSelector:@selector(service:willSendMultipartFormData:)]) {
                    [service service:config willSendMultipartFormData:formData];
                }
            } progress:^(NSProgress *uploadProgress) {
                //进度无
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                [self request:task didSuccess:responseObject withConfig:config];
                
            } failure:^(NSURLSessionDataTask * task, NSError *error) {
                [self request:task didFailure:error withConfig:config];
            }];
            
        }
            break;
            
        case AFHttpPut:
        {
            [manager PUT:config.url parameters:config.params success:^(NSURLSessionDataTask *task, id responseObject) {
                [self request:task didSuccess:responseObject withConfig:config];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self request:task didFailure:error withConfig:config];
            }];
        }
            
            break;
        case AFHttpDelete:
        {
            [manager DELETE:config.url parameters:config.params success:^(NSURLSessionDataTask *task, id responseObject) {
                [self request:task didSuccess:responseObject withConfig:config];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self request:task didFailure:error withConfig:config];
            }];
        }
            break;
        case AFHttpPatch:
        {
            [manager PATCH:config.url parameters:config.params success:^(NSURLSessionDataTask *task, id responseObject) {
                [self request:task didSuccess:responseObject withConfig:config];
            } failure:^(NSURLSessionDataTask * task, NSError *error) {
                [self request:task didFailure:error withConfig:config];
            }];
        }
            break;
        case AFHttpHead:
        {
            [manager HEAD:config.url parameters:config.params success:^(NSURLSessionDataTask *task) {
                [self headRequest:task didSuccessWithConfig:config];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self request:task didFailure:error withConfig:config];
            }];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)headRequest:(NSURLSessionDataTask*)task didSuccessWithConfig:(AFServiceConfig*)config
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self requestDidLoadFromServerReporter:config];
        
    });
    if (config.canceled) {
        return;
    }
    AFServiceResult *result = [AFServiceResult resultWithCode:AFServiceResultCodeSucceed message:@"Head request succeed!" info:nil];
    AFServiceResponse *response = [AFServiceResponse responseWithObject:nil result:result config:config];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self requestSuccessReporter:response];
    });
    
    
}


- (void)request:(NSURLSessionDataTask*)task didSuccess:(id)serviceReponse withConfig:(AFServiceConfig*)config
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self requestDidLoadFromServerReporter:config];
    });
    if (config.canceled) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (config.canceled) {
            return;
        }
    });
    //check if json is broken
    NSError *jsonError = nil;
    NSDictionary *servicePesponseJson = [NSJSONSerialization JSONObjectWithData:serviceReponse options:kNilOptions error:&jsonError];
    if(jsonError){
        AFServiceResult *result = [AFServiceResult resultWithCode:AFServiceResultCodeBrokenJson message:@"Wrong Json Format" info:nil];
        AFServiceResponse *response = [AFServiceResponse responseWithObject:nil result:result config:config];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self requestFailureReporter:response];
        });
        return;
    }
    // check if json format is valid
    id<AFServiceProtocol>service = [self retrieveServiceWithConfig:config];
    AFServiceResponse *response = [AFServiceResponse responseWithObject:servicePesponseJson result:nil config:config];
    {
        if ([service respondsToSelector:@selector(service:isResponseValid:)]) {
            BOOL isResponseValid = [service service:config isResponseValid:response];
            // if response json doesn't meet requirements
            if (!isResponseValid) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self requestFailureReporter:response];
                });
                return;
            }
        }
    }
    // json is valid, so it's time to parse it
    if (config.saveCache || config.isModel) {
        __block id parsedObject = nil;
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            // invalid previous cache (only decrease cache count)
            NSString *key = config.cacheKey;
            [CacheManager removeObjectsForCacheKey:key inContext:localContext];
            // parse response data
            parsedObject = [service service:config parse:response inContext:localContext];
            //store data into cache - build cache reference
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:config.cacheExpireInterval];
            [CacheManager cacheObjects:parsedObject forKey:key expireDate:date inContext:localContext];
            
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            
            if (contextDidSave) {
                // we need to pass NSManagedObjectID object since NSManagedObject object is not thread safe
                id parsedObjectID  = [AFCacheManage coreDataObjectIDArrayFromObjects:parsedObject];
                //callback
                if (parsedObjectID) {
                    response.object = parsedObjectID;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // get NSManagedObject object by NSManagedObjectID
                        id objectIDs = response.object;
                        response.object = [AFCacheManage coreDataObjectsFromObjectIDs:objectIDs];
                        [self requestSuccessReporter:response];
                    });
                }else{
                    response.object = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self requestSuccessReporter:response];
                    });
                }
            }else{
                if (!error) {
                    // no save but also no error, so this is the case that the to-be-save objects have no change, then the managed context decides not to do save
                    // we need to pass NSManagedObjectID object since NSManagedObject object is not thread safe
                    id parsedObjectID = [AFCacheManage coreDataObjectIDArrayFromObjects:parsedObject];
                    //callback
                    if (parsedObjectID) {
                        response.object = parsedObjectID;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // get NSManagedObject object by NSManagedObjectID
                            id objectIDs = response.object;
                            response.object = [AFCacheManage coreDataObjectsFromObjectIDs:objectIDs];
                            [self requestSuccessReporter:response];
                        });
                    }else {
                        response.object = nil;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self requestSuccessReporter:response];
                        });
                    }
                }else{
                    DDLogError(@"[Cache] save error: %@", error);
                    AFServiceResult *result = [AFServiceResult resultWithCode:AFServiceResultCodeSaveCacheError message:@"[Cache] save error!" info:@{@"error": error}];
                    response.result = result;
                    response.object = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self requestFailureReporter:response];
                    });
                }
            }
        }];
        
    }else{
        //parse response data
        id parsedObject = [service service:config parse:response inContext:nil];
        // callback
        response.object = parsedObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self requestSuccessReporter:response];
        });
        
    }
}

- (void)request:(NSURLSessionTask*)task didFailure:(NSError *)error withConfig:(AFServiceConfig*)config
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self requestDidLoadFromServerReporter:config];
    });
    
    if (config.canceled) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (config.canceled) {
            return;
        }
        AFServiceResult *result = [AFServiceResult resultWithCode:AFServiceResultCodeServiceError message:@"Request runs incorrectly!" info:@{@"error":error}];
        AFServiceResponse *response = [AFServiceResponse responseWithObject:nil result:result config:config];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self requestFailureReporter:response];
        });
        
    });
    
}

#pragma mark - service Report Method
- (void)requestFailureReporter:(AFServiceResponse *)response
{
    AFServiceConfig *config = response.config;
    id<AFServiceProtocol> service = [self retrieveServiceWithConfig:config];
    [service service:config failure:response];
    [self removeServiceWithConfig:config];
}

- (void)requestSuccessReporter:(AFServiceResponse*)response
{
    AFServiceConfig *config = response.config;
    id<AFServiceProtocol>service = [self retrieveServiceWithConfig:config];
    [service service:config success:response];
    [self removeServiceWithConfig:config];
}

- (void)requestWillLoadFromServerReporter:(AFServiceConfig*)config
{
    id<AFServiceProtocol>service = [self retrieveServiceWithConfig:config];
    if ([service respondsToSelector:@selector(serviceWillLoadFromServer:)]) {
        [service serviceWillLoadFromServer:config];
    }
}

- (void)requestDidLoadFromServerReporter:(AFServiceConfig*)config
{
    id<AFServiceProtocol>service = [self retrieveServiceWithConfig:config];
    if ([service respondsToSelector:@selector(serviceDidLoadFromServer:)]) {
        [service serviceDidLoadFromServer:config];
    }
}


- (void)removeServiceWithConfig:(AFServiceConfig*)config
{
    NSMutableDictionary *dic = _serviceInfos[config.serviceKey];
    [dic removeObjectForKey:config.requestKey];
}

- (id<AFServiceProtocol>)retrieveServiceWithConfig:(AFServiceConfig *)config
{
    AFServiceInfo *serviceInfo = _serviceInfos[config.serviceKey][config.requestKey];
    return serviceInfo.service;
}

#pragma mark - Check Cache Method

- (BOOL)checkCacheAndReturnIfPossible:(AFServiceConfig*)config
{
    BOOL isCacheValid  = NO;
    NSString *cacheKey = config.cacheKey;
    NSDate *expireTime = [NSDate date];
    id objects = [CacheManager objectsForCacheKey:cacheKey expireDate:expireTime inContext:[NSManagedObjectContext MR_defaultContext]];
    if (objects) {
        isCacheValid = YES;
        //回调，返回缓存
        // 因为NSManagedObject不能跨线程使用，所以这里要传递NSManagedObjectID对象
        id responseObjectIDs = [AFCacheManage coreDataObjectIDArrayFromObjects:objects];
        AFServiceResult *result = [AFServiceResult resultWithCode:AFServiceResultCodeHitCache message:@"Hit local cache!" info:nil];
        AFServiceResponse *response = [AFServiceResponse responseWithObject:responseObjectIDs result:result config:config];
        response.fromCache = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            //因为传递进来的是NSManagedObjectID对象，所以这里要根据ID取出所有的NSManagedObject
            id objectIDs = response.object;
            response.object = [AFCacheManage coreDataObjectIDArrayFromObjects:objectIDs];
            [self requestSuccessReporter:response];
        });
    }
    return isCacheValid;
}


#pragma mark - Service Info Helper

- (AFServiceConfig *)storeServiceInfo:(id<AFServiceProtocol>)service config:(AFServiceConfig*)config
{
    // identify config
    NSString *serviceKey = [self generateServiceKey:service];
    NSString *requestKey = [ self generateServiceKey:service withServiceKey:serviceKey];
    
    config.serviceKey = serviceKey;
    config.requestKey = requestKey;
    
    //mark a copy
    AFServiceConfig *copy = [config copy];
    // store service info for service life cycle control
    AFServiceInfo *serviceInfo = [AFServiceInfo new];
    serviceInfo.config = copy;
    serviceInfo.service = service;
    NSMutableDictionary *dic = _serviceInfos[@"serviceKey"];
    if (!dic) {
        dic = [NSMutableDictionary dictionaryWithCapacity:1];
        _serviceInfos[serviceKey] = dic;
    }
    dic[requestKey] = serviceInfo;
    return copy;
}



- (NSString*)generateServiceKey:(id<AFServiceProtocol>)service
{
    NSString *key = [NSString stringWithFormat:@"%@_%p",NSStringFromClass(service.class),service];
    return key;
}

- (NSString*)generateServiceKey:(id<AFServiceProtocol>)service withServiceKey:(NSString*)serviceKey
{
    NSMutableString *key = [NSMutableString new];
    NSUInteger count = [(NSNumber *)_classNameCounts[serviceKey] unsignedIntegerValue];
    _classNameCounts[serviceKey] = @(++count);
    [key appendFormat:@"_%lu",(unsigned long)count];
    return [NSString stringWithString:key];
}

- (BOOL)isServiceConfigValid:(AFServiceConfig*)config
{
    if (!config.isModel && config.saveCache) {
        return NO;
    }
    if (!config.saveCache && !config.forceLoad) {
        return NO;
    }
    return YES;
}


@end
