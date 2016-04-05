//
//  TQStarRatingView.h
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NADStarRatingView;

@protocol StarRatingViewDelegate <NSObject>

@optional
-(void)starRatingView:(NADStarRatingView *)view score:(float)score;

@end

@interface NADStarRatingView : UIView

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number;
- (id)initWithFrame:(CGRect)frame score:(CGFloat)score;
- (id)initWithFrame:(CGRect)frame couponCount:(NSUInteger)count;
@property (nonatomic, readonly) int numberOfStar;
@property (nonatomic, weak) id <StarRatingViewDelegate> delegate;

@end
