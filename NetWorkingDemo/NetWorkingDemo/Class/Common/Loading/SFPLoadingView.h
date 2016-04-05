//
//  SFPEmbeddedLoadingView.h
//  SunFlowerProvider
//
//  Created by WeiChengjiong on 7/30/14.
//  Copyright (c) 2014 9Top. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFPLoadingView : UIView

@property (nonatomic, strong) SFPLoadingSpinner *spinner;
@property (nonatomic, strong) UILabel *titleLabel;

+ (SFPLoadingView *)embeddedLoadingView;
+ (SFPLoadingView *)airLoadingView;

- (void)placeLoadingViewinCenter:(UIView *)view;

@end
