//
//  WKImageUtil.h
//  WK
//
//  Created by cwei on 13-9-27.
//  Copyright (c) 2013年 Wei, Chengjiong. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    WKImageSize640X640 = 0,
    WKImageSize640X640Blur,
    WKImageSize424X424,
    WKImageSize208X208,
    WKImageSize80X80,
} WKImageSize;


@interface WKImageUtil : NSObject

+ (NSString *)imageName:(NSString *)name withSize:(WKImageSize)size;
+ (UIImage *)lightBlurImageInView:(UIView *)view rect:(CGRect)rect; // iOS7+ only!

@end
