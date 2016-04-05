//
//  UIImageView+Custom.h
//  SunFlowerProvider
//
//  Created by WeiChengjiong on 7/29/14.
//  Copyright (c) 2014 9Top. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Custom)

- (void)setImageWithAddress:(NSString *)address;
- (void)setImageWithAddress:(NSString *)address
           placeholderImage:(UIImage *)placeholderImage;
- (void)setImageWithAddress:(NSString *)address
         placeholderAddress:(NSString *)placeholderAddress;

@end
