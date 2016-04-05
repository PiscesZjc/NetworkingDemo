//
//  SFPLoadingSpinner.m
//  SunFlowerProvider
//
//  Created by WeiChengjiong on 7/31/14.
//  Copyright (c) 2014 9Top. All rights reserved.
//

#import "SFPLoadingSpinner.h"



#define kZoomInSteps 4
#define kZoomOutSteps 6

#define kDefaultRadius 20.0f
#define kMinRadius 5.0f

#define kDefaultDotCount 8
#define kMinDotCount 3
#define kMinDotRadius 3.0f
#define kMaxDotRadius 5.0f
#define kMinDotAlpha 0.05f
#define kMaxDotAlpha 1.0f


@interface SFPLoadingSpinner ()
{
    NSMutableArray *_points;
    NSMutableArray *_steps;
    NSInteger _step;
    BOOL _shouldAdjustDotPosition;
}

@end



@implementation SFPLoadingSpinner

+ (SFPLoadingSpinner *)loadingSpinner
{
    CGRect frame = CGRectMake(0, 0, kDefaultRadius, kDefaultRadius);
    SFPLoadingSpinner *spinner = [[SFPLoadingSpinner alloc] initWithFrame:frame];
    [spinner setupUserInterface];
    [spinner animate];
    return spinner;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _radius = kDefaultRadius;
        _dotCount = kDefaultDotCount;
    }
    return self;
}

- (void)reset
{
    [self stopAnimate];
    _step = 0;
    [_steps removeAllObjects];
    [_points enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *point = obj;
        point.alpha = 0;
        [_steps addObject:@(0)];
    }];
}

- (void)showIndicatorInStep:(NSInteger)step
{
    if (step < 0 || step >= self.totalSteps) {
        return;
    }
    [self adjustPointsInStep:step];
}

- (void)setRadius:(CGFloat)radius
{
    _radius = MAX(radius, kMinRadius);
    _shouldAdjustDotPosition = YES;
    [self setNeedsLayout];
}

- (void)setDotCount:(NSInteger)dotCount
{
    _dotCount = MAX(dotCount, kMinDotCount);
    // reset completely
    [self stopAnimate];
    _step = 0;
    [_points enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *point = obj;
        [point removeFromSuperview];
    }];
    // start new rounds
    [self setupUserInterface];
    [self animate];
}

- (void)setDotImage:(UIImage *)dotImage
{
    _dotImage = dotImage;
    [_points enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *point = obj;
        point.image = dotImage;
    }];
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
    return kZoomInSteps * _dotCount;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_shouldAdjustDotPosition) {
        _shouldAdjustDotPosition = NO;
        [self udjustPointsPosition];
    }
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
    _points = [NSMutableArray arrayWithCapacity:_dotCount];
    _steps = [NSMutableArray arrayWithCapacity:_dotCount];
    if (!_dotImage) {
        _dotImage = [UIImage imageNamed:@"ic_loadingOrange.png"];
    }
    for (int i=0; i<_dotCount; i++) {
        CGRect frame = CGRectMake(0, 0, kMinDotRadius*2, kMinDotRadius*2);
        UIImageView *point = [[UIImageView alloc] initWithFrame:frame];
        point.contentMode = UIViewContentModeScaleAspectFit;
        point.image = _dotImage;
        point.alpha = kMinDotAlpha;
        [self addSubview:point];
        point.translatesAutoresizingMaskIntoConstraints = NO;
        [WKCodingUtil setFixWidthConstraintForView:point constant:CGRectGetWidth(point.frame)];
        [WKCodingUtil setFixHeightConstraintForView:point constant:CGRectGetHeight(point.frame)];
        [WKCodingUtil setCenterXOffsetConstraintForView:point constant:0];
        [WKCodingUtil setCenterYOffsetConstraintForView:point constant:0];
        [_points addObject:point];
        [_steps addObject:@(0)];
    }
    _shouldAdjustDotPosition = YES;
}

