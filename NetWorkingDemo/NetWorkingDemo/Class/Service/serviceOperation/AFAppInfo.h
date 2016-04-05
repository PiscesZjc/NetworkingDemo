//
//  AFAppInfo.h
//  NetWorkingDemo
//
//  Created by zjc on 16/3/21.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import "AFBaseService.h"

@protocol NADAppInfoServiceDelegate <AFBaseServiceDelegate>

- (void)service:(AFBaseService *)service appInfoDidLoad:(NSDictionary *)appInfo;

@end

@interface AFAppInfo : AFBaseService


- (void)loadAppInfo;

@end
