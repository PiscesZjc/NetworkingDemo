//
//  SFPAlertView.h
//  SunFlowerProvider
//
//  Created by WeiChengjiong on 9/16/14.
//  Copyright (c) 2014 9Top. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LEJAlertView;
@protocol SFPAlertViewDelegate <NSObject>

@required
- (void)alertView:(LEJAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end



@interface LEJAlertView : UIView

@property (nonatomic, weak) id<SFPAlertViewDelegate> delegate;
@property (nonatomic, readonly) UIView *messageView;

+ (LEJAlertView *)showAlertWithMessage:(NSString *)message
                              duration:(NSTimeInterval)duration;

+ (LEJAlertView *)showAlertWithTitle:(NSString *)title
                             message:(NSString *)message
                            delegate:(id<SFPAlertViewDelegate>)delegate
                             buttons:(NSArray *)buttonTitles;

+ (LEJAlertView *)showAlertWithTitle:(NSString *)title
                         messageView:(UIView *)messageView
                            delegate:(id<SFPAlertViewDelegate>)delegate
                             buttons:(NSArray *)buttonTitles;

+ (void)clearAlerts;

@end
