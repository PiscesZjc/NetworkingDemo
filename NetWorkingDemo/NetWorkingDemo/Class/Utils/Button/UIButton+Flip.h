//
//  UIButton+Flip.h
//  WK
//
//  Created by Wei, Chengjiong on 8/24/12.
//  Copyright (c) 2012 Wei, Chengjiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Flip)

+ (UIView *)flipButtonWithFirstImage:(UIImage *)firstImage
                         secondImage:(UIImage *)secondImage
                     firstTransition:(UIViewAnimationTransition)firstTransition
                    secondTransition:(UIViewAnimationTransition)secondTransition
                      animationCurve:(UIViewAnimationCurve)curve
                            duration:(NSTimeInterval)duration
                              target:(id)target
                            selector:(SEL)selector;

+ (UIView *)flipButtonWithBackgroundImage:(UIImage *)backgroundImage
                               firstTitle:(NSString *)firstTitle
                              secondTitle:(NSString *)secondTitle
                          firstTransition:(UIViewAnimationTransition)firstTransition
                         secondTransition:(UIViewAnimationTransition)secondTransition
                           animationCurve:(UIViewAnimationCurve)curve
                                 duration:(NSTimeInterval)duration
                                   target:(id)target
                                 selector:(SEL)selector;

@end
