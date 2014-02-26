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

@end

@implementation SSGameScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        [self createShapes];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void) createShapes
{
    
    //ceiling
    UIImage *ceiling = [self makeCeiling];
    SKTexture *texture = [SKTexture textureWithImage:ceiling];
    SKSpriteNode *bg = [SKSpriteNode spriteNodeWithTexture:texture];
    bg.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:bg];
    
    //floor
    UIImage *floor1 = [self makeFloor1];
    SKTexture *textureF1 = [SKTexture textureWithImage:floor1];
    SKSpriteNode *bgF1 = [SKSpriteNode spriteNodeWithTexture:textureF1];
    bgF1.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:bgF1];
    
    
    UIImage *floor2 = [self makeFloor2];
    SKTexture *textureF2 = [SKTexture textureWithImage:floor2];
    SKSpriteNode *bgF2 = [SKSpriteNode spriteNodeWithTexture:textureF2];
    bgF2.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:bgF2];
    
    //left wall
    UIImage *leftWall1 = [self makeLeftWall1];
    SKTexture *textureLW1 = [SKTexture textureWithImage:leftWall1];
    SKSpriteNode *bgLW1 = [SKSpriteNode spriteNodeWithTexture:textureLW1];
    bgLW1.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:bgLW1];
    
    
    UIImage *leftWall2 = [self makeLeftWall2];
    SKTexture *textureLW2 = [SKTexture textureWithImage:leftWall2];
    SKSpriteNode *bgLW2 = [SKSpriteNode spriteNodeWithTexture:textureLW2];
    bgLW2.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:bgLW2];
    
    //right wall
    UIImage *rightWall1 = [self makeRightWall1];
    SKTexture *textureRW1 = [SKTexture textureWithImage:rightWall1];
    SKSpriteNode *bgRW1 = [SKSpriteNode spriteNodeWithTexture:textureRW1];
    bgRW1.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:bgRW1];
    
    UIImage *rightWall2 = [self makeRightWall2];
    SKTexture *textureRW2 = [SKTexture textureWithImage:rightWall2];
    SKSpriteNode *bgRW2 = [SKSpriteNode spriteNodeWithTexture:textureRW2];
    bgRW2.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:bgRW2];
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
    CGRect frame = theFrame;
    CGContextMoveToPoint(context, CGRectGetMidX(frame)+widthOffset, CGRectGetMidY(frame)+2*widthOffset);
    CGContextAddLineToPoint(context, CGRectGetMaxX(frame), CGRectGetMaxY(frame));
    CGContextAddLineToPoint(context, CGRectGetMaxX(frame), CGRectGetMinY(frame));
    CGContextAddLineToPoint(context, CGRectGetMidX(frame)+widthOffset, CGRectGetMidY(frame)-widthOffset);
    
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
    CGRect frame = theFrame;
    CGContextMoveToPoint(context, CGRectGetMidX(frame)+widthOffset, CGRectGetMidY(frame)+2*widthOffset);
    CGContextAddLineToPoint(context, CGRectGetMaxX(frame), CGRectGetMaxY(frame));
    CGContextAddLineToPoint(context, CGRectGetMaxX(frame), CGRectGetMinY(frame));
    CGContextAddLineToPoint(context, CGRectGetMidX(frame)+widthOffset, CGRectGetMidY(frame)-widthOffset);
    
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
    CGRect frame = theFrame;
    CGContextMoveToPoint(context, CGRectGetMidX(frame)-widthOffset, CGRectGetMidY(frame)+heightOffset);
    CGContextAddLineToPoint(context, CGRectGetMinX(frame), CGRectGetMaxY(frame));
    CGContextAddLineToPoint(context, CGRectGetMinX(frame), CGRectGetMinY(frame));
    CGContextAddLineToPoint(context, CGRectGetMidX(frame)-widthOffset, CGRectGetMidY(frame)-heightOffset/2);
    CGContextAddLineToPoint(context, CGRectGetMidX(frame)-widthOffset, CGRectGetMidY(frame)+heightOffset);
    
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
    CGRect frame = theFrame;
    CGContextMoveToPoint(context, CGRectGetMidX(frame)-widthOffset, CGRectGetMidY(frame)+heightOffset);
    CGContextAddLineToPoint(context, CGRectGetMinX(frame), CGRectGetMaxY(frame));
    CGContextAddLineToPoint(context, CGRectGetMinX(frame), CGRectGetMinY(frame));
    CGContextAddLineToPoint(context, CGRectGetMidX(frame)-widthOffset, CGRectGetMidY(frame)-heightOffset/2);
    CGContextAddLineToPoint(context, CGRectGetMidX(frame)-widthOffset, CGRectGetMidY(frame)+heightOffset);

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
    CGRect frame = theFrame;
    CGContextMoveToPoint(context, CGRectGetMinX(frame), CGRectGetMaxY(frame));
    CGContextAddLineToPoint(context, CGRectGetMaxX(frame), CGRectGetMaxY(frame));
    CGContextAddLineToPoint(context, CGRectGetMidX(frame)+widthOffset, CGRectGetMidY(frame)+heightOffset);
    CGContextAddLineToPoint(context, CGRectGetMidX(frame)-widthOffset, CGRectGetMidY(frame)+heightOffset);
    CGContextAddLineToPoint(context, CGRectGetMinX(frame), CGRectGetMaxY(frame));
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
    CGRect frame = theFrame;
    CGContextMoveToPoint(context, CGRectGetMinX(frame), CGRectGetMaxY(frame));
    CGContextAddLineToPoint(context, CGRectGetMaxX(frame), CGRectGetMaxY(frame));
    CGContextAddLineToPoint(context, CGRectGetMidX(frame)+widthOffset, CGRectGetMidY(frame)+heightOffset);
    CGContextAddLineToPoint(context, CGRectGetMidX(frame)-widthOffset, CGRectGetMidY(frame)+heightOffset);
    CGContextAddLineToPoint(context, CGRectGetMinX(frame), CGRectGetMaxY(frame));
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
    CGContextMoveToPoint(context, CGRectGetMinX(frame) + CGRectGetWidth(frame), CGRectGetMinY(frame));
    CGContextAddLineToPoint(context,CGRectGetMinX(frame), CGRectGetMinY(frame));
    CGContextAddLineToPoint(context,CGRectGetMidX(frame)-widthOffset, CGRectGetMidY(frame)-widthOffset);
    CGContextAddLineToPoint(context,CGRectGetMidX(frame)+widthOffset, CGRectGetMidY(frame)-widthOffset);
    CGContextAddLineToPoint(context,CGRectGetMinX(frame) + CGRectGetWidth(frame), CGRectGetMinY(frame));
    
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

@end
