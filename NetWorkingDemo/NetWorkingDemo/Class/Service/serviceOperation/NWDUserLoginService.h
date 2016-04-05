//
//  NWDUserLoginService.h
//  NetWorkingDemo
//
//  Created by zjc on 16/3/21.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import "AFBaseService.h"

@protocol NADUserLoginServiceDelegate <AFBaseServiceDelegate>

- (void)service:(AFBaseService *)service userDidLogin:(NWDUserInfo*)userInfo;

@end


@interface NWDUserLoginService : AFBaseService
- (void)loginUser:(NSString *)username activeCode:(NSString *)activeCode;

@end
