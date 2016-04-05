//
//  SFPLoadingIndicator.m
//  SunFlowerProvider
//
//  Created by WeiChengjiong on 7/30/14.
//  Copyright (c) 2014 9Top. All rights reserved.
//

#import "SFPLoadingIndicator.h"


#define kDotsNumber 4
#define kAnimationFrameNumber 41

#define kDefaultDotRadius 6
#define kMinDotRadius 2


@interface SFPLoadingIndicator ()
{
    NSMutableArray *_points;
    NSInteger _cycleSteps;
    NSInteger _step;
}

@end


@implementation SFPLoadingIndicator

+ (SFPLoadingIndicator *)loadingIndicator
{
    CGRect frame = CGRectMake(0, 0, 160, 30);
    SFPLoadingIndicator *indicator = [[SFPLoadingIndicator alloc] initWithFrame:frame];
    [indicator setupUserInterface];
    [indicator animate];
    return indicator;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dotRadius = kDefaultDotRadius;
        _dotInterval = -1;
        _firstStep = 0;
    }
    return self;
}

- (void)reset
{
    [self stopAnimate];
    _step = MIN(_firstStep, kAnimationFrameNumber);
    [_points enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *point = obj;
        point.alpha = 0;
    }];
}

- (void)showIndicatorInStep:(NSInteger)step
{
    if (step < 0 || step >= kAnimationFrameNumber) {
        return;
    }
    [self adjustPointsInStep:step];
}

- (void)setDotRadius:(CGFloat)radius
{
    _dotRadius = MAX(radius, kMinDotRadius);
    [self setNeedsLayout];
}

- (void)setDotInterval:(CGFloat)interval
{
    _dotInterval = interval;
    [self setNeedsLayout];
}

- (void)setAnimating:(BOOL)animating
{
    if (animating) {
        [self startAnimate];
    } else {
        [self stopAnimate];
    }
}

- (NSInteger)totalSteps
{
    return kAnimationFrameNumber;
}

- (void)layoutSubviews
{
    [self udjustPointsPosition];
}

- (void)releaseFromPerformSelector
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - Private Method

- (void)setupUserInterface
{
    _points = [NSMutableArray arrayWithCapacity:kDotsNumber];
    UIImage *image = [UIImage imageNamed:@"ic_loadingOrange.png"];
    for (int i=0; i<kDotsNumber; i++) {
        UIImageView *point = [[UIImageView alloc] initWithFrame:CGRectZero];
        point.image = image;
        point.alpha = 0;
        [self addSubview:point];
        [_points addObject:point];
    }
}

- (void)udjustPointsPosition
{
    CGFloat width = _dotRadius*2;
    CGFloat height = width;
    CGFloat y = (CGRectGetHeight(self.frame)-height)/2;
    if (_dotInterval < 0) {
        _dotInterval = ((CGRectGetWidth(self.frame)-width*kDotsNumber) / (kDotsNumber*2)) * 2;
    }
    __block CGFloat x = ((CGRectGetWidth(self.frame)-width*kDotsNumber)-_dotInterval*(kDotsNumber-1)) / 2;
    [_points enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *point = obj;
        point.frame = CGRectMake(x, y, width, height);
        x += width+_dotInterval;
    }];
}

- (void)animate
{
    _cycleSteps = (kAnimationFrameNumber-1)/(kDotsNumber+1);
    _step = MIN(_firstStep, kAnimationFrameNumber);
    [self startAnimate];
}

- (void)startAnimate
{
    _animating = YES;
    [self animateStepByStep];
}

- (void)stopAnimate
{
    _animating = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateStepByStep) object:nil];
}

- (void)animateStepByStep
{
    if (!_animating) {
        return;
    }
    [self adjustPointsInStep:_step];
    _step = (_step+1) == kAnimationFrameNumber ? 0 : (_step+1);
    CGFloat speedInSecond;
    switch (_speed) {
        case SFPLoadingIndicatorSpeedQuick:
            speedInSecond = 0.02;
            break;
        default:
            speedInSecond = 0.035;
            break;
    }
    [self performSelector:@selector(animateStepByStep) withObject:nil afterDelay:speedInSecond];
}

- (void)adjustPointsInStep:(NSInteger)step
{
    __block NSInteger cycle = (step - 1) / _cycleSteps + 1;
    __block NSInteger stepInCycle = (step - 1) % _cycleSteps;
    [_points enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *point = obj;
        NSInteger fadeOutPointIndex = cycle - 2;
        NSInteger fadeInPointIndex = cycle - 1;
        if (idx == fadeInPointIndex) {
            point.alpha = 1.0 / _cycleSteps * stepInCycle;
        } else if (idx == fadeOutPointIndex) {
            point.alpha = 1.0 - 1.0 / (_cycleSteps+1) * stepInCycle;
        } else if (fadeOutPointIndex >= 0 && idx < fadeOutPointIndex) {
            point.alpha = 1.0 / _cycleSteps;
        } else {
            point.alpha = 0;
        }
    }];
}

@end
