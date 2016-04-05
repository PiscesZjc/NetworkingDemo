//
//  UIImage+Resize.m
//  WK
//
//  Created by Wei, Chengjiong on 12/23/2012.
//  Copyright (c) 2012 Wei, Chengjiong. All rights reserved.
//

#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+Alpha.h"


@implementation UIImage (Resize)

+ (CGRect)sourceRectWithImageSize:(CGSize)imageSize
                      displaySize:(CGSize)displaySize
                      contentMode:(UIViewContentMode)contentMode
{
    if (UIViewContentModeScaleToFill == contentMode) {
        // Scale to fill draws the original image by squashing it to fit the destination's
        // aspect ratio, so the source and destination rects aren't modified.
        return CGRectMake(0, 0, imageSize.width, imageSize.height);
        
    } else if (UIViewContentModeScaleAspectFit == contentMode) {
        // Aspect fit grabs the entire original image and squashes it down to a frame that fits
        // the destination and leaves the unfilled space transparent.
        return CGRectMake(0, 0, imageSize.width, imageSize.height);
        
    } else if (UIViewContentModeScaleAspectFill == contentMode) {
        // Aspect fill requires that we take the destination rectangle and "fit" it within the
        // source rectangle; this gives us the area of the source image we'll crop out to draw into
        // the destination image.
        CGFloat scale = MIN(imageSize.width / displaySize.width,
                            imageSize.height / displaySize.height);
        CGSize scaledDisplaySize = CGSizeMake(displaySize.width * scale, displaySize.height * scale);
        return CGRectMake(floorf((imageSize.width - scaledDisplaySize.width) / 2),
                          floorf((imageSize.height - scaledDisplaySize.height) / 2),
                          scaledDisplaySize.width,
                          scaledDisplaySize.height);
        
    } else if (UIViewContentModeCenter == contentMode) {
        // We need to cut out a hole the size of the display in the center of the source image.
        return CGRectMake(floorf((imageSize.width - displaySize.width) / 2),
                          floorf((imageSize.width - displaySize.width) / 2),
                          displaySize.width, displaySize.height);
        
    } else if (UIViewContentModeTop == contentMode) {
        // We need to cut out a hole the size of the display in the top center of the source image.
        return CGRectMake(floorf((imageSize.width - displaySize.width) / 2),
                          0,
                          displaySize.width, displaySize.height);
        
    } else if (UIViewContentModeBottom == contentMode) {
        // We need to cut out a hole the size of the display in the bottom center of the source image.
        return CGRectMake(floorf((imageSize.width - displaySize.width) / 2),
                          imageSize.height - displaySize.height,
                          displaySize.width, displaySize.height);
        
    } else if (UIViewContentModeLeft == contentMode) {
        // We need to cut out a hole the size of the display in the left center of the source image.
        return CGRectMake(0,
                          floorf((imageSize.width - displaySize.width) / 2),
                          displaySize.width, displaySize.height);
        
    } else if (UIViewContentModeRight == contentMode) {
        // We need to cut out a hole the size of the display in the right center of the source image.
        return CGRectMake(imageSize.width - displaySize.width,
                          floorf((imageSize.width - displaySize.width) / 2),
                          displaySize.width, displaySize.height);
        
    } else if (UIViewContentModeTopLeft == contentMode) {
        // We need to cut out a hole the size of the display in the top left of the source image.
        return CGRectMake(0,
                          0,
                          displaySize.width, displaySize.height);
        
    } else if (UIViewContentModeTopRight == contentMode) {
        // We need to cut out a hole the size of the display in the top right of the source image.
        return CGRectMake(imageSize.width - displaySize.width,
                          0,
                          displaySize.width, displaySize.height);
        
    } else if (UIViewContentModeBottomLeft == contentMode) {
        // We need to cut out a hole the size of the display in the bottom left of the source image.
        return CGRectMake(0,
                          imageSize.height - displaySize.height,
                          displaySize.width, displaySize.height);
        
    } else if (UIViewContentModeBottomRight == contentMode) {
        // We need to cut out a hole the size of the display in the bottom right of the source image.
        return CGRectMake(imageSize.width - displaySize.width,
                          imageSize.height - displaySize.height,
                          displaySize.width, displaySize.height);
        
    } else {
        // Not implemented
        return CGRectMake(0, 0, imageSize.width, imageSize.height);
    }
}

