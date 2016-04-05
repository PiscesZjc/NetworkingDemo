//
//  AFServiceResponse.m
//  NetWorkingDemo
//
//  Created by zjc on 16/3/2.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import "AFServiceResponse.h"

@implementation AFServiceResponse

+ (AFServiceResponse *)responseWithObject:(id)object result:(AFServiceResult *)result config:(AFServiceConfig *)config
{
    AFServiceResponse *response  = [[AFServiceResponse alloc] init];
    response.object = object;
    response.result = result;
    response.config = config;
    response.fromCache = NO;
    return response;
}

@end
