//
//  NWDRootController.m
//  NetWorkingDemo
//
//  Created by zjc on 16/3/1.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import "NWDRootController.h"
#import "NWDMainController.h"

@interface NWDRootController ()

@end

@implementation NWDRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = NO;//防止全局的布局被navgationBar遮住
    [self showApplicationMainScreen];
}

- (void)showApplicationMainScreen
{
    NWDMainController *controller = [[NWDMainController alloc] initWithNibName:@"NWDMainController" bundle:nil];
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    controller.view.translatesAutoresizingMaskIntoConstraints = NO;
    [WKCodingUtil setEdgeConstraintFromView:controller.view toSuperviewWithAttr:NSLayoutAttributeTop constant:0];
    [WKCodingUtil setEdgeConstraintFromView:controller.view toSuperviewWithAttr:NSLayoutAttributeLeft constant:0];
    [WKCodingUtil setEdgeConstraintFromView:controller.view toSuperviewWithAttr:NSLayoutAttributeBottom constant:0];
    [WKCodingUtil setEdgeConstraintFromView:controller.view toSuperviewWithAttr:NSLayoutAttributeRight constant:0];
    [controller didMoveToParentViewController:self];
     AppContext.globalNavigationController.navigationBarHidden = NO;
    
}


@end
