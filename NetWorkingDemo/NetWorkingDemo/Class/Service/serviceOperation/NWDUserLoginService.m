//
//  NWDUserLoginService.m
//  NetWorkingDemo
//
//  Created by zjc on 16/3/21.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import "NWDUserLoginService.h"

@implementation NWDUserLoginService

-(void)loginUser:(NSString *)username activeCode:(NSString *)activeCode
{
    AFServiceConfig *config = [self defaultServiceConfig];
    config.service = @"/login/login";
    config.httpMethod = AFHttpPost;
    config.forceLoad = YES;
    config.saveCache = YES;
    config.isModel = YES;
    config.cacheExpireInterval = 365*24*3600;   // App端登录有效期一年
    config.params[@"login_name"] = username;
    config.params[@"verify_code"] = activeCode;
    [self load:config];
}

#pragma mark - Base Methods

-(id)onParse:(id)response config:(AFServiceConfig *)config inContext:(NSManagedObjectContext *)context
{
    if (![response isKindOfClass:NSDictionary.class]) {
        
        return nil;
    }
    id responseObject = response[@"user"];
    if (!responseObject ||![responseObject isKindOfClass:NSDictionary.class]) {
        return nil;
    }
    NWDUserInfo *user = [NWDUserInfo createModelFromJSONData:responseObject inContext:context];
    // 表示这个userinfo对象是用户登录身份对象，其余uid相同的userinfo对象只是其他service回来的普通用户对象
//    user.isCurrentValue = YES;
    return user;
}

- (void)service:(AFServiceConfig *)config success:(AFServiceResponse *)response
{
    [super service:config success:response];
    if([self.delegate conformsToProtocol:@protocol(NADUserLoginServiceDelegate)]&&[self.delegate respondsToSelector:@selector(service:userDidLogin:)]){
        [(id<NADUserLoginServiceDelegate>)self.delegate service:self userDidLogin:response.object];
    }
}

@end
