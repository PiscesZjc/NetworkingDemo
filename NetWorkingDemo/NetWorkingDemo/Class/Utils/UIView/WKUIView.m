//
//  WKUIView.m
//  WK
//
//  Created by Wei, Chengjiong on 8/24/12.
//  Copyright (c) 2012 Wei, Chengjiong. All rights reserved.
//

#import "WKUIView.h"

@implementation WKUIView

- (void)drawRect:(CGRect)rect
{
    if ([self.drawDelegate respondsToSelector:@selector(view:drawRect:)])
    {
        [self.drawDelegate view:self drawRect:rect];
    }
}

@end