- (void)udjustPointsPosition
{
    // adjust frame rect
    CGFloat width = _radius*2 + kMaxDotRadius*2;
    CGFloat height = width;
    NSLayoutConstraint *widthConstraint = [self.superview constraintForAttribute:NSLayoutAttributeWidth withView:self];
    widthConstraint.constant = width;
    NSLayoutConstraint *heightConstraint = [self.superview constraintForAttribute:NSLayoutAttributeHeight withView:self];
    heightConstraint.constant = height;
    
    // place dots in a circle
    CGFloat angle = (360.0 / _dotCount) * (M_PI / 180.0);
    [_points enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *point = obj;
        NSLayoutConstraint *xConstraint = [point.superview constraintForAttribute:NSLayoutAttributeCenterX withView:point];
        xConstraint.constant = _radius * cos(M_PI_2 - angle*idx);
        NSLayoutConstraint *yConstraint = [point.superview constraintForAttribute:NSLayoutAttributeCenterY withView:point];
        yConstraint.constant = - _radius * sin(M_PI_2 - angle*idx);
    }];
    [self layoutIfNeeded];
}

- (void)animate
{
    _step = 0;
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
    _step = (_step+1) == self.totalSteps ? 0 : (_step+1);
    CGFloat speedInSecond;
    switch (_speed) {
        case SFPLoadingSpinnerSpeedQuick:
            speedInSecond = 0.015;
            break;
        default:
            speedInSecond = 0.03;
            break;
    }
    [self performSelector:@selector(animateStepByStep) withObject:nil afterDelay:speedInSecond];
}

- (void)adjustPointsInStep:(NSInteger)step
{
    __block CGFloat zoomInAlphaDelta = (kMaxDotAlpha - kMinDotAlpha) / (kZoomInSteps);
    __block CGFloat zoomOutAlphaDelta = (kMaxDotAlpha - kMinDotAlpha) / (kZoomOutSteps);
    __block CGFloat zoomInRadiusDelta = (kMaxDotRadius - kMinDotRadius) / (kZoomInSteps);
    __block CGFloat zoomOutRadiusDelta = (kMaxDotRadius - kMinDotRadius) / (kZoomOutSteps);
    __block NSInteger zoomInPointIndex = step / kZoomInSteps;
    [_points enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *point = obj;
        NSInteger pointStep = [(NSNumber *)_steps[idx] integerValue];
        if (idx == zoomInPointIndex) {
            // zoom in
            NSInteger zoomInStartStep = idx * kZoomInSteps;
            point.alpha += zoomInAlphaDelta;
            NSInteger stepDelta = (step - zoomInStartStep) < 0 ? (step - zoomInStartStep + self.totalSteps) : (step - zoomInStartStep);
            CGFloat radiusMagify = (kMinDotRadius + zoomInRadiusDelta * stepDelta) / kMinDotRadius;
            point.transform = CGAffineTransformMakeScale(radiusMagify, radiusMagify);
            _steps[idx] = @(pointStep+1==(kZoomInSteps+kZoomOutSteps) ? 0 : pointStep+1);
        } else {
            if (pointStep > 0) {
                // zoom out
                NSInteger zoomOutStartStep = (idx+1) * kZoomInSteps;
                point.alpha -= zoomOutAlphaDelta;
                NSInteger stepDelta = (step - zoomOutStartStep) < 0 ? (step - zoomOutStartStep + self.totalSteps) : (step - zoomOutStartStep);
                CGFloat radiusMagify = (kMaxDotRadius - zoomOutRadiusDelta * stepDelta) / kMinDotRadius;
                point.transform = CGAffineTransformMakeScale(radiusMagify, radiusMagify);
                _steps[idx] = @(pointStep+1==(kZoomInSteps+kZoomOutSteps) ? 0 : pointStep+1);
            }
        }
    }];
}

@end
