//
//  WKCodingUtil.m
//
//  Created by WeiChengjiong on 13-12-4.
//  Copyright (c) 2013年 Wei, Chengjiong. All rights reserved.
//

#import "WKCodingUtil.h"

@implementation WKCodingUtil

+ (NSLayoutConstraint *)setEdgeConstraintFromView:(UIView *)view toSuperviewWithAttr:(NSLayoutAttribute)attr constant:(CGFloat)constant
{
    NSLayoutConstraint *contraint = [NSLayoutConstraint constraintWithItem:view attribute:attr relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:attr multiplier:1.0 constant:constant];
    [view.superview addConstraint:contraint];
    return contraint;
}

+ (NSLayoutConstraint *)setEdgeConstraintFromView:(UIView *)view1 toView:(UIView *)view2 attr:(NSLayoutAttribute)attr constant:(CGFloat)constant
{
    NSLayoutConstraint *contraint = [NSLayoutConstraint constraintWithItem:view1 attribute:attr relatedBy:NSLayoutRelationEqual toItem:view2 attribute:attr multiplier:1.0 constant:constant];
    [view1.superview addConstraint:contraint];
    return contraint;
}

+ (NSLayoutConstraint *)setFixWidthConstraintForView:(UIView *)view constant:(CGFloat)constant
{
    NSLayoutConstraint *contraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:constant];
    [view.superview addConstraint:contraint];
    return contraint;
}

+ (NSLayoutConstraint *)setFixHeightConstraintForView:(UIView *)view constant:(CGFloat)constant
{
    NSLayoutConstraint *contraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:constant];
    [view.superview addConstraint:contraint];
    return contraint;
}

+ (NSLayoutConstraint *)setCenterXConstraintForView:(UIView *)view
{
    return [self setCenterXOffsetConstraintForView:view constant:0];
}

+ (NSLayoutConstraint *)setCenterXOffsetConstraintForView:(UIView *)view constant:(CGFloat)constant
{
    NSLayoutConstraint *contraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:constant];
    [view.superview addConstraint:contraint];
    return contraint;
}

+ (NSLayoutConstraint *)setCenterYConstraintForView:(UIView *)view
{
    return [self setCenterYOffsetConstraintForView:view constant:0];
}

+ (NSLayoutConstraint *)setCenterYOffsetConstraintForView:(UIView *)view constant:(CGFloat)constant
{
    NSLayoutConstraint *contraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:constant];
    [view.superview addConstraint:contraint];
    return contraint;
}

@end
