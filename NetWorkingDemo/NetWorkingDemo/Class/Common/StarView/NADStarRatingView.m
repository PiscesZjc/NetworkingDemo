//
//  TQStarRatingView.m
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//

#import "NADStarRatingView.h"
#define  SCORE 10.0
#define  COUNT 100

@interface NADStarRatingView ()

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;

@end

@implementation NADStarRatingView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numberOfStar:5];
}

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStar = number;
        self.starBackgroundView = [self buidlStarViewWithImageName:@"ic_starGray.png"];
        self.starForegroundView = [self buidlStarViewWithImageName:@"ic_starLighting.png"];
        [self addSubview:self.starBackgroundView];
        [self addSubview:self.starForegroundView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame score:(CGFloat)score
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStar = 5;
        self.starBackgroundView = [self buidlStarViewWithImageName:@"ic_starGray.png" ];
        self.starForegroundView = [self buidlStarViewWithImageName:@"ic_starLighting.png" ];
        [self addSubview:self.starBackgroundView];
        [self addSubview:self.starForegroundView];
        [self changeStarForegroundViewWithScore:score];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame couponCount:(NSUInteger)count
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStar = 1;
        self.starBackgroundView = [self buidlProcessViewWithImageName:@"bg_process.png" ];
        [self addSubview:self.starBackgroundView];
        self.starForegroundView.hidden = YES;
        if (count > 0) {
            self.starForegroundView.hidden = NO;
            self.starForegroundView = [self buidlProcessViewWithImageName:@"bg_processActive.png" ];
            [self addSubview:self.starForegroundView];
            [self changeTheForeGroundViewWithCount:count];
        }
        
    }
    return self;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point))
    {
        [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak NADStarRatingView * weekSelf = self;
    
    [UIView transitionWithView:self.starForegroundView
                      duration:0.2
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^
     {
         [weekSelf changeStarForegroundViewWithPoint:point];
     }
                    completion:^(BOOL finished)
     {
         
     }];
}

- (UIView *)buidlStarViewWithImageName:(NSString *)imageName
{
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < self.numberOfStar; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(i * frame.size.width / self.numberOfStar, 0, frame.size.width / self.numberOfStar, frame.size.height);
        [view addSubview:imageView];
    }
    return view;
}

- (void)changeStarForegroundViewWithPoint:(CGPoint)point
{
    CGPoint p = point;
    float width = self.frame.size.width/5;
    if (p.x < 0)
    {
        p.x = 0;
    }
    else if (p.x <= width ){
        p.x = width;
    }
    else if ((p.x > p.x/5) && p.x <= 2*width){
        p.x = 2*width;
    }
    else if (p.x > 2*width && p.x <= 3*width){
        p.x = 3*width;
    }
    else if (p.x > 3*width && p.x <= 4*width)
    {
        p.x = 4*width;
    }else{
        p.x = 5*width;
    }
    
    NSString * str = [NSString stringWithFormat:@"%0.1f",p.x / self.frame.size.width];
    float score = [str floatValue];
    p.x = score * self.frame.size.width;
    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)])
    {
        [self.delegate starRatingView:self score:score];
    }
}

- (void)changeStarForegroundViewWithScore:(CGFloat)score
{
    
    self.starForegroundView.frame = CGRectMake(0, 0, score*self.frame.size.width/SCORE, self.frame.size.height);
}

- (UIView *)buidlProcessViewWithImageName:(NSString *)imageName
{
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[LEJAppUtil resizableImageByName:imageName capInsets:UIEdgeInsetsMake(8, 8, 8, 6)]];
    imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [view addSubview:imageView];
    return view;
}

- (void)changeTheForeGroundViewWithCount:(NSUInteger)count
{
    self.starForegroundView.frame = CGRectMake(0, 0, count*self.frame.size.width/COUNT, self.frame.size.height);
}


@end
