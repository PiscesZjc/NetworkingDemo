//
//  WKBarButtonUtil.m
//  WK
//
//  Created by Wei, Chengjiong on 8/24/12.
//  Copyright (c) 2012 Wei, Chengjiong. All rights reserved.
//

#import "WKBarButtonUtil.h"


@implementation WKBarButtonUtil

#pragma mark - Class Method

+ (UIBarButtonItem *)backButton4Controller:(UIViewController *)controller
{
    return [self backButton4Controller:controller.navigationController action:@selector(popupTopController)];
}

+ (UIBarButtonItem *)backButton4Controller:(UIViewController *)controller action:(SEL)action
{
    UIButton *innerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [innerButton setImage:[UIImage imageNamed:@"ic_back.png"] forState:UIControlStateNormal];
    [innerButton addTarget:controller action:action forControlEvents:UIControlEventTouchUpInside];
    [innerButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:innerButton];
    return barButton;
}

+ (UIBarButtonItem *)cancleButton4Controller:(UIViewController *)controller action:(SEL)action
{
    UIButton *innerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [innerButton setImage:[UIImage imageNamed:@"ic_cancle.png"] forState:UIControlStateNormal];
    [innerButton addTarget:controller action:action forControlEvents:UIControlEventTouchUpInside];
    [innerButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:innerButton];
    return barButton;
}

+ (UIBarButtonItem *)actionButton4Controller:(UIViewController *)controller action:(SEL)action
{
    UIButton *innerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [innerButton setImage:[UIImage imageNamed:@"btn_moreAction.png"] forState:UIControlStateNormal];
    [innerButton addTarget:controller action:action forControlEvents:UIControlEventTouchUpInside];
    if ([WKCommonUtil isAboveOS7]) {
        [innerButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -70)];
    } else {
        [innerButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -46)];
    }
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:innerButton];
    return barButton;
}

+ (UIBarButtonItem *)playerButton4Controller:(UIViewController *)controller action:(SEL)action
{
    UIButton *innerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [innerButton setImage:[UIImage imageNamed:@"icon_nowPlaying.png"] forState:UIControlStateNormal];
    [innerButton addTarget:controller action:action forControlEvents:UIControlEventTouchUpInside];
    if ([WKCommonUtil isAboveOS7]) {
        [innerButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -70)];
    } else {
        [innerButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -46)];
    }
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:innerButton];
    return barButton;
}

+ (UIBarButtonItem *)addButton4Controller:(UIViewController *)controller action:(SEL)action
{
    UIButton *innerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [innerButton setImage:[UIImage imageNamed:@"icon_add.png"] forState:UIControlStateNormal];
    [innerButton addTarget:controller action:action forControlEvents:UIControlEventTouchUpInside];
    if ([WKCommonUtil isAboveOS7]) {
        [innerButton setContentEdgeInsets:UIEdgeInsetsMake(0, -76, 0, 0)];
    } else {
        [innerButton setContentEdgeInsets:UIEdgeInsetsMake(0, -54, 0, 0)];
    }
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:innerButton];
    return barButton;
}

+ (UIBarButtonItem *)settingsButton4Controller:(UIViewController *)controller action:(SEL)action
{
    UIButton *innerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [innerButton setImage:[UIImage imageNamed:@"icon_setting.png"] forState:UIControlStateNormal];
    [innerButton addTarget:controller action:action forControlEvents:UIControlEventTouchUpInside];
    if ([WKCommonUtil isAboveOS7]) {
        [innerButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -76)];
    } else {
        [innerButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -54)];
    }
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:innerButton];
    return barButton;
}

+ (UIBarButtonItem *)textButton4Controller:(UIViewController *)controller action:(SEL)action title:(NSString *)title alignment:(WKBarButtonUtilContentAlignment)alignment
{
    UINib *nib = [UINib nibWithNibName:@"WKTextButton" bundle:nil];
    UIButton *innerButton = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    [innerButton addTarget:controller action:action forControlEvents:UIControlEventTouchUpInside];
    [innerButton setTitle:title forState:UIControlStateNormal];
    [innerButton setTitleColor:rgbColor(51, 51, 51) forState:UIControlStateNormal];
    [innerButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    switch (alignment) {
        case WKBarButtonUtilContentAlignmentLeft:
            if ([WKCommonUtil isAboveOS7]) {
                [innerButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
            } else {
                [innerButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 36)];
            }
            break;
        case WKBarButtonUtilContentAlignmentRight:
            if ([WKCommonUtil isAboveOS7]) {
                [innerButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -62)];
            } else {
                [innerButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 38, 0, 0)];
            }
            break;
        default:
            break;
    }
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:innerButton];
    return barButton;
}

+ (UIBarButtonItem *)barButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *innerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [innerButton setTitle:title forState:UIControlStateNormal];
    [innerButton setTitleColor:rgbColor(51, 51, 51) forState:UIControlStateNormal];
    [innerButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [innerButton setTitleEdgeInsets:UIEdgeInsetsMake(1, -15, -1, 0)];
    [innerButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:innerButton];
    return barButton;
}

+ (UIBarButtonItem *)barButtonWithTitleRight:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *innerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [innerButton setTitle:title forState:UIControlStateNormal];
    [innerButton setTitleColor:rgbColor(51, 51, 51) forState:UIControlStateNormal];
    [innerButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [innerButton setTitleEdgeInsets:UIEdgeInsetsMake(1, 0, -1, -25)];
    [innerButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:innerButton];
    return barButton;
}

+ (UIBarButtonItem *)barButtonWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    UIButton *innerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 28)];
    [innerButton setImage:image forState:UIControlStateNormal];
    [innerButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:innerButton];
    return barButton;
}

+ (void)setTitle:(NSString *)title button:(UIBarButtonItem *)button
{
    UIButton *innerButton = (UIButton *)button.customView;
    [innerButton setTitle:title forState:UIControlStateNormal];
}

@end
