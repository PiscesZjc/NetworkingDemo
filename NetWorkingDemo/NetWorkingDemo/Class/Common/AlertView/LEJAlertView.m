//
//  SFPAlertView.m
//  SunFlowerProvider
//
//  Created by WeiChengjiong on 9/16/14.
//  Copyright (c) 2014 9Top. All rights reserved.
//

#import "LEJAlertView.h"


#define kMaxWindowHeight 300
#define kMaxMessageHeight 200
#define kActiveInputFieldBottomSpace 24


static NSMutableArray *showedAlerts;


@interface LEJAlertView ()

@property (nonatomic, readwrite) UIView *messageView;
@property (nonatomic) NSLayoutConstraint *yOffsetConstraint;

@end


@implementation LEJAlertView

+ (LEJAlertView *)showAlertWithMessage:(NSString *)message
                              duration:(NSTimeInterval)duration
{
    UIView *container = [[UIView alloc] initWithFrame:AppContext.topMostView.bounds];
    container.backgroundColor = [UIColor clearColor];
    [AppContext.topMostView addSubview:container];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    [WKCodingUtil setEdgeConstraintFromView:container toSuperviewWithAttr:NSLayoutAttributeTop constant:0];
    [WKCodingUtil setEdgeConstraintFromView:container toSuperviewWithAttr:NSLayoutAttributeBottom constant:0];
    [WKCodingUtil setEdgeConstraintFromView:container toSuperviewWithAttr:NSLayoutAttributeLeading constant:0];
    [WKCodingUtil setEdgeConstraintFromView:container toSuperviewWithAttr:NSLayoutAttributeTrailing constant:0];
    
    UIFont *messageFont = [UIFont fontWithName:@"AdobeHeitiStd-Regular" size:14.0];
    CGSize maxSize = CGSizeMake(126, kMaxWindowHeight);
    CGRect constraintRect = [message boundingRectWithSize:maxSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                attributes:@{NSFontAttributeName:messageFont}
                                                   context:nil];
    CGFloat width = MAX(maxSize.width, ceil(CGRectGetWidth(constraintRect)));
    CGFloat height = ceil(CGRectGetHeight(constraintRect));
    
    LEJAlertView *alert = [[LEJAlertView alloc] initWithFrame:CGRectMake(0, 0, 210, height+80)];
    alert.backgroundColor = [UIColor clearColor];
    [container addSubview:alert];
    alert.translatesAutoresizingMaskIntoConstraints = NO;
    [WKCodingUtil setFixWidthConstraintForView:alert constant:210];
    [WKCodingUtil setFixHeightConstraintForView:alert constant:height+80];
    [WKCodingUtil setCenterXConstraintForView:alert];
    [WKCodingUtil setCenterYConstraintForView:alert];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:alert.bounds];
    bgView.image = [LEJAppUtil resizableImageByName:@"bg_Alert.png" capInsets:UIEdgeInsetsMake(19, 5, 19, 19)];
    
    [alert addSubview:bgView];
    bgView.translatesAutoresizingMaskIntoConstraints = NO;
    [WKCodingUtil setEdgeConstraintFromView:bgView toSuperviewWithAttr:NSLayoutAttributeTop constant:0];
    [WKCodingUtil setEdgeConstraintFromView:bgView toSuperviewWithAttr:NSLayoutAttributeBottom constant:0];
    [WKCodingUtil setEdgeConstraintFromView:bgView toSuperviewWithAttr:NSLayoutAttributeLeading constant:0];
    [WKCodingUtil setEdgeConstraintFromView:bgView toSuperviewWithAttr:NSLayoutAttributeTrailing constant:0];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 40, width, height)];
    messageLabel.text = message;
    messageLabel.font = messageFont;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    [alert addSubview:messageLabel];
    messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [WKCodingUtil setFixWidthConstraintForView:messageLabel constant:width];
    [WKCodingUtil setFixHeightConstraintForView:messageLabel constant:height];
    [WKCodingUtil setCenterXConstraintForView:messageLabel];
    [WKCodingUtil setCenterYConstraintForView:messageLabel];
    
    container.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        container.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:duration options:UIViewAnimationOptionLayoutSubviews animations:^{
            container.alpha = 0;
        } completion:^(BOOL finished) {
            [container removeFromSuperview];
        }];
    }];
    
    return alert;
}

+ (LEJAlertView *)showAlertWithTitle:(NSString *)title
                             message:(NSString *)message
                            delegate:(id<SFPAlertViewDelegate>)delegate
                             buttons:(NSArray *)buttonTitles
{
    UIFont *messageFont = [UIFont fontWithName:@"AdobeHeitiStd-Regular" size:14.0];
    CGSize maxSize = CGSizeMake(180, kMaxMessageHeight);
    CGRect constraintRect = [message boundingRectWithSize:maxSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                               attributes:@{NSFontAttributeName:messageFont}
                                                  context:nil];
    CGFloat width = MAX(maxSize.width, ceil(CGRectGetWidth(constraintRect)));
    CGFloat height = ceil(CGRectGetHeight(constraintRect));
    
    UILabel *messageView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height+60)];
    messageView.text = message;
    messageView.font = messageFont;
    messageView.textAlignment = NSTextAlignmentCenter;
    messageView.textColor = rgbColor(250, 250, 250);
    messageView.numberOfLines = 0;
    return [self showAlertWithTitle:title messageView:messageView delegate:delegate buttons:buttonTitles];
}

