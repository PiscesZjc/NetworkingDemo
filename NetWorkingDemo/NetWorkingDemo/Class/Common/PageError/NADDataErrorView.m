//
//  SFPDataErrorView.m
//  SunFlowerProvider
//
//  Created by WeiChengjiong on 8/6/14.
//  Copyright (c) 2014 9Top. All rights reserved.
//

#import "NADDataErrorView.h"


@interface NADDataErrorView ()

@property (nonatomic) UIImageView *infoImage;
@property (nonatomic) UILabel *infoLabel;
@property (nonatomic) UIButton *refreshButton;
@property (nonatomic) UILabel *refreshLabel;

@end



@implementation NADDataErrorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // self
        self.backgroundColor = [UIColor clearColor];
        // info image
        _infoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_nothing.png"]];
        _infoImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_infoImage];
        _infoImage.translatesAutoresizingMaskIntoConstraints = NO;
        [WKCodingUtil setCenterXConstraintForView:_infoImage];
        [WKCodingUtil setFixWidthConstraintForView:_infoImage constant:75];
        [WKCodingUtil setFixHeightConstraintForView:_infoImage constant:160];
        [WKCodingUtil setCenterYOffsetConstraintForView:_infoImage constant:-50];
        // info label
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_infoLabel];
        _infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [WKCodingUtil setEdgeConstraintFromView:_infoLabel toSuperviewWithAttr:NSLayoutAttributeLeft constant:0];
        [WKCodingUtil setEdgeConstraintFromView:_infoLabel toSuperviewWithAttr:NSLayoutAttributeRight constant:0];
        [WKCodingUtil setFixHeightConstraintForView:_infoLabel constant:30];
        [WKCodingUtil setCenterYOffsetConstraintForView:_infoLabel constant:50];
        
        UIFont *font = [UIFont fontWithName:@"AdobeHeitiStd-Regular" size:12.0];//字
        _infoLabel.font = font;
        _infoLabel.textColor = rgbColor(153, 153, 153);
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return self;
}

+ (NADDataErrorView *)noDataViewInMyOrder
{
    NADDataErrorView *view = [[NADDataErrorView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 60)];
    view.infoImage.hidden = NO;
    view.infoLabel.text = @"您还没有订单，去下个单试试";
    return view;
}

+ (NADDataErrorView *)noDataViewInStaffList
{
    NADDataErrorView *view = [[NADDataErrorView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 60)];
    view.infoImage.hidden = NO;
    view.infoLabel.text = @"我们的技师很想为您服务，但是TA们很忙，亲，请更换服务时间，看看谁能为您服务";
    view.infoLabel.numberOfLines = 0;
    return view;
}

+ (NADDataErrorView *)noDataViewInMyCoupon
{
    NADDataErrorView *view = [[NADDataErrorView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 60)];
    view.infoImage.hidden = NO;
    view.infoLabel.text = @"没有找到优惠券";
    return view;
}

+ (NADDataErrorView *)errorDataView
{
    NADDataErrorView *view = [[NADDataErrorView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 60)];
    view.infoImage.hidden = NO;
    view.infoLabel.text = @"网络不给力，请下拉刷新";
    return view;
}

- (void)placeDataErrorViewinCenter:(UITableView *)view
{
    view.tableHeaderView = self;
}




@end
