//
//  UIViewController+Tracking.m
//  NewAnnieDeer
//
//  Created by WeiChengjiong on 9/6/15.
//  Copyright (c) 2015 demo. All rights reserved.
//

#import "UIViewController+Tracking.h"
#import <objc/runtime.h>


@implementation UIViewController (Tracking)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        // swizzle present
        SEL originalSelector = @selector(presentViewController:animated:completion:);
        SEL swizzledSelector = @selector(WK_presentViewController:animated:completion:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        BOOL didAddMethod = class_addMethod(class,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
        // swizzle dismiss
        originalSelector = @selector(dismissViewControllerAnimated:completion:);
        swizzledSelector = @selector(WK_dismissViewControllerAnimated:completion:);
        originalMethod = class_getInstanceMethod(class, originalSelector);
        swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        didAddMethod = class_addMethod(class,
                                       originalSelector,
                                       method_getImplementation(swizzledMethod),
                                       method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)WK_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    [AppContext presentViewController:viewControllerToPresent];
    [self WK_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)WK_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    UIViewController *presentedController = self;
    if (self.presentedViewController) {
        presentedController = self.presentedViewController;
    }
    [AppContext dismissViewController:presentedController];
    [self WK_dismissViewControllerAnimated:flag completion:completion];
}

@end
