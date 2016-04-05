//
//  WKUIView.h
//  WK
//
//  Created by Wei, Chengjiong on 8/24/12.
//  Copyright (c) 2012 Wei, Chengjiong. All rights reserved.
//

#import <UIKit/UIKit.h>

/* It is troublesome to subclass the UIView when you only want to customize the drawRect method */

@class WKUIView;

@interface NSObject (WKUIView)

- (void)view:(WKUIView *)view drawRect:(CGRect)rect;

@end

@interface WKUIView : UIView

@property (nonatomic, assign) NSObject *drawDelegate;
@property (nonatomic) BOOL shouldNotHidden;


@end
