//
//  NWDMainController.m
//  NetWorkingDemo
//
//  Created by zjc on 16/3/1.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import "NWDMainController.h"
//#import "NWDUserInfoService.h"
#import "AFAppInfo.h"
#import "NWDUserLoginService.h"

@interface NWDMainController ()<NADUserLoginServiceDelegate,NADAppInfoServiceDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (nonatomic) AFAppInfo *appinfoService;
@property (nonatomic) NWDUserLoginService *loginService;

@end

@implementation NWDMainController

- (void)viewDidLoad {
    [super viewDidLoad];
//    
//    if (!_appinfoService) {
//        _appinfoService  = [[AFAppInfo alloc] initWithDelegate:self];
//    }
//   
//    [_appinfoService loadAppInfo];
    
    
    if (!_loginService) {
        _loginService = [[NWDUserLoginService alloc] initWithDelegate:self];
    }
    [_loginService loginUser:@"15088617127" activeCode:@"103104"];
    
}

- (void)service:(AFBaseService *)service userDidLogin:(NWDUserInfo*)userInfo
{
    NWDUserInfo *user = userInfo;

    }




@end
