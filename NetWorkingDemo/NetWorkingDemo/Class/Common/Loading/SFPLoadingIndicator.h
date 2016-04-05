//
//  SFPLoadingIndicator.h
//  SunFlowerProvider
//
//  Created by WeiChengjiong on 7/30/14.
//  Copyright (c) 2014 9Top. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    SFPLoadingIndicatorSpeedNormal = 0,
    SFPLoadingIndicatorSpeedQuick,
} SFPLoadingIndicatorSpeed;


@interface SFPLoadingIndicator : UIView

+ (SFPLoadingIndicator *)loadingIndicator;

@property (nonatomic) CGFloat dotRadius;
@property (nonatomic) CGFloat dotInterval;
@property (nonatomic) SFPLoadingIndicatorSpeed speed;
@property (nonatomic) BOOL animating;
@property (nonatomic, readonly) NSInteger totalSteps;
@property (nonatomic) NSInteger firstStep;

- (void)reset;
- (void)showIndicatorInStep:(NSInteger)step;
- (void)releaseFromPerformSelector;

@end
