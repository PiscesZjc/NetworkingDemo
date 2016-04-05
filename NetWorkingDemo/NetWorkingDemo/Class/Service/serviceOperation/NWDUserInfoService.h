//
//  NWDUserInfoService.h
//  NetWorkingDemo
//
//  Created by zjc on 16/3/2.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import "AFBaseService.h"

@protocol NWDUserInfoServiceDelagate <AFBaseServiceDelegate>

- (void)service:(AFBaseService*)service userInfoDidLoad:(NWDUserInfo*)userInfo;

@end

@interface NWDUserInfoService : AFBaseService

- (void)loadTheUserInfo:(BOOL)force;

@end
