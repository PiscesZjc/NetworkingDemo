//
//  AFServiceResponse.h
//  NetWorkingDemo
//
//  Created by zjc on 16/3/2.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFServiceResult.h"
#import "AFServiceConfig.h"

@interface AFServiceResponse : NSObject

@property (nonatomic,strong) id object;
@property (nonatomic,strong) AFServiceResult *result;
@property (nonatomic,strong) AFServiceConfig *config;
@property (nonatomic,assign) BOOL fromCache;
@property (nonatomic,assign) NSUInteger pageIndex;
@property (nonatomic,assign) NSUInteger pageSize;

+ (AFServiceResponse *)responseWithObject:(id)object result:(AFServiceResult *)result config:(AFServiceConfig *)config;

@end
