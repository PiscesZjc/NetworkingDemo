//
//  NWDUserInfoService.m
//  NetWorkingDemo
//
//  Created by zjc on 16/3/2.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import "NWDUserInfoService.h"

@implementation NWDUserInfoService

- (void)loadTheUserInfo:(BOOL)force
{
    AFServiceConfig *config = [self defaultServiceConfig];
    config.saveCache = YES;
    config.service = @"/user/info";
    config.forceLoad = force;
    config.isModel = YES;
    [self loadTheUserInfo:YES];
}

#pragma mark - Base Method
- (id)onParse:(id)response config:(AFServiceConfig *)config inContext:(NSManagedObjectContext *)context
{
    if (![response isKindOfClass:NSDictionary.class]) {
        
        return nil;
    }
    id responseObject = response[@"user"];
    if (!responseObject ||![responseObject isKindOfClass:NSDictionary.class]) {
        return nil;
    }
    NWDUserInfo *user = [NWDUserInfo createModelFromJSONData:responseObject inContext:context];
    [NWDUserInfo updateCurrentUserInfo:user];
    return user;
}

- (void)service:(AFServiceConfig *)config success:(AFServiceResponse *)response
{
    [super service:config success:response];
    if ([self.delegate conformsToProtocol:@protocol(NWDUserInfoServiceDelagate)] && [self.delegate  respondsToSelector:@selector(service:userInfoDidLoad:)]) {
        [(id<NWDUserInfoServiceDelagate>)self.delegate service:self userInfoDidLoad:response.object];
    }
}

@end
