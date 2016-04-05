//
//  AFAppInfo.m
//  NetWorkingDemo
//
//  Created by zjc on 16/3/21.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import "AFAppInfo.h"

@implementation AFAppInfo


- (void)loadAppInfo
{
    AFServiceConfig *config = [self defaultServiceConfig];
    config.service = @"/const/appInfo";
    config.httpMethod = AFHttpGet;
    config.forceLoad = YES;
    config.saveCache = NO;
    config.isModel = NO;
    config.params[@"client_type"] = @"ios";
    [self load:config];
}

#pragma mark - Base Methods

- (id)onParse:(id)response config:(AFServiceConfig *)config inContext:(NSManagedObjectContext *)context
{
    if (![response isKindOfClass:NSDictionary.class]) {
        return nil;
    }
    id responseObject = response[@"info"];
    if (!responseObject || ![responseObject isKindOfClass:NSDictionary.class]) {
        return nil;
    }
    
    NSDictionary *object = @{@"about_us":responseObject[@"about_us"],
                             @"join_us":responseObject[@"join_us"],
                             @"app_version":responseObject[@"app_version"],
                             @"service_tel":responseObject[@"service_tel"],
                             @"cdn_url":responseObject[@"cdn_url"],
                             @"serveFeeThreshold":responseObject[@"serveFeeLine"],
                             @"serveFeeRatio":responseObject[@"serveFeeRate"]};
    return object;
}

- (void)service:(AFServiceConfig *)config success:(AFServiceResponse *)response
{
    [super service:config success:response];
    if ([self.delegate conformsToProtocol:@protocol(NADAppInfoServiceDelegate)] && [self.delegate respondsToSelector:@selector(service:appInfoDidLoad:)]) {
        [(id<NADAppInfoServiceDelegate>)self.delegate service:self appInfoDidLoad:response.object];
    }
}


@end
