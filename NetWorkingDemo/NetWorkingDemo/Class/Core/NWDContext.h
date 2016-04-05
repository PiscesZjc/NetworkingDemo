//
//  NWDContext.h
//  NetWorkingDemo
//
//  Created by zjc on 16/3/1.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NWDRootController.h"

@interface NWDContext : NSObject

@property (nonatomic, readonly) NSString *serverAddress;

@property (nonatomic, readonly) UINavigationController *globalNavigationController;
@property (nonatomic, readonly) NWDRootController *rootController;
@property (nonatomic, readonly) UIView *topMostView;
// modal view controller tracking
@property (nonatomic, readonly) UIViewController *topPresentedViewController;
@property (nonatomic, copy) NSString *currentUserID;
+ (id)sharedInstance;


- (void)presentViewController:(UIViewController *)viewController;
- (void)dismissViewController:(UIViewController *)viewController;
- (void)initializeAppOnLaunching;

@end
