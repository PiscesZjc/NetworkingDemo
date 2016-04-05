//
//  UIImage+Resize.h
//  WK
//
//  Created by Wei, Chengjiong on 12/23/2012.
//  Copyright (c) 2012 Wei, Chengjiong. All rights reserved.
//


// Extends the UIImage class to support resizing/cropping
@interface UIImage (Resize)

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                cropRect:(CGRect)cropRect
                             displaySize:(CGSize)displaySize
                    interpolationQuality:(CGInterpolationQuality)interpolationQuality;

// Code from AliSoftware
- (UIImage *)resizedImageToSize:(CGSize)dstSize;
- (UIImage *)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;

@end
