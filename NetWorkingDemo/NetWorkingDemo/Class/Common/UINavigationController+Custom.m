//
//  UINavigationController+Custom.m
//  SunFlowerProvider
//
//  Created by WeiChengjiong on 7/24/14.
//  Copyright (c) 2014 9Top. All rights reserved.
//

#import "UINavigationController+Custom.h"

@implementation UINavigationController (Custom)

- (void)popupTopController
{
    [self popViewControllerAnimated:YES];
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

@end
