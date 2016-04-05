//
//  CWOnePixelHeightLine.m
//  WK
//
//  Created by cwei on 13-9-26.
//  Copyright (c) 2013年 Wei, Chengjiong. All rights reserved.
//

#import "CWOnePixelHeightLine.h"


#define kDefaultLineColor [UIColor colorWithRed:0 green:0 blue:0 alpha:1]


@interface CWOnePixelHeightLine ()

@property (nonatomic) UIColor *lineColor;

@end


@implementation CWOnePixelHeightLine

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _lineColor = backgroundColor;
    if (!_lineColor) {
        _lineColor = kDefaultLineColor;
    }
    super.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat inset;
    if ([WKCommonUtil is2XRetina]) {
        inset = 0.25;
    } else if ([WKCommonUtil is3XRetina]) {
        inset = 0.5/3;
    } else {
        inset = 0.5;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    // draw
    CGContextSetLineWidth(context, inset);
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    CGContextMoveToPoint(context, 0, inset);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), inset);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

@end
