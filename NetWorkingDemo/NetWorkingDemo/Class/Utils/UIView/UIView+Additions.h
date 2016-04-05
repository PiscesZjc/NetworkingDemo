//
//  UIView+Additions.h
//  WK
//
//  Created by Wei, Chengjiong on 12/23/2012.
//  Copyright (c) 2012 Wei, Chengjiong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (Additions)

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

- (UIView *)findFirstResponder;

@end