/**
 * Calculate the destination rect in the destination image where we will draw the cropped source
 * image.
 */
+ (CGRect)destinationRectWithImageSize:(CGSize)imageSize
                           displaySize:(CGSize)displaySize
                           contentMode:(UIViewContentMode)contentMode
{
    if (UIViewContentModeScaleAspectFit == contentMode) {
        // Fit the image right in the center of the source frame and maintain the aspect ratio.
        CGFloat scale = MIN(displaySize.width / imageSize.width,
                            displaySize.height / imageSize.height);
        CGSize scaledImageSize = CGSizeMake(imageSize.width * scale, imageSize.height * scale);
        return CGRectMake(floorf((displaySize.width - scaledImageSize.width) / 2),
                          floorf((displaySize.height - scaledImageSize.height) / 2),
                          scaledImageSize.width,
                          scaledImageSize.height);
        
    } else if (UIViewContentModeScaleToFill == contentMode
               || UIViewContentModeScaleAspectFill == contentMode
               || UIViewContentModeCenter == contentMode
               || UIViewContentModeTop == contentMode
               || UIViewContentModeBottom == contentMode
               || UIViewContentModeLeft == contentMode
               || UIViewContentModeRight == contentMode
               || UIViewContentModeTopLeft == contentMode
               || UIViewContentModeTopRight == contentMode
               || UIViewContentModeBottomLeft == contentMode
               || UIViewContentModeBottomRight == contentMode) {
        // We're filling the entire destination, so the destination rect is the display rect.
        return CGRectMake(0, 0, displaySize.width, displaySize.height);
        
    } else {
        // Not implemented
        return CGRectMake(0, 0, displaySize.width, displaySize.height);
    }
}

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                cropRect:(CGRect)cropRect
                             displaySize:(CGSize)displaySize
                    interpolationQuality:(CGInterpolationQuality)interpolationQuality
{
    UIImage *resultImage = self;
    
    CGImageRef srcImageRef = self.CGImage;
    CGImageRef croppedImageRef = nil;
    CGImageRef trimmedImageRef = nil;
    
    CGRect srcRect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    // Cropping
    if (!CGRectIsEmpty(cropRect)
        && !CGRectEqualToRect(cropRect, CGRectMake(0, 0, 1, 1))) {
        CGRect innerRect = CGRectMake(floorf(self.size.width * cropRect.origin.x),
                                      floorf(self.size.height * cropRect.origin.y),
                                      floorf(self.size.width * cropRect.size.width),
                                      floorf(self.size.height * cropRect.size.height));
        
        // Create a new image containing only the cropped inner rect.
        srcImageRef = CGImageCreateWithImageInRect(srcImageRef, innerRect);
        croppedImageRef = srcImageRef;
        
        // This new image will likely have a different width and height, so we have to update
        // the source rect as a result.
        srcRect = CGRectMake(0, 0,
                             CGRectGetWidth(innerRect),
                             CGRectGetHeight(innerRect));
    }
    
    // Display
    if (0 < displaySize.width
        && 0 < displaySize.height) {
        
        if (UIViewContentModeScaleAspectFill == contentMode) {
            // Make the display size match the aspect ratio of the source image by growing the
            // display size.
            CGFloat imageAspectRatio = srcRect.size.width / srcRect.size.height;
            CGFloat displayAspectRatio = displaySize.width / displaySize.height;
            
            if (imageAspectRatio > displayAspectRatio) {
                // The image is wider than the display, so let's increase the width.
                displaySize.width = displaySize.height * imageAspectRatio;
                
            } else if (imageAspectRatio < displayAspectRatio) {
                // The image is taller than the display, so let's increase the height.
                displaySize.height = displaySize.width * (srcRect.size.height / srcRect.size.width);
            }
            
        } else if (UIViewContentModeScaleAspectFit == contentMode) {
            // Make the display size match the aspect ratio of the source image by shrinking the
            // display size.
            CGFloat imageAspectRatio = srcRect.size.width / srcRect.size.height;
            CGFloat displayAspectRatio = displaySize.width / displaySize.height;
            
            if (imageAspectRatio > displayAspectRatio) {
                // The image is wider than the display, so let's decrease the height.
                displaySize.height = displaySize.width * (srcRect.size.height / srcRect.size.width);
                
            } else if (imageAspectRatio < displayAspectRatio) {
                // The image is taller than the display, so let's decrease the width.
                displaySize.width = displaySize.height * imageAspectRatio;
            }
        }
        
        CGRect srcCropRect = [UIImage sourceRectWithImageSize: srcRect.size
                                                  displaySize: displaySize
                                                  contentMode: contentMode];
        srcCropRect = CGRectMake(floorf(srcCropRect.origin.x),
                                 floorf(srcCropRect.origin.y),
                                 roundf(srcCropRect.size.width),
                                 roundf(srcCropRect.size.height));
        
        // Do we need to crop the source?
        if (!CGRectEqualToRect(srcCropRect, srcRect)) {
            srcImageRef = CGImageCreateWithImageInRect(srcImageRef, srcCropRect);
            trimmedImageRef = srcImageRef;
            
            srcRect = CGRectMake(0, 0,
                                 CGRectGetWidth(srcCropRect),
                                 CGRectGetHeight(srcCropRect));
            
            // Release the cropped image source to reduce this thread's memory consumption.
            if (nil != croppedImageRef) {
                CGImageRelease(croppedImageRef);
                croppedImageRef = nil;
            }
        }
        
        // Calcuate the destination frame.
        CGRect dstBlitRect = [UIImage destinationRectWithImageSize: srcRect.size
                                                       displaySize: displaySize
                                                       contentMode: contentMode];
        dstBlitRect = CGRectMake(floorf(dstBlitRect.origin.x),
                                 floorf(dstBlitRect.origin.y),
                                 roundf(dstBlitRect.size.width),
                                 roundf(dstBlitRect.size.height));
        
        // Round any remainder on the display size dimensions.
        displaySize = CGSizeMake(roundf(displaySize.width), roundf(displaySize.height));
        
        // See table "Supported Pixel Formats" in the following guide for support iOS bitmap formats:
        // http://developer.apple.com/library/mac/#documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_context/dq_context.html
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGBitmapInfo bmi = (CGBitmapInfo)kCGImageAlphaPremultipliedLast;
        
        // For screen sizes with higher resolutions, we create a larger image with a scale value
        // so that it appears crisper on the screen.
        CGFloat screenScale = 1.0;//NIScreenScale();
        
        // Create our final composite image.
        CGContextRef dstBmp = CGBitmapContextCreate(NULL,
                                                    displaySize.width * screenScale,
                                                    displaySize.height * screenScale,
                                                    8,
                                                    0,
                                                    colorSpace,
                                                    bmi);
        
        // If this fails then we're likely creating an invalid bitmap and shit's about to go down.
        // In production this will fail somewhat gracefully, in that we'll end up just using the
        // source image instead of the cropped and resized image.
        //NIDASSERT(nil != dstBmp);
        
        if (nil != dstBmp) {
            CGRect dstRect = CGRectMake(0, 0,
                                        displaySize.width * screenScale,
                                        displaySize.height * screenScale);
            
            // Render the source image into the destination image.
            CGContextClearRect(dstBmp, dstRect);
            CGContextSetInterpolationQuality(dstBmp, interpolationQuality);
            
            CGRect scaledBlitRect = CGRectMake(dstBlitRect.origin.x * screenScale,
                                               dstBlitRect.origin.y * screenScale,
                                               dstBlitRect.size.width * screenScale,
                                               dstBlitRect.size.height * screenScale);
            CGContextDrawImage(dstBmp, scaledBlitRect, srcImageRef);
            
            CGImageRef resultImageRef = CGBitmapContextCreateImage(dstBmp);
            if (nil != resultImageRef) {
                if ([[UIImage class] respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
                    resultImage = [UIImage imageWithCGImage: resultImageRef
                                                      scale: screenScale
                                                orientation: UIImageOrientationUp];
                    
                } else {
                    resultImage = [UIImage imageWithCGImage: resultImageRef];
                }
                CGImageRelease(resultImageRef);
            }
            
            CGContextRelease(dstBmp);
        }
        
        CGColorSpaceRelease(colorSpace);
        
    } else if (nil != croppedImageRef) {
        resultImage = [UIImage imageWithCGImage:srcImageRef];
    }
    
    // Memory cleanup.
    if (nil != trimmedImageRef) {
        CGImageRelease(trimmedImageRef);
    }
    if (nil != croppedImageRef) {
        CGImageRelease(croppedImageRef);
    }
    
    return resultImage;
}


//
//  Created by Olivier Halligon on 12/08/09.
//  Copyright 2009 AliSoftware. All rights reserved.
//

- (UIImage *)resizedImageToSize:(CGSize)dstSize
{
    CGImageRef imgRef = self.CGImage;
    // the below values are regardless of orientation : for UIImages from Camera, width>height (landscape)
    CGSize  srcSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef)); // not equivalent to self.size (which is dependant on the imageOrientation)!
    
    /* Don't resize if we already meet the required destination size. */
    if (CGSizeEqualToSize(srcSize, dstSize)) {
        return self;
    }
    
    CGFloat scaleRatio = dstSize.width / srcSize.width;
    UIImageOrientation orient = self.imageOrientation;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(srcSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(srcSize.width, srcSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, srcSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            dstSize = CGSizeMake(dstSize.height, dstSize.width);
            transform = CGAffineTransformMakeTranslation(srcSize.height, srcSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            dstSize = CGSizeMake(dstSize.height, dstSize.width);
            transform = CGAffineTransformMakeTranslation(0.0, srcSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            dstSize = CGSizeMake(dstSize.height, dstSize.width);
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            dstSize = CGSizeMake(dstSize.height, dstSize.width);
            transform = CGAffineTransformMakeTranslation(srcSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    /////////////////////////////////////////////////////////////////////////////
    // The actual resize: draw the image on a new context, applying a transform matrix
    UIGraphicsBeginImageContextWithOptions(dstSize, NO, self.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (!context) {
        return nil;
    }
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -srcSize.height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -srcSize.height);
    }
    
    CGContextConcatCTM(context, transform);
    
    // we use srcSize (and not dstSize) as the size to specify is in user space (and we use the CTM to apply a scaleRatio)
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, srcSize.width, srcSize.height), imgRef);
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage *)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale
{
    // get the image size (independant of imageOrientation)
    CGImageRef imgRef = self.CGImage;
    CGSize srcSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef)); // not equivalent to self.size (which depends on the imageOrientation)!
    
    // adjust boundingSize to make it independant on imageOrientation too for farther computations
    UIImageOrientation orient = self.imageOrientation;
    switch (orient) {
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            boundingSize = CGSizeMake(boundingSize.height, boundingSize.width);
            break;
        default:
            // NOP
            break;
    }
    
    // Compute the target CGRect in order to keep aspect-ratio
    CGSize dstSize;
    
    if ( !scale && (srcSize.width < boundingSize.width) && (srcSize.height < boundingSize.height) ) {
        //DDLogVerbose(@"Image is smaller, and we asked not to scale it in this case (scaleIfSmaller:NO)");
        dstSize = srcSize; // no resize (we could directly return 'self' here, but we draw the image anyway to take image orientation into account)
    } else {
        CGFloat wRatio = boundingSize.width / srcSize.width;
        CGFloat hRatio = boundingSize.height / srcSize.height;
        
        if (wRatio < hRatio) {
            //DDLogVerbose(@"Width imposed, Height scaled ; ratio = %f",wRatio);
            dstSize = CGSizeMake(boundingSize.width, floorf(srcSize.height * wRatio));
        } else {
            //DDLogVerbose(@"Height imposed, Width scaled ; ratio = %f",hRatio);
            dstSize = CGSizeMake(floorf(srcSize.width * hRatio), boundingSize.height);
        }
    }
    
    return [self resizedImageToSize:dstSize];
}

@end
