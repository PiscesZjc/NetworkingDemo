//
//  UIImage+Retina4.m
//  StunOMatic
//
//  Created by Benjamin Stahlhood on 9/12/12.
//  Copyright (c) 2012 DS Media Labs. All rights reserved.
//

#import "UIImage+Retina4.h"
#import <objc/runtime.h>
#import <objc/message.h>


@implementation UIImage (Retina4)

+ (void)initialize {
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        Method origImageNamedMethod = class_getClassMethod(self, @selector(imageNamed:));
        method_exchangeImplementations(origImageNamedMethod,
                                       class_getClassMethod(self, @selector(retina4ImageNamed:)));
    });
}

+ (UIImage *)retina4ImageNamed:(NSString *)imageName {
//    DDLogVerbose(@"Loading image named => %@", imageName);
    NSMutableString *imageNameMutable = [imageName mutableCopy];
    NSRange retinaAtSymbol = [imageName rangeOfString:@"@"];
    if (retinaAtSymbol.location == NSNotFound) {
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
            NSRange dot = [imageName rangeOfString:@"."];
            if (dot.location != NSNotFound) {
                [imageNameMutable insertString:@"-568h@2x" atIndex:dot.location];
            } else {
                [imageNameMutable appendString:@"-568h@2x"];
            }
        } else if ([UIScreen mainScreen].scale == 2.f && screenHeight == 667.0f){
            NSRange dot = [imageName rangeOfString:@"."];
            if (dot.location != NSNotFound) {
                [imageNameMutable insertString:@"-800-667h@2x" atIndex:dot.location];
            } else {
                [imageNameMutable appendString:@"-800-667h@2x"];
            }
        } else if ([UIScreen mainScreen].scale == 3.f && screenHeight == 768.0f){
            NSRange dot = [imageName rangeOfString:@"."];
            if (dot.location != NSNotFound) {
                [imageNameMutable insertString:@"-800-736h@3x" atIndex:dot.location];
            } else {
                [imageNameMutable appendString:@"-800-736h@3x"];
            }
        }
    }
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageNameMutable ofType:@""];
    if (imagePath) {
        return [UIImage retina4ImageNamed:imageNameMutable];
    } else {
        return [UIImage retina4ImageNamed:imageName];
    }
    return nil;
}

@end