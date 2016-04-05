//
//  WKBarButtonUtil.h
//  WK
//
//  Created by Wei, Chengjiong on 8/24/12.
//  Copyright (c) 2012 Wei, Chengjiong. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    WKBarButtonUtilContentAlignmentLeft = 0,
    WKBarButtonUtilContentAlignmentCenter,
    WKBarButtonUtilContentAlignmentRight,
}WKBarButtonUtilContentAlignment;


@interface WKBarButtonUtil : NSObject

+ (UIBarButtonItem *)backButton4Controller:(UIViewController *)controller;
+ (UIBarButtonItem *)backButton4Controller:(UIViewController *)controller action:(SEL)action;
+ (UIBarButtonItem *)actionButton4Controller:(UIViewController *)controller action:(SEL)action;
+ (UIBarButtonItem *)playerButton4Controller:(UIViewController *)controller action:(SEL)action;
+ (UIBarButtonItem *)addButton4Controller:(UIViewController *)controller action:(SEL)action;
+ (UIBarButtonItem *)settingsButton4Controller:(UIViewController *)controller action:(SEL)action;
+ (UIBarButtonItem *)textButton4Controller:(UIViewController *)controller action:(SEL)action title:(NSString *)title alignment:(WKBarButtonUtilContentAlignment)alignment;
+ (UIBarButtonItem *)barButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)barButtonWithImage:(UIImage *)image target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)barButtonWithTitleRight:(NSString *)title target:(id)target action:(SEL)action;

+ (void)setTitle:(NSString *)title button:(UIBarButtonItem *)button;

+ (UIBarButtonItem *)cancleButton4Controller:(UIViewController *)controller action:(SEL)action;//取消按钮

@end
