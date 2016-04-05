//
//  AFServiceProtocol.h
//  NetWorkingDemo
//
//  Created by zjc on 16/3/2.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFServiceConfig.h"
#import "AFServiceResponse.h"

@protocol AFServiceProtocol <NSObject>

@required
- (id)service:(AFServiceConfig*)config parse:(AFServiceResponse *)response inContext:(NSManagedObjectContext*)context;
- (void)service:(AFServiceConfig*)config success:(AFServiceResponse*)response;
- (void)service:(AFServiceConfig *)config failure:(AFServiceResponse*)response;

@optional
- (AFServiceConfig *)serviceConfig;
- (BOOL)service:(AFServiceConfig *)config isResponseValid:(AFServiceResponse *)response;
- (void)serviceWillLoadFromServer:(AFServiceConfig *)config;
- (void)serviceDidLoadFromServer:(AFServiceConfig *)config;
- (void)service:(AFServiceConfig *)config willSendMultipartFormData:(id<AFMultipartFormData>)formData;
@end