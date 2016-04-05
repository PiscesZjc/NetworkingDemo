//
//  WKAlignableImageView.h
//  WK
//
//  Created by Wei, Chengjiong on 12/23/2012.
//  Copyright (c) 2012 Wei, Chengjiong. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
	MIImageViewAlignmentCenter = 0,
	MIImageViewAlignmentTop,
	MIImageViewAlignmentBottom,
} WKImageViewAlignment;


@interface WKAlignableImageView : UIView

@property (nonatomic) WKImageViewAlignment imageAlignment;
@property (nonatomic, copy) NSString *imageURL;

@end
