//
//  WKCodingUtil.h
//
//  Created by WeiChengjiong on 13-12-4.
//  Copyright (c) 2013年 Wei, Chengjiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+NSLayoutConstraintFilter.h"

@interface WKCodingUtil : NSObject

// 设置Autolayout中的边距辅助方法
+ (NSLayoutConstraint *)setEdgeConstraintFromView:(UIView *)view toSuperviewWithAttr:(NSLayoutAttribute)attr constant:(CGFloat)constant;
+ (NSLayoutConstraint *)setEdgeConstraintFromView:(UIView *)view1 toView:(UIView *)view2 attr:(NSLayoutAttribute)attr constant:(CGFloat)constant;
// 设置Autolayout中的宽度和高度
+ (NSLayoutConstraint *)setFixWidthConstraintForView:(UIView *)view constant:(CGFloat)constant;
+ (NSLayoutConstraint *)setFixHeightConstraintForView:(UIView *)view constant:(CGFloat)constant;
// 设置Autolayout中的纵向和横向中心位置
+ (NSLayoutConstraint *)setCenterXConstraintForView:(UIView *)view;
+ (NSLayoutConstraint *)setCenterXOffsetConstraintForView:(UIView *)view constant:(CGFloat)constant;
+ (NSLayoutConstraint *)setCenterYConstraintForView:(UIView *)view;
+ (NSLayoutConstraint *)setCenterYOffsetConstraintForView:(UIView *)view constant:(CGFloat)constant;

@end
