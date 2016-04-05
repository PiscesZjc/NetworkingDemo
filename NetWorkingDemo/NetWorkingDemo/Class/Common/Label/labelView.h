//
//  labelView.h
//  LabelAlignment
//
//  Created by zjc on 15/8/12.
//  Copyright (c) 2015年 demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface labelView : UILabel
/**
 *label右对齐
 */
+ (UILabel*)changeTheLabelConstraint:(UILabel*)label content:(NSString*)labelContent;

/**
 *view中带着lable，lable带着背景
 */
+(UIView*)lableWithBackGround:(CGRect)frame content:(NSString*)content font:(UIFont*)font bgImageName:(NSString*)bgImageName;

/**
 *label带下划线
 */
+(UILabel*)lableWithUnderline:(UILabel*)lable;

@end
