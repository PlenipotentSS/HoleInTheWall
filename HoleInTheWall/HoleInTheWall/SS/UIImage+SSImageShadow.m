//
//  UIImage+SSImageShadow.m
//  HoleInTheWall
//
//  Created by Stevenson on 3/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "UIImage+SSImageShadow.h"

#define SHADOW_START_HORIZONTAL_PERCENT .5
#define SHADOW_START_VERTICAL_PERCENT .4

@implementation UIImage (SSImageShadow)

+ (UIImage *)createShadowBoxImageWithImage:(UIImage *)image forSize:(CGSize) theSize
{
    UIImage *leftShadow = [self createLeftShadowWithSize:theSize];
    UIImage *rightShadow = [self createRightShadowWithSize:theSize];
    UIImage *topShadow = [self createTopShadowWithSize:theSize];
    UIImage *bottomShadow = [self createBottomShadowWithSize:theSize];

    UIImage *wallImage = [self smallifyImage:image fromSize:theSize];
    
    NSArray *allImages = @[wallImage,leftShadow,rightShadow,topShadow,bottomShadow];
    UIImage *combinedImage =[self combineImages:allImages withSize:theSize];
    
    
    return combinedImage;
}

+ (UIImage*)smallifyImage:(UIImage*)image fromSize:(CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [[UIColor clearColor] setFill];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillRect(context, CGRectMake(0., 0.f, size.width, size.height));
    
    [image drawInRect:CGRectMake(WALL_OUTER_SHADOW_SIDE/2, WALL_OUTER_SHADOW_TOPBOTTOM/2, size.width-WALL_OUTER_SHADOW_SIDE, size.height-WALL_OUTER_SHADOW_TOPBOTTOM)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRelease(context);
    return newImage;
}

+ (UIImage*)combineImages:(NSArray*)images withSize:(CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [[UIColor clearColor] setFill];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillRect(context, CGRectMake(0., 0.f, size.width, size.height));
    
    
    for (UIImage *image in images) {
        [image drawInRect:CGRectMake((size.width-image.size.width)/2, (size.height-image.size.height)/2, size.width, size.height)];
    }
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRelease(context);
    context = nil;
    return newImage;
}

+ (UIImage*)createLeftShadowWithSize:(CGSize)size
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UIColor* noneColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    UIColor* color15 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.2];
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
    UIColor* color15 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.2];
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
    UIColor* color15 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.1];
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
    UIColor* color15 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.1];
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
