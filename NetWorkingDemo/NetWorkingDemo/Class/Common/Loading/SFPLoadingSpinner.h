//
//  SFPLoadingSpinner.h
//  SunFlowerProvider
//
//  Created by WeiChengjiong on 7/31/14.
//  Copyright (c) 2014 9Top. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    SFPLoadingSpinnerSpeedNormal = 0,
    SFPLoadingSpinnerSpeedQuick,
} SFPLoadingSpinnerSpeed;


@interface SFPLoadingSpinner : UIView

+ (SFPLoadingSpinner *)loadingSpinner;

@property (nonatomic, strong) UIImage *dotImage;
@property (nonatomic) CGFloat radius;
@property (nonatomic) NSInteger dotCount;
@property (nonatomic) SFPLoadingSpinnerSpeed speed;
@property (nonatomic) BOOL animating;
@property (nonatomic, readonly) NSInteger totalSteps;

- (void)reset;
- (void)releaseFromPerformSelector;

@end