+ (LEJAlertView *)showAlertWithTitle:(NSString *)title
                         messageView:(UIView *)messageView
                            delegate:(id<SFPAlertViewDelegate>)delegate
                             buttons:(NSArray *)buttonTitles
{
    UIView *container = [[UIView alloc] initWithFrame:AppContext.topMostView.bounds];
    container.backgroundColor = rgbaColor(0, 0, 0, 0.4);
    [AppContext.topMostView addSubview:container];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    [WKCodingUtil setEdgeConstraintFromView:container toSuperviewWithAttr:NSLayoutAttributeTop constant:0];
    [WKCodingUtil setEdgeConstraintFromView:container toSuperviewWithAttr:NSLayoutAttributeBottom constant:0];
    [WKCodingUtil setEdgeConstraintFromView:container toSuperviewWithAttr:NSLayoutAttributeLeading constant:0];
    [WKCodingUtil setEdgeConstraintFromView:container toSuperviewWithAttr:NSLayoutAttributeTrailing constant:0];
    
    CGFloat alertWidth = 270;
    __block CGFloat alertHeight = 0;
    
    UILabel *titleLabel = nil;
    CWOnePixelHeightLine *line1 = nil;
    if (title.length > 0) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, alertWidth, 50)];
        titleLabel.text = title;
        titleLabel.font = [UIFont fontWithName:@"AdobeHeitiStd-Regular" size:15.0];
        titleLabel.textColor = rgbColor(250, 250, 250);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 1;
        alertHeight += CGRectGetHeight(titleLabel.frame);
        
        line1 = [[CWOnePixelHeightLine alloc] initWithFrame:CGRectMake(0, alertHeight, alertWidth, 1)];
        line1.backgroundColor = rgbColor(250, 250, 250);
        alertHeight += 1;
    }
    
    alertHeight += MIN(CGRectGetHeight(messageView.frame), kMaxMessageHeight);
    
    NSMutableArray *buttonsAndLines = [NSMutableArray arrayWithCapacity:buttonTitles.count*2];
    [buttonTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CWOnePixelHeightLine *line = [[CWOnePixelHeightLine alloc] initWithFrame:CGRectMake(0, 0, alertWidth, 1)];
        line.backgroundColor = rgbColor(250, 250, 250);
        [buttonsAndLines addObject:line];
        alertHeight += 1;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, alertWidth, 40)];
        [button setTitle:obj forState:UIControlStateNormal];
        UIFont *font = [UIFont fontWithName:@"AdobeHeitiStd-Regular" size:18.0];
        button.titleLabel.font = font;
        [button setTitleColor:rgbColor(250, 250, 250) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        button.tag = idx;
        [buttonsAndLines addObject:button];
        alertHeight += CGRectGetHeight(button.frame);
    }];
    
    LEJAlertView *alert = [[LEJAlertView alloc] initWithFrame:CGRectMake(0, 0, alertWidth, alertHeight)];
    alert.backgroundColor = [UIColor clearColor];
    [container addSubview:alert];
    alert.translatesAutoresizingMaskIntoConstraints = NO;
    [WKCodingUtil setFixWidthConstraintForView:alert constant:alertWidth];
    [WKCodingUtil setFixHeightConstraintForView:alert constant:alertHeight];
    [WKCodingUtil setCenterXConstraintForView:alert];
    alert.yOffsetConstraint = [WKCodingUtil setCenterYOffsetConstraintForView:alert constant:0];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:alert.bounds];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.image = [LEJAppUtil resizableImageByName:@"bg_Alert.png" capInsets:UIEdgeInsetsMake(9, 9, 9, 9)];
    [alert addSubview:bgView];
    bgView.translatesAutoresizingMaskIntoConstraints = NO;
    [WKCodingUtil setEdgeConstraintFromView:bgView toSuperviewWithAttr:NSLayoutAttributeTop constant:0];
    [WKCodingUtil setEdgeConstraintFromView:bgView toSuperviewWithAttr:NSLayoutAttributeBottom constant:0];
    [WKCodingUtil setEdgeConstraintFromView:bgView toSuperviewWithAttr:NSLayoutAttributeLeading constant:0];
    [WKCodingUtil setEdgeConstraintFromView:bgView toSuperviewWithAttr:NSLayoutAttributeTrailing constant:0];
    
    alertHeight = 0;
    if (titleLabel) {
        [alert addSubview:titleLabel];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [WKCodingUtil setEdgeConstraintFromView:titleLabel toSuperviewWithAttr:NSLayoutAttributeTop constant:alertHeight];
        [WKCodingUtil setEdgeConstraintFromView:titleLabel toSuperviewWithAttr:NSLayoutAttributeLeading constant:0];
        [WKCodingUtil setEdgeConstraintFromView:titleLabel toSuperviewWithAttr:NSLayoutAttributeTrailing constant:0];
        [WKCodingUtil setFixHeightConstraintForView:titleLabel constant:CGRectGetHeight(titleLabel.frame)];
        alertHeight += CGRectGetHeight(titleLabel.frame);
        
        [alert addSubview:line1];
        line1.translatesAutoresizingMaskIntoConstraints = NO;
        [WKCodingUtil setEdgeConstraintFromView:line1 toSuperviewWithAttr:NSLayoutAttributeTop constant:alertHeight];
        [WKCodingUtil setEdgeConstraintFromView:line1 toSuperviewWithAttr:NSLayoutAttributeLeading constant:0];
        [WKCodingUtil setEdgeConstraintFromView:line1 toSuperviewWithAttr:NSLayoutAttributeTrailing constant:0];
        [WKCodingUtil setFixHeightConstraintForView:line1 constant:CGRectGetHeight(line1.frame)];
        alertHeight += CGRectGetHeight(line1.frame);
    }
    
    [alert addSubview:messageView];
    messageView.translatesAutoresizingMaskIntoConstraints = NO;
    [WKCodingUtil setEdgeConstraintFromView:messageView toSuperviewWithAttr:NSLayoutAttributeTop constant:alertHeight];
    [WKCodingUtil setCenterXConstraintForView:messageView];
    [WKCodingUtil setFixWidthConstraintForView:messageView constant:CGRectGetWidth(messageView.frame)];
    [WKCodingUtil setFixHeightConstraintForView:messageView constant:MIN(CGRectGetHeight(messageView.frame), kMaxMessageHeight)];
    alertHeight += MIN(CGRectGetHeight(messageView.frame), kMaxMessageHeight);
    
    for (int i=0; i<buttonsAndLines.count; i+=2) {
        CWOnePixelHeightLine *line = buttonsAndLines[i];
        [alert addSubview:line];
        line.translatesAutoresizingMaskIntoConstraints = NO;
        [WKCodingUtil setEdgeConstraintFromView:line toSuperviewWithAttr:NSLayoutAttributeTop constant:alertHeight];
        [WKCodingUtil setEdgeConstraintFromView:line toSuperviewWithAttr:NSLayoutAttributeLeading constant:0];
        [WKCodingUtil setEdgeConstraintFromView:line toSuperviewWithAttr:NSLayoutAttributeTrailing constant:0];
        [WKCodingUtil setFixHeightConstraintForView:line constant:CGRectGetHeight(line.frame)];
        alertHeight += CGRectGetHeight(line.frame);
        
        UIButton *button = buttonsAndLines[i+1];
        [alert addSubview:button];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [WKCodingUtil setEdgeConstraintFromView:button toSuperviewWithAttr:NSLayoutAttributeTop constant:alertHeight];
        [WKCodingUtil setEdgeConstraintFromView:button toSuperviewWithAttr:NSLayoutAttributeLeading constant:0];
        [WKCodingUtil setEdgeConstraintFromView:button toSuperviewWithAttr:NSLayoutAttributeTrailing constant:0];
        [WKCodingUtil setFixHeightConstraintForView:button constant:CGRectGetHeight(button.frame)];
        alertHeight += CGRectGetHeight(button.frame);
        
        [button addTarget:alert action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    alert.messageView = messageView;
    alert.delegate = delegate;
    
    container.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        container.alpha = 1;
    } completion:NULL];
    
    if (!showedAlerts) {
        showedAlerts = [NSMutableArray array];
    }
    [showedAlerts addObject:container];
    
    return alert;
}

+ (void)clearAlerts
{
    [showedAlerts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *container = obj;
        [container removeFromSuperview];
    }];
    [showedAlerts removeAllObjects];
}

#pragma mark - Private Method

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (self.superview) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)buttonClicked:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [_delegate alertView:self clickedButtonAtIndex:button.tag];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.superview.alpha = 0;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
    
    [showedAlerts removeObject:self.superview];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    UIView *activeInputField = [self.messageView findFirstResponder];
    CGFloat heightOfScreen = [UIScreen mainScreen].bounds.size.height;
    CGFloat bottomSpace = heightOfScreen - CGRectGetMaxY([activeInputField convertRect:activeInputField.bounds toView:self.superview]);
    
    NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
    CGFloat keyboardHeight = CGRectGetHeight(keyboardBounds);
    
    if (keyboardHeight + kActiveInputFieldBottomSpace > bottomSpace) {
        CGFloat delta = keyboardHeight + kActiveInputFieldBottomSpace - bottomSpace;
        NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration:duration animations:^{
            self.yOffsetConstraint.constant -= delta;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.yOffsetConstraint.constant = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

@end
