//
//  CWOnePixelWidthLine.m
//  SunFlowerProvider
//
//  Created by WeiChengjiong on 10/21/14.
//  Copyright (c) 2014 9Top. All rights reserved.
//

#import "CWOnePixelWidthLine.h"

#define kDefaultLineColor [UIColor colorWithRed:0 green:0 blue:0 alpha:1]


@interface CWOnePixelWidthLine ()

@property (nonatomic) UIColor *lineColor;

@end


@implementation CWOnePixelWidthLine

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
    CGContextMoveToPoint(context, inset, 0);
    CGContextAddLineToPoint(context, inset, CGRectGetHeight(rect));
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

@end
