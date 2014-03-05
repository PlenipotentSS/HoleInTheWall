//
//  UIImage+SSImageShadow.m
//  HoleInTheWall
//
//  Created by Stevenson on 3/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "UIImage+SSImageShadow.h"

#define SHADOW_START_HORIZONTAL_PERCENT .7
#define SHADOW_START_VERTICAL_PERCENT .8

@implementation UIImage (SSImageShadow)

+ (UIImage *)createShadowBoxImageWithImage:(UIImage *)image
{
    UIImage *leftShadow = [self createLeftShadowWithSize:image.size];
    UIImage *rightShadow = [self createRightShadowWithSize:image.size];
    UIImage *topShadow = [self createTopShadowWithSize:image.size];
//    UIImage *bottomShadow = [self createBottomShadowWithSize:image.size];

    NSArray *allImages = @[image,leftShadow,rightShadow,topShadow];
    UIImage *combinedImage =[self combineImages:allImages withSize:image.size];
    return combinedImage;
}

+ (UIImage*)combineImages:(NSArray*)images withSize:(CGSize) size
{
    CGSize finalImageSize = CGSizeMake(size.width, size.height);
    UIGraphicsBeginImageContext(finalImageSize);
    [[UIColor clearColor] setFill];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillRect(context, CGRectMake(0., 0.f, size.width, size.height));
    
    
    for (UIImage *image in images) {
        [image drawInRect:CGRectMake(0., 0.f, size.width, size.height)];
    }
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRelease(context);
    return newImage;
}

+ (UIImage*)createLeftShadowWithSize:(CGSize)size
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UIColor* noneColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    UIColor* color15 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5];
    NSArray* sVGID_24_2Colors = [NSArray arrayWithObjects:
                                 (id)noneColor2.CGColor,
                                 (id)color15.CGColor, nil];
    CGFloat sVGID_24_2Locations[] = {SHADOW_START_HORIZONTAL_PERCENT, 1};
    CGGradientRef sVGID_24_2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_24_2Colors, sVGID_24_2Locations);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawLinearGradient(context, sVGID_24_2,
                                CGPointMake(size.width/2, size.height/2),
                                CGPointMake(0.f, size.height/2),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    CGGradientRelease(sVGID_24_2);
    CGColorSpaceRelease(colorSpace);
    return shadowImage;
}

+ (UIImage*)createRightShadowWithSize:(CGSize)size
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UIColor* noneColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    UIColor* color15 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5];
    NSArray* sVGID_24_2Colors = [NSArray arrayWithObjects:
                                 (id)noneColor2.CGColor,
                                 (id)color15.CGColor, nil];
    CGFloat sVGID_24_2Locations[] = {SHADOW_START_HORIZONTAL_PERCENT, 1};
    CGGradientRef sVGID_24_2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_24_2Colors, sVGID_24_2Locations);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawLinearGradient(context, sVGID_24_2,
                                CGPointMake(size.width/2, size.height/2),
                                CGPointMake(size.width, size.height/2),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    CGGradientRelease(sVGID_24_2);
    CGColorSpaceRelease(colorSpace);
    return shadowImage;
}

+ (UIImage*)createTopShadowWithSize:(CGSize)size
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UIColor* noneColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    UIColor* color15 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5];
    NSArray* sVGID_24_2Colors = [NSArray arrayWithObjects:
                                 (id)noneColor2.CGColor,
                                 (id)color15.CGColor, nil];
    CGFloat sVGID_24_2Locations[] = {SHADOW_START_VERTICAL_PERCENT, 1};
    CGGradientRef sVGID_24_2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_24_2Colors, sVGID_24_2Locations);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawLinearGradient(context, sVGID_24_2,
                                CGPointMake(size.width/2, size.height/2),
                                CGPointMake(size.width/2, 0.f),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    CGGradientRelease(sVGID_24_2);
    CGColorSpaceRelease(colorSpace);
    return shadowImage;
}

+ (UIImage*)createBottomShadowWithSize:(CGSize)size
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UIColor* noneColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    UIColor* color15 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5];
    NSArray* sVGID_24_2Colors = [NSArray arrayWithObjects:
                                 (id)noneColor2.CGColor,
                                 (id)color15.CGColor, nil];
    CGFloat sVGID_24_2Locations[] = {SHADOW_START_VERTICAL_PERCENT, 1};
    CGGradientRef sVGID_24_2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_24_2Colors, sVGID_24_2Locations);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawLinearGradient(context, sVGID_24_2,
                                CGPointMake(size.width/2, size.height/2),
                                CGPointMake(size.width/2, size.height),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    CGGradientRelease(sVGID_24_2);
    CGColorSpaceRelease(colorSpace);
    return shadowImage;
}
@end
