//
//  UIView+NSLayoutConstraintFilter.h
//  WK
//
//  Created by cwei on 13-12-9.
//  Copyright (c) 2013年 Wei, Chengjiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NSLayoutConstraintFilter)

- (NSArray *)constaintsForAttribute:(NSLayoutAttribute)attribute;
- (NSLayoutConstraint *)constraintForAttribute:(NSLayoutAttribute)attribute;
- (NSLayoutConstraint *)constraintForAttribute:(NSLayoutAttribute)attribute withView:(UIView *)view;

@end
