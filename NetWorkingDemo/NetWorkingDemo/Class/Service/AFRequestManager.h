//
//  AFRequestManager.h
//  NetWorkingDemo
//
//  Created by zjc on 16/3/4.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface AFRequestManager : AFHTTPSessionManager
@property (nonatomic) NSURLRequestCachePolicy cachePolicy;
@property (nonatomic) NSTimeInterval timeoutInterval;

@end
