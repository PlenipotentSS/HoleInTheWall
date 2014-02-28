//
//  SSGameScene.m
//  HoleInTheWall
//
//  Created by Stevenson on 21/02/2014.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "SSGameScene.h"
#import "SSBackgroundView.h"
#import <CoreImage/CoreImage.h>

@interface SSGameScene()

@property (nonatomic) CGFloat zScale;
@property (nonatomic) SKView *backgroundView;

@property (nonatomic) CGFloat minX;
@property (nonatomic) CGFloat maxX;

@property (nonatomic) CGFloat minY;
@property (nonatomic) CGFloat maxY;

@property (nonatomic) CGFloat midX;
@property (nonatomic) CGFloat midY;

@property (nonatomic) SKSpriteNode *backgroundNode;
@property (nonatomic) UIImage *backgroundImage;

@end

@implementation SSGameScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        
        
        self.backgroundImage = [UIImage imageNamed:@"spacescape"];
        
        self.minX = CGRectGetMinX(self.frame);
        self.maxX = CGRectGetMaxX(self.frame);
        
        self.minY = CGRectGetMinY(self.frame);
        self.maxY = CGRectGetMaxY(self.frame);
        
        self.midX = CGRectGetMidX(self.frame);
        self.midY = CGRectGetMidY(self.frame);
        
        [self createBackground];
    }
    return self;
}

-(void) createBackground
{
    
    //ceiling
    UIImage *ceiling = [self makeCeiling];

    //floor
    UIImage *floor1 = [self makeFloor1];
    UIImage *floor2 = [self makeFloor2];

    //left wall
    UIImage *leftWall1 = [self makeLeftWall1];
    UIImage *leftWall2 = [self makeLeftWall2];
    
    //right wall
    UIImage *rightWall1 = [self makeRightWall1];
    UIImage *rightWall2 = [self makeRightWall2];
    
    NSArray *images = @[self.backgroundImage,ceiling,floor1,floor2,leftWall1,leftWall2,rightWall1,rightWall2];
    
    UIImage *background = [self combineImages:images];
    SKTexture *backgroundTexture = [SKTexture textureWithImage:background];
    if (self.backgroundNode) {
        [self.backgroundNode removeFromParent];
    }
    self.backgroundNode = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
    self.backgroundNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    self.backgroundNode.anchorPoint = CGPointMake(1.f,1.f);
    [self addChild:self.backgroundNode];
}

-(void) addBackgroundImage:(UIImage*) image
{
    _backgroundImage = image;
    [self createBackground];
}

-(UIImage*) combineImages:(NSArray*) images
{
    CGSize finalImageSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    UIGraphicsBeginImageContext(finalImageSize);
    [[UIColor clearColor] setFill];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillRect(context, self.frame);
    
    for (UIImage *image in images) {
        [image drawInRect:self.frame];
    }
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRelease(context);
    return newImage;
}

