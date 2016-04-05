//
//  WKAlignableImageView.m
//  WK
//
//  Created by Wei, Chengjiong on 12/23/2012.
//  Copyright (c) 2012 Wei, Chengjiong. All rights reserved.
//

#import "WKAlignableImageView.h"


@interface WKAlignableImageView ()
{
    UIImageView *_imageView;
}

@end


@implementation WKAlignableImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.clipsToBounds = YES;
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		_imageView.contentMode = UIViewContentModeScaleAspectFill;
		[self addSubview:_imageView];
    }
    return self;
}

- (void)awakeFromNib
{
	self.clipsToBounds = YES;
	_imageView = [[UIImageView alloc] initWithFrame:self.bounds];
	_imageView.contentMode = UIViewContentModeScaleAspectFill;
	[self addSubview:_imageView];
}

- (void)setImageURL:(NSString *)imageURL
{
    NSParameterAssert(imageURL);
    _imageURL = [imageURL copy];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                         timeoutInterval:60];
    __weak __typeof(&*self)weakSelf = self;
    [_imageView setImageWithURLRequest:request
                      placeholderImage:nil
                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                   [weakSelf setNeedsLayout];
                               }
                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                   [weakSelf setNeedsLayout];
                               }
     ];
}

- (void)layoutSubviews
{
    if (!_imageView.image) {
		return;
	}
	
	// compute scale factor for imageView
    CGFloat widthScaleFactor = CGRectGetWidth(self.bounds) / _imageView.image.size.width;
    CGFloat heightScaleFactor = CGRectGetHeight(self.bounds) / _imageView.image.size.height;
	
    CGFloat imageViewXOrigin = 0;
    CGFloat imageViewYOrigin = 0;
    CGFloat imageViewWidth;
    CGFloat imageViewHeight;
    
    if (widthScaleFactor > heightScaleFactor) {
		// if image is narrow and tall, scale to width and align vertically to the top
        imageViewWidth = _imageView.image.size.width * widthScaleFactor;
        imageViewHeight = _imageView.image.size.height * widthScaleFactor;
    } else {
		// else if image is wide and short, scale to height and align horizontally centered
        imageViewWidth = _imageView.image.size.width * heightScaleFactor;
        imageViewHeight = _imageView.image.size.height * heightScaleFactor;
        imageViewXOrigin = (CGRectGetWidth(self.bounds)-imageViewWidth)/2;
    }
	
	switch (self.imageAlignment) {
		case MIImageViewAlignmentTop:
		{
			imageViewYOrigin = 0;
		}
			break;
		case MIImageViewAlignmentCenter:
		{
			imageViewYOrigin = (self.bounds.size.height-imageViewHeight)/2;
		}
			break;
		case MIImageViewAlignmentBottom:
		{
			imageViewYOrigin = self.bounds.size.height-imageViewHeight;
		}
			break;
		default:
			break;
	}
	
    _imageView.frame = CGRectMake(imageViewXOrigin,
                                  imageViewYOrigin,
                                  imageViewWidth,
                                  imageViewHeight);
}

@end
