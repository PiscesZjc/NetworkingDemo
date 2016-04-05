//
//  AFServiceResult.m
//  NetWorkingDemo
//
//  Created by zjc on 16/3/2.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import "AFServiceResult.h"

@implementation AFServiceResult

+ (AFServiceResult *)resultWithCode:(NSInteger)code message:(NSString *)message info:(NSDictionary *)info
{
    AFServiceResult *result = [[AFServiceResult alloc] init];
    result.code = code;
    result.message = message;
    result.info = info;
    return result;
}

@end