-(UIImage*) makeRightWall2
{
    CGRect theFrame = self.frame;
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UIColor* noneColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    UIColor* color15 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5];
    NSArray* sVGID_23_2Colors = [NSArray arrayWithObjects:
                                 (id)noneColor2.CGColor,
                                 (id)color15.CGColor, nil];
    CGFloat sVGID_23_2Locations[] = {0.89, 1};
    CGGradientRef sVGID_23_2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_23_2Colors, sVGID_23_2Locations);
    
    UIGraphicsBeginImageContext(theFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, theFrame);
    
    CGFloat widthOffset = 10;
    CGContextMoveToPoint(context, self.midX+widthOffset, self.midY+2*widthOffset);
    CGContextAddLineToPoint(context, self.maxX, self.maxY);
    CGContextAddLineToPoint(context, self.maxX, self.minY);
    CGContextAddLineToPoint(context, self.midX+widthOffset, self.midY-widthOffset-8);
    
    CGRect bezierBounds = CGPathGetPathBoundingBox( CGContextCopyPath(context) );
    
    CGContextSetLineWidth(context, 0.5f);
    [[UIColor blackColor] setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    //create image from mask
    UIGraphicsBeginImageContext(theFrame.size);
    context = UIGraphicsGetCurrentContext();
    
    CGContextDrawLinearGradient(context, sVGID_23_2,
                                CGPointMake(CGRectGetMidX(bezierBounds) + 422.7 * CGRectGetWidth(bezierBounds) / 305.2, CGRectGetMidY(bezierBounds) + -196.24 * CGRectGetHeight(bezierBounds) / 1136),
                                CGPointMake(CGRectGetMidX(bezierBounds) + -117.5 * CGRectGetWidth(bezierBounds) / 305.2, CGRectGetMidY(bezierBounds) + 196.24 * CGRectGetHeight(bezierBounds) / 1136),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    CGGradientRelease(sVGID_23_2);
    CGColorSpaceRelease(colorSpace);
    
    return [self maskImage:shadowImage withMask:maskImage];
}

-(UIImage*) makeRightWall1
{
    CGRect theFrame = self.frame;
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UIColor* noneColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    UIColor* color15 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5];
    NSArray* sVGID_22_2Colors = [NSArray arrayWithObjects:
                                 (id)noneColor2.CGColor,
                                 (id)color15.CGColor, nil];
    CGFloat sVGID_22_2Locations[] = {0.91, 1};
    CGGradientRef sVGID_22_2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_22_2Colors, sVGID_22_2Locations);
    
    UIGraphicsBeginImageContext(theFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, theFrame);
    
    CGFloat widthOffset = 10;
    CGContextMoveToPoint(context, self.midX+widthOffset, self.midY+2*widthOffset);
    CGContextAddLineToPoint(context, self.maxX, self.maxY);
    CGContextAddLineToPoint(context, self.maxX, self.minY);
    CGContextAddLineToPoint(context, self.midX+widthOffset, self.midY-widthOffset-8);
    
    CGRect bezierBounds = CGPathGetPathBoundingBox( CGContextCopyPath(context) );
    
    CGContextSetLineWidth(context, 0.5f);
    [[UIColor blackColor] setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    //create image from mask
    UIGraphicsBeginImageContext(theFrame.size);
    context = UIGraphicsGetCurrentContext();
    
    CGContextDrawLinearGradient(context, sVGID_22_2,
                                CGPointMake(CGRectGetMidX(bezierBounds) + 419.47 * CGRectGetWidth(bezierBounds) / 305.2, CGRectGetMidY(bezierBounds) + 186.87 * CGRectGetHeight(bezierBounds) / 1136),
                                CGPointMake(CGRectGetMidX(bezierBounds) + -114.27 * CGRectGetWidth(bezierBounds) / 305.2, CGRectGetMidY(bezierBounds) + -186.87 * CGRectGetHeight(bezierBounds) / 1136),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    CGGradientRelease(sVGID_22_2);
    CGColorSpaceRelease(colorSpace);
    
    return [self maskImage:shadowImage withMask:maskImage];
}

-(UIImage*) makeLeftWall1
{
    CGRect theFrame = self.frame;
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UIColor* noneColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    UIColor* color15 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5];
    NSArray* sVGID_24_2Colors = [NSArray arrayWithObjects:
                                 (id)noneColor2.CGColor,
                                 (id)color15.CGColor, nil];
    CGFloat sVGID_24_2Locations[] = {0.92, 1};
    CGGradientRef sVGID_24_2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_24_2Colors, sVGID_24_2Locations);
    
    UIGraphicsBeginImageContext(theFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, theFrame);
    
    CGFloat heightOffset = 20;
    CGFloat widthOffset = 10;
    CGContextMoveToPoint(context, self.midX-widthOffset, self.midY+heightOffset);
    CGContextAddLineToPoint(context, self.minX, self.maxY);
    CGContextAddLineToPoint(context, self.minX, self.minY);
    CGContextAddLineToPoint(context, self.midX-widthOffset, self.midY-heightOffset/2-8);
    CGContextAddLineToPoint(context, self.midX-widthOffset, self.midY+heightOffset);
    
    CGRect bezierBounds = CGPathGetPathBoundingBox( CGContextCopyPath(context) );
    
    CGContextSetLineWidth(context, 0.5f);
    [[UIColor blackColor] setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    //create image from mask
    UIGraphicsBeginImageContext(theFrame.size);
    context = UIGraphicsGetCurrentContext();
    
    CGContextDrawLinearGradient(context, sVGID_24_2,
                                CGPointMake(CGRectGetMidX(bezierBounds) + -412.05 * CGRectGetWidth(bezierBounds) / 305.2, CGRectGetMidY(bezierBounds) + 168.49 * CGRectGetHeight(bezierBounds) / 1136),
                                CGPointMake(CGRectGetMidX(bezierBounds) + 106.85 * CGRectGetWidth(bezierBounds) / 305.2, CGRectGetMidY(bezierBounds) + -168.49 * CGRectGetHeight(bezierBounds) / 1136),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    CGGradientRelease(sVGID_24_2);
    CGColorSpaceRelease(colorSpace);
    
    return [self maskImage:shadowImage withMask:maskImage];
}

-(UIImage*) makeLeftWall2
{
    CGRect theFrame = self.frame;
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UIColor* noneColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    UIColor* color15 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5];
    NSArray* sVGID_25_2Colors = [NSArray arrayWithObjects:
                                 (id)noneColor2.CGColor,
                                 (id)color15.CGColor, nil];
    CGFloat sVGID_25_2Locations[] = {0.91, 1};
    CGGradientRef sVGID_25_2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_25_2Colors, sVGID_25_2Locations);
    
    UIGraphicsBeginImageContext(theFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, theFrame);
    
    CGFloat heightOffset = 20;
    CGFloat widthOffset = 10;
    CGContextMoveToPoint(context, self.midX-widthOffset, self.midY+heightOffset);
    CGContextAddLineToPoint(context, self.minX, self.maxY);
    CGContextAddLineToPoint(context, self.minX, self.minY);
    CGContextAddLineToPoint(context, self.midX-widthOffset, self.midY-heightOffset/2-8);
    CGContextAddLineToPoint(context, self.midX-widthOffset, self.midY+heightOffset);

    CGRect bezierBounds = CGPathGetPathBoundingBox( CGContextCopyPath(context) );
    
    CGContextSetLineWidth(context, 0.5f);
    [[UIColor blackColor] setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    //create image from mask
    UIGraphicsBeginImageContext(theFrame.size);
    context = UIGraphicsGetCurrentContext();
    
    CGContextDrawLinearGradient(context, sVGID_25_2,
                                CGPointMake(CGRectGetMidX(bezierBounds) + -415.92 * CGRectGetWidth(bezierBounds) / 305.2, CGRectGetMidY(bezierBounds) + -177.61 * CGRectGetHeight(bezierBounds) / 1136),
                                CGPointMake(CGRectGetMidX(bezierBounds) + 110.72 * CGRectGetWidth(bezierBounds) / 305.2, CGRectGetMidY(bezierBounds) + 177.61 * CGRectGetHeight(bezierBounds) / 1136),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    CGGradientRelease(sVGID_25_2);
    CGColorSpaceRelease(colorSpace);
    
    return [self maskImage:shadowImage withMask:maskImage];
}

-(UIImage*) makeFloor2
{
    CGRect theFrame = self.frame;
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UIColor* noneColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    UIColor* color15 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5];
    NSArray* sVGID_27_2Colors = [NSArray arrayWithObjects:
                                 (id)noneColor2.CGColor,
                                 (id)color15.CGColor, nil];
    CGFloat sVGID_27_2Locations[] = {0.88, 1};
    CGGradientRef sVGID_27_2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_27_2Colors, sVGID_27_2Locations);
    
    UIGraphicsBeginImageContext(theFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, theFrame);
    
    CGFloat heightOffset = 20;
    CGFloat widthOffset = 10;
    CGContextMoveToPoint(context, self.minX, self.maxY);
    CGContextAddLineToPoint(context, self.maxX, self.maxY);
    CGContextAddLineToPoint(context, self.midX+widthOffset, self.midY+heightOffset);
    CGContextAddLineToPoint(context, self.midX-widthOffset, self.midY+heightOffset);
    CGContextAddLineToPoint(context, self.minX, self.maxY);
    CGRect bezierBounds = CGPathGetPathBoundingBox( CGContextCopyPath(context) );
    
    CGContextSetLineWidth(context, 0.5f);
    [[UIColor blackColor] setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    //create image from mask
    UIGraphicsBeginImageContext(theFrame.size);
    context = UIGraphicsGetCurrentContext();
    
    CGContextDrawLinearGradient(context, sVGID_27_2,
                                CGPointMake(CGRectGetMidX(bezierBounds) + 342.46 * CGRectGetWidth(bezierBounds) / 640, CGRectGetMidY(bezierBounds) + 220.42 * CGRectGetHeight(bezierBounds) / 541.75),
                                CGPointMake(CGRectGetMidX(bezierBounds) + -191.66 * CGRectGetWidth(bezierBounds) / 640, CGRectGetMidY(bezierBounds) + -17.39 * CGRectGetHeight(bezierBounds) / 541.75),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    CGGradientRelease(sVGID_27_2);
    CGColorSpaceRelease(colorSpace);
    
    return [self maskImage:shadowImage withMask:maskImage];
}


-(UIImage*) makeFloor1
{
    CGRect theFrame = self.frame;
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UIColor* noneColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    UIColor* color15 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5];
    NSArray* sVGID_26_2Colors = [NSArray arrayWithObjects:
                                 (id)noneColor2.CGColor,
                                 (id)color15.CGColor, nil];
    CGFloat sVGID_26_2Locations[] = {0.88, 1};
    CGGradientRef sVGID_26_2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_26_2Colors, sVGID_26_2Locations);

    UIGraphicsBeginImageContext(theFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, theFrame);
    
    CGFloat heightOffset = 20;
    CGFloat widthOffset = 10;
    CGContextMoveToPoint(context, self.minX, self.maxY);
    CGContextAddLineToPoint(context, self.maxX, self.maxY);
    CGContextAddLineToPoint(context, self.midX+widthOffset, self.midY+heightOffset);
    CGContextAddLineToPoint(context, self.midX-widthOffset, self.midY+heightOffset);
    CGContextAddLineToPoint(context, self.minX, self.maxY);
    CGRect bezierBounds = CGPathGetPathBoundingBox( CGContextCopyPath(context) );
    
    CGContextSetLineWidth(context, 0.5f);
    [[UIColor blackColor] setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    //create image from mask
    UIGraphicsBeginImageContext(theFrame.size);
    context = UIGraphicsGetCurrentContext();

    CGContextDrawLinearGradient(context, sVGID_26_2,
                                CGPointMake(CGRectGetMidX(bezierBounds) + -342.47 * CGRectGetWidth(bezierBounds) / 640, CGRectGetMidY(bezierBounds) + 220.42 * CGRectGetHeight(bezierBounds) / 541.75),
                                CGPointMake(CGRectGetMidX(bezierBounds) + 191.66 * CGRectGetWidth(bezierBounds) / 640, CGRectGetMidY(bezierBounds) + -17.39 * CGRectGetHeight(bezierBounds) / 541.75),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    
    //    CGContextClipToMask(context, self.view.bounds, textureImage.CGImage);
    UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    CGGradientRelease(sVGID_26_2);
    CGColorSpaceRelease(colorSpace);
    
    return [self maskImage:shadowImage withMask:maskImage];
}

-(UIImage*) makeCeiling
{
    CGRect theFrame = self.frame;
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UIColor* color23 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    UIColor* color24 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5];
    NSArray* sVGID_1_4Colors = [NSArray arrayWithObjects:
                                (id)color23.CGColor,
                                (id)color24.CGColor, nil];
    CGFloat sVGID_1_4Locations[] = {0.6, 1};
    CGGradientRef sVGID_1_4 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_1_4Colors, sVGID_1_4Locations);
    
    UIGraphicsBeginImageContext(theFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, theFrame);
    
    CGFloat widthOffset = 10;
    CGRect frame = theFrame;
    CGContextMoveToPoint(context, self.minX + CGRectGetWidth(frame), self.minY);
    CGContextAddLineToPoint(context,self.minX, self.minY);
    CGContextAddLineToPoint(context,self.midX-widthOffset, self.midY-widthOffset);
    CGContextAddLineToPoint(context,self.midX+widthOffset, self.midY-widthOffset);
    CGContextAddLineToPoint(context,self.minX + CGRectGetWidth(frame), self.minY);
    
    CGRect bezierBounds = CGPathGetPathBoundingBox( CGContextCopyPath(context) );
    
    CGContextSetLineWidth(context, 0.5f);
    [[UIColor blackColor] setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    //create image from mask
    UIGraphicsBeginImageContext(theFrame.size);
    context = UIGraphicsGetCurrentContext();
    
    CGFloat bezierResizeRatio = MIN(CGRectGetWidth(bezierBounds) / CGRectGetWidth(frame), CGRectGetHeight(bezierBounds) / 541.75);
    CGContextDrawRadialGradient(context, sVGID_1_4,
                                CGPointMake(CGRectGetMidX(bezierBounds) + -0 * bezierResizeRatio, CGRectGetMidY(bezierBounds) + -0 * bezierResizeRatio), 0 * bezierResizeRatio,
                                CGPointMake(CGRectGetMidX(bezierBounds) + -0 * bezierResizeRatio, CGRectGetMidY(bezierBounds) + -0 * bezierResizeRatio), 444.69 * bezierResizeRatio,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    
    //    CGContextClipToMask(context, self.view.bounds, textureImage.CGImage);
    UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    CGGradientRelease(sVGID_1_4);
    CGColorSpaceRelease(colorSpace);
    
    return [self maskImage:shadowImage withMask:maskImage];
}

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], mask);
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];
    
    CGImageRelease(mask);
    CGImageRelease(maskedImageRef);
    
    // returns new image with mask applied
    return maskedImage;
}

@end
