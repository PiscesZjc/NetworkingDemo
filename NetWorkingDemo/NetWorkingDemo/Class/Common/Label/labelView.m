//
//  labelView.m
//  LabelAlignment
//
//  Created by zjc on 15/8/12.
//  Copyright (c) 2015年 demo. All rights reserved.
//

#import "labelView.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@implementation labelView

+ (UILabel*)changeTheLabelConstraint:(UILabel*)label content:(NSString*)labelContent
{
    CGSize constraintSize = CGSizeMake(SCREEN_WIDTH, 3000);
    CGSize labelSize;
    CGRect textRect = [labelContent boundingRectWithSize:constraintSize
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:label.font}
                                                 context:nil];
    CGFloat maxWidth = label.frame.origin.x + CGRectGetWidth(label.frame);
    labelSize = textRect.size;
    CGFloat width = ceil(labelSize.width);
    
    if (maxWidth < width) {
        width = maxWidth;
    }
    
    NSArray* constrains = label.constraints;
    for (NSLayoutConstraint* constraint in constrains) {
        if (constraint.firstAttribute == NSLayoutAttributeWidth) {
            constraint.constant = width;
            break;
        }
        
    }
    
    label.text = labelContent;
    
    
    return label;
}

+(UIView*)lableWithBackGround:(CGRect)frame content:(NSString*)content font:(UIFont*)font bgImageName:(NSString*)bgImageName;
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [LEJAppUtil resizableImageByName:bgImageName capInsets:UIEdgeInsetsMake(8, 6, 8, 8)];
    [view addSubview:imageView];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [WKCodingUtil setEdgeConstraintFromView:imageView toSuperviewWithAttr:NSLayoutAttributeTop constant:0];
    [WKCodingUtil setEdgeConstraintFromView:imageView toSuperviewWithAttr:NSLayoutAttributeBottom constant:0];
    [WKCodingUtil setEdgeConstraintFromView:imageView toSuperviewWithAttr:NSLayoutAttributeLeft constant:0];
    [WKCodingUtil setEdgeConstraintFromView:imageView toSuperviewWithAttr:NSLayoutAttributeRight constant:0];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:frame];
    lable.text = content;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.lineBreakMode = NSLineBreakByTruncatingTail;
    lable.font = font;
    lable.numberOfLines = 0;
    lable.textColor = [UIColor whiteColor];
    [view addSubview:lable];
    lable.translatesAutoresizingMaskIntoConstraints = NO;
    [WKCodingUtil setEdgeConstraintFromView:lable toSuperviewWithAttr:NSLayoutAttributeTop constant:3];
    [WKCodingUtil setEdgeConstraintFromView:lable toSuperviewWithAttr:NSLayoutAttributeLeft constant:0];
    [WKCodingUtil setEdgeConstraintFromView:lable toSuperviewWithAttr:NSLayoutAttributeRight constant:0];
    [WKCodingUtil setFixHeightConstraintForView:lable constant:frame.size.height];
    
    return view;
    
}

+(UILabel*)lableWithUnderline:(UILabel*)lable
{
    NSUInteger length = [lable.text length];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:lable.text];
    [attri addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle),
                           NSStrikethroughColorAttributeName:lable.textColor} range:NSMakeRange(0, length)];
    [lable setAttributedText:attri];
    return lable;
}



@end
