//
//  UIImageView+Custom.m
//  SunFlowerProvider
//
//  Created by WeiChengjiong on 7/29/14.
//  Copyright (c) 2014 9Top. All rights reserved.
//

#import "UIImageView+Custom.h"

@implementation UIImageView (Custom)

- (void)setImageWithAddress:(NSString *)address
{
    [self setImageWithAddress:address placeholderImage:nil];
}

- (void)setImageWithAddress:(NSString *)address
           placeholderImage:(UIImage *)placeholderImage
{
    NSURL *url = [NSURL URLWithString:address];
    [self setImageWithURL:url placeholderImage:placeholderImage];
}

- (void)setImageWithAddress:(NSString *)address
         placeholderAddress:(NSString *)placeholderAddress
{
    NSURL *url = nil;
    if (address) {
        url = [NSURL URLWithString:address];
    } else {
        url = [NSURL URLWithString:placeholderAddress];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self setImageWithURL:url];
    });
}

@end
