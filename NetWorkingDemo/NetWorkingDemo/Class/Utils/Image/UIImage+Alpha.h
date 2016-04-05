//
//  UIImage+Alpha.h
//  WK
//
//  Created by Wei, Chengjiong on 12/23/2012.
//  Copyright (c) 2012 Wei, Chengjiong. All rights reserved.
//

// Helper methods for adding an alpha layer to an image

@interface UIImage (Alpha)

- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;

@end
