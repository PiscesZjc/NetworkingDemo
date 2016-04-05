//
//  SFPItemSelectView.m
//  SunFlowerProvider
//
//  Created by WeiChengjiong on 7/29/14.
//  Copyright (c) 2014 9Top. All rights reserved.
//

#import "SFPItemSelectView.h"


#define kCellHeight 44


static NSMutableArray *showedSelectors;


@interface SFPItemSelectView () <UITableViewDelegate, UITableViewDataSource>
{
    BOOL _isAnimating;
}

@property (nonatomic) UIView *maskView;
@property (nonatomic) UITableView *itemsTable;
@property (nonatomic) UIView *contentView;
@property (nonatomic) NSLayoutConstraint *heightConstraint;
@property (nonatomic) NSLayoutConstraint *topConstraint;

@end

@implementation SFPItemSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // self
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        // mask
        _maskView = [[UIView alloc] initWithFrame:CGRectZero];
        _maskView.backgroundColor = rgbaColor(0, 0, 0, 0.4);
        [self addSubview:_maskView];
        _maskView.translatesAutoresizingMaskIntoConstraints = NO;
        [WKCodingUtil setEdgeConstraintFromView:_maskView toSuperviewWithAttr:NSLayoutAttributeTop constant:0];
        [WKCodingUtil setEdgeConstraintFromView:_maskView toSuperviewWithAttr:NSLayoutAttributeBottom constant:0];
        [WKCodingUtil setEdgeConstraintFromView:_maskView toSuperviewWithAttr:NSLayoutAttributeLeft constant:0];
        [WKCodingUtil setEdgeConstraintFromView:_maskView toSuperviewWithAttr:NSLayoutAttributeRight constant:0];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissItemSelectView)];
        [_maskView addGestureRecognizer:tapGesture];
        // content view
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _heightConstraint = [WKCodingUtil setFixHeightConstraintForView:_contentView constant:0];
        _topConstraint = [WKCodingUtil setEdgeConstraintFromView:_contentView toSuperviewWithAttr:NSLayoutAttributeTop constant:0];
        [WKCodingUtil setEdgeConstraintFromView:_contentView toSuperviewWithAttr:NSLayoutAttributeLeft constant:0];
        [WKCodingUtil setEdgeConstraintFromView:_contentView toSuperviewWithAttr:NSLayoutAttributeRight constant:0];
        // table
        _itemsTable = [[UITableView alloc] initWithFrame:CGRectZero];
        _itemsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _itemsTable.delegate = self;
        _itemsTable.dataSource = self;
        [_contentView addSubview:_itemsTable];
        _itemsTable.translatesAutoresizingMaskIntoConstraints = NO;
        [WKCodingUtil setEdgeConstraintFromView:_itemsTable toSuperviewWithAttr:NSLayoutAttributeTop constant:0];
        [WKCodingUtil setEdgeConstraintFromView:_itemsTable toSuperviewWithAttr:NSLayoutAttributeBottom constant:0];
        [WKCodingUtil setEdgeConstraintFromView:_itemsTable toSuperviewWithAttr:NSLayoutAttributeLeft constant:0];
        [WKCodingUtil setEdgeConstraintFromView:_itemsTable toSuperviewWithAttr:NSLayoutAttributeRight constant:0];
    }
    return self;
}

#pragma mark - Public Method

+ (SFPItemSelectView *)showItemSeclectViewInView:(UIView *)view
                                        delegate:(id<SFPItemSelectViewDelegate>)delegate
                                      dataSource:(id<SFPItemSelectViewDataSource>)dataSource
                                             tag:(NSUInteger)tag
{
    SFPItemSelectView *itemView = [[SFPItemSelectView alloc] initWithFrame:CGRectZero];
    itemView.tag = tag;
    itemView.delegate = delegate;
    itemView.dataSource = dataSource;
    [itemView showInView:view inRect:view.bounds];
    return itemView;
}

