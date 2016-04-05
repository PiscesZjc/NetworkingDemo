//
//  SFPDataErrorView.h
//  SunFlowerProvider
//
//  Created by WeiChengjiong on 8/6/14.
//  Copyright (c) 2014 9Top. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NADDataErrorView : UIView

+ (NADDataErrorView *)noDataViewInMyOrder;
+ (NADDataErrorView *)noDataViewInMyCoupon;
+ (NADDataErrorView *)noDataViewInStaffList;
+ (NADDataErrorView *)errorDataView;

- (void)placeDataErrorViewinCenter:(UITableView *)view;

@end
