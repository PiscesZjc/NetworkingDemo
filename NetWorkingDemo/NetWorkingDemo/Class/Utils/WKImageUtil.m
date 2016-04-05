//
//  WKImageUtil.m
//  WK
//
//  Created by cwei on 13-9-27.
//  Copyright (c) 2013年 Wei, Chengjiong. All rights reserved.
//

#import "WKImageUtil.h"
#import "UIImage+ImageEffects.h"

@implementation WKImageUtil

+ (NSString *)imageName:(NSString *)name withSize:(WKImageSize)size
{
    if (!name) {
        return nil;
    }
    NSRange range = [name rangeOfString:@"." options:NSBackwardsSearch];
    NSString *firstPart = [name substringToIndex:range.location];
    NSString *suffix = [name substringFromIndex:range.location];
    if (!firstPart || !suffix) {
        return nil;
    }
    NSMutableString *newName = [NSMutableString stringWithString:firstPart];
    switch (size) {
        case WKImageSize640X640:
            [newName appendString:@"_640_640"];
            break;
        case WKImageSize640X640Blur:
            [newName appendString:@"_blur_640_640"];
            break;
        case WKImageSize424X424:
            [newName appendString:@"_424_424"];
            break;
        case WKImageSize208X208:
            [newName appendString:@"_208_208"];
            break;
        case WKImageSize80X80:
            [newName appendString:@"_80_80"];
            break;
        default:
            break;
    }
    [newName appendString:suffix];
    return newName;
}

+ (UIImage *)lightBlurImageInView:(UIView *)view rect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = newImage.CGImage;
    CGImageRef cropImageRef = CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *cropImage = [UIImage imageWithCGImage:cropImageRef];
    UIImage *blurImage = [cropImage applyLightEffect];
    return blurImage;
}

@end
