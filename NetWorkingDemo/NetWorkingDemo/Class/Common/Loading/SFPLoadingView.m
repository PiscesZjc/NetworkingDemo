//
//  SFPEmbeddedLoadingView.m
//  SunFlowerProvider
//
//  Created by WeiChengjiong on 7/30/14.
//  Copyright (c) 2014 9Top. All rights reserved.
//

#import "SFPLoadingView.h"


@implementation SFPLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // self
        self.backgroundColor = [UIColor clearColor];
        // indicator
        _spinner = [SFPLoadingSpinner loadingSpinner];
        [self addSubview:_spinner];
        _spinner.translatesAutoresizingMaskIntoConstraints = NO;
        
        [WKCodingUtil setCenterXConstraintForView:_spinner];
        [WKCodingUtil setFixWidthConstraintForView:_spinner constant:CGRectGetWidth(_spinner.frame)];
        [WKCodingUtil setFixHeightConstraintForView:_spinner constant:CGRectGetHeight(_spinner.frame)];
        [WKCodingUtil setCenterYOffsetConstraintForView:_spinner constant:-10];
        // title
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_titleLabel];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [WKCodingUtil setEdgeConstraintFromView:_titleLabel toSuperviewWithAttr:NSLayoutAttributeLeft constant:0];
        [WKCodingUtil setEdgeConstraintFromView:_titleLabel toSuperviewWithAttr:NSLayoutAttributeRight constant:0];
        [WKCodingUtil setFixHeightConstraintForView:_titleLabel constant:30];
        [WKCodingUtil setCenterYOffsetConstraintForView:_titleLabel constant:30];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)dealloc
{
    _spinner.animating = NO;
}

+ (SFPLoadingView *)embeddedLoadingView
{
    SFPLoadingView *loadingView = [[SFPLoadingView alloc] initWithFrame:CGRectZero];
    loadingView.spinner.dotImage = [UIImage imageNamed:@"ic_loadingOrange.png"];
    loadingView.titleLabel.textColor = rgbColor(253, 114, 9);
    loadingView.titleLabel.text = @"努力加载中";
    return loadingView;
}

+ (SFPLoadingView *)airLoadingView
{
    SFPLoadingView *loadingView = [[SFPLoadingView alloc] initWithFrame:CGRectZero];
    loadingView.spinner.dotImage = [UIImage imageNamed:@"ic_loadingWhite.png"];
    loadingView.titleLabel.textColor = [UIColor whiteColor];
    loadingView.titleLabel.text = @"请稍后";
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    backgroundImageView.image = [UIImage imageNamed:@"bg_loadingShadow.png"];
    [loadingView addSubview:backgroundImageView];
    [loadingView sendSubviewToBack:backgroundImageView];
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [WKCodingUtil setFixWidthConstraintForView:backgroundImageView constant:CGRectGetWidth(backgroundImageView.frame)];
    [WKCodingUtil setFixHeightConstraintForView:backgroundImageView constant:CGRectGetHeight(backgroundImageView.frame)];
    [WKCodingUtil setCenterXConstraintForView:backgroundImageView];
    [WKCodingUtil setCenterYConstraintForView:backgroundImageView];
    
    return loadingView;
}

- (void)placeLoadingViewinCenter:(UIView *)view
{
    [view addSubview:self];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [WKCodingUtil setEdgeConstraintFromView:self toSuperviewWithAttr:NSLayoutAttributeTop constant:0];
    [WKCodingUtil setEdgeConstraintFromView:self toSuperviewWithAttr:NSLayoutAttributeBottom constant:0];
    [WKCodingUtil setEdgeConstraintFromView:self toSuperviewWithAttr:NSLayoutAttributeLeading constant:0];
    [WKCodingUtil setEdgeConstraintFromView:self toSuperviewWithAttr:NSLayoutAttributeTrailing constant:0];
}

@end