+ (SFPItemSelectView *)showItemSeclectViewInKeyWindowWithRectView:(UIView *)view
                                                         delegate:(id<SFPItemSelectViewDelegate>)delegate
                                                       dataSource:(id<SFPItemSelectViewDataSource>)dataSource
                                                              tag:(NSUInteger)tag
{
    SFPItemSelectView *itemView = [[SFPItemSelectView alloc] initWithFrame:CGRectZero];
    itemView.tag = tag;
    itemView.delegate = delegate;
    itemView.dataSource = dataSource;
    UIView *superView = [[UIApplication sharedApplication] keyWindow];
    [itemView showInView:superView inRect:[view convertRect:view.bounds toView:superView]];
    return itemView;
}

- (void)dismissItemSelectView
{
    [self dismissItemSelectViewWithCompletion:NULL];
}

- (void)dismissItemSelectViewWithCompletion:(void (^)(BOOL finished))completion
{
    CGFloat heightDelta = CGRectGetHeight(self.frame);
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.alpha = 0;
        _topConstraint.constant = -heightDelta;
        _maskView.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _isShown = NO;
        if (completion) {
            completion(YES);
        }
    }];
    [showedSelectors removeObject:self];
}

+ (void)clearSelectors
{
    [showedSelectors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *selector = obj;
        [selector removeFromSuperview];
    }];
    [showedSelectors removeAllObjects];
}

#pragma mark - TableView Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource numberOfItemsInItemView:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const reuseIdentifier = @"SFPItemSelectViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [cell.contentView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [(UIView *)obj removeFromSuperview];
        }];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
        titleLabel.tag = 1;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:titleLabel];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [WKCodingUtil setEdgeConstraintFromView:titleLabel toSuperviewWithAttr:NSLayoutAttributeTop constant:0];
        [WKCodingUtil setEdgeConstraintFromView:titleLabel toSuperviewWithAttr:NSLayoutAttributeBottom constant:0];
        [WKCodingUtil setEdgeConstraintFromView:titleLabel toSuperviewWithAttr:NSLayoutAttributeLeft constant:0];
        [WKCodingUtil setEdgeConstraintFromView:titleLabel toSuperviewWithAttr:NSLayoutAttributeRight constant:0];
        
        CWOnePixelHeightLine *line = [[CWOnePixelHeightLine alloc] initWithFrame:CGRectZero];
        line.backgroundColor = rgbColor(213, 213, 213);
        line.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addSubview:line];
        [WKCodingUtil setFixHeightConstraintForView:line constant:1];
        [WKCodingUtil setEdgeConstraintFromView:line toSuperviewWithAttr:NSLayoutAttributeTop constant:0];
        [WKCodingUtil setEdgeConstraintFromView:line toSuperviewWithAttr:NSLayoutAttributeLeft constant:0];
        [WKCodingUtil setEdgeConstraintFromView:line toSuperviewWithAttr:NSLayoutAttributeRight constant:0];
    }
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    titleLabel.text = [_dataSource itemView:self titleAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate itemView:self didSelectedAtIndex:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissItemSelectView];
}

#pragma mark - Private Method

- (void)showInView:(UIView *)view inRect:(CGRect)rect
{
    _isShown = YES;
    // self
    [view addSubview:self];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [WKCodingUtil setFixWidthConstraintForView:self constant:CGRectGetWidth(rect)];
    [WKCodingUtil setCenterXConstraintForView:self];
    [WKCodingUtil setEdgeConstraintFromView:self toSuperviewWithAttr:NSLayoutAttributeTop constant:CGRectGetMinY(rect)];
    [WKCodingUtil setFixHeightConstraintForView:self constant:CGRectGetHeight(rect)];
    
    // content view
    _maskView.alpha = 0;
    _contentView.alpha = 0;
    CGFloat height = MIN(kCellHeight * [_dataSource numberOfItemsInItemView:self], CGRectGetHeight(rect));
    _heightConstraint.constant = height;
    CGFloat heightDelta = CGRectGetHeight(rect);
    _topConstraint.constant = -heightDelta;
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.alpha = 1;
        _topConstraint.constant = 0;
        [self layoutIfNeeded];
        _maskView.alpha = 1;
    } completion:NULL];
    
    if (!showedSelectors) {
        showedSelectors = [NSMutableArray array];
    }
    [showedSelectors addObject:self];
}

@end
