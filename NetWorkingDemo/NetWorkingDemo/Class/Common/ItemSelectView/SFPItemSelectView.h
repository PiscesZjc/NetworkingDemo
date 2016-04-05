//
//  SFPItemSelectView.h
//  SunFlowerProvider
//
//  Created by WeiChengjiong on 7/29/14.
//  Copyright (c) 2014 9Top. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SFPItemSelectView;

@protocol SFPItemSelectViewDelegate <NSObject>

- (void)itemView:(SFPItemSelectView *)itemSelectView didSelectedAtIndex:(NSUInteger)index;

@end

@protocol SFPItemSelectViewDataSource <NSObject>

- (NSUInteger)numberOfItemsInItemView:(SFPItemSelectView *)itemSelectView;
- (NSString *)itemView:(SFPItemSelectView *)itemSelectView titleAtIndex:(NSUInteger)index;

@end



@interface SFPItemSelectView : UIView

@property (nonatomic, weak) id<SFPItemSelectViewDelegate> delegate;
@property (nonatomic, weak) id<SFPItemSelectViewDataSource> dataSource;

@property (nonatomic, readonly) BOOL isShown;

+ (SFPItemSelectView *)showItemSeclectViewInView:(UIView *)view
                                        delegate:(id<SFPItemSelectViewDelegate>)delegate
                                      dataSource:(id<SFPItemSelectViewDataSource>)dataSource
                                             tag:(NSUInteger)tag;

+ (SFPItemSelectView *)showItemSeclectViewInKeyWindowWithRectView:(UIView *)view
                                                         delegate:(id<SFPItemSelectViewDelegate>)delegate
                                                       dataSource:(id<SFPItemSelectViewDataSource>)dataSource
                                                              tag:(NSUInteger)tag;

- (void)dismissItemSelectView;
- (void)dismissItemSelectViewWithCompletion:(void (^)(BOOL finished))completion;

+ (void)clearSelectors;

@end
