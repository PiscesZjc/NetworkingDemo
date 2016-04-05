//
//  UIView+NSLayoutConstraintFilter.m
//  WK
//
//  Created by cwei on 13-12-9.
//  Copyright (c) 2013年 Wei, Chengjiong. All rights reserved.
//

#import "UIView+NSLayoutConstraintFilter.h"

@implementation UIView (NSLayoutConstraintFilter)

- (NSArray *)constaintsForAttribute:(NSLayoutAttribute)attribute
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d", attribute];
    NSArray *filteredArray = [[self constraints] filteredArrayUsingPredicate:predicate];
    return filteredArray;
}

- (NSLayoutConstraint *)constraintForAttribute:(NSLayoutAttribute)attribute
{
    NSArray *constraints = [self constaintsForAttribute:attribute];
    if (constraints.count > 0) {
        return constraints[0];
    }
    return nil;
}

- (NSLayoutConstraint *)constraintForAttribute:(NSLayoutAttribute)attribute withView:(UIView *)view
{
    NSArray *constraints = [self constaintsForAttribute:attribute];
    __block NSLayoutConstraint *constraint = nil;
    [constraints enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        constraint = obj;
        if (constraint.firstItem == view) {
            *stop = YES;
        }
    }];
    return constraint;
}

@end
