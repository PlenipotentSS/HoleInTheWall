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

@property (nonatomic) CGRect backgroundFrame;

@property (nonatomic) SKSpriteNode *backgroundNode;
@property (nonatomic) SKSpriteNode *shapeShadow;
@property (nonatomic) UIImage *backgroundImage;

@end

@implementation SSGameScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.backgroundImage = [UIImage imageNamed:@"grey_wash_wall"];
        
        self.minX = CGRectGetMinX(self.frame);
        self.maxX = CGRectGetMaxX(self.frame);
        
        self.minY = CGRectGetMinY(self.frame);
        self.maxY = CGRectGetMaxY(self.frame);
        
        self.midX = CGRectGetMidX(self.frame);
        self.midY = CGRectGetMidY(self.frame);
        
        self.backgroundFrame = self.frame;
        
        [self addShadowWithSize:CGSizeMake(150.f, 50.f)];
        
        [self createBackground];
    }
    return self;
}

- (void)addShadowWithSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UIColor* clear = [UIColor clearColor];
    UIColor* shadow = [UIColor colorWithWhite:0.f alpha:.5];
    NSArray* shadowColors = [NSArray arrayWithObjects:
                                (id)shadow.CGColor,
                                (id)clear.CGColor, nil];
    CGFloat shadowLocations[] = {0.6, 1};
    CGGradientRef shadowGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)shadowColors, shadowLocations);
    
    CGAffineTransform scaleT = CGAffineTransformMakeScale(3.f, 1.0);
    CGContextScaleCTM(context, scaleT.a, scaleT.d);
    
    CGAffineTransform invScaleT = CGAffineTransformInvert(scaleT);

    CGPoint invS = CGPointMake(invScaleT.a, invScaleT.d);
    
    CGPoint centerShadow =CGPointMake(size.width/2 *invS.x, size.height/2*invS.y);
    
    CGContextDrawRadialGradient(context, shadowGradient, centerShadow, 0.f, centerShadow, size.height/2, kCGGradientDrawsBeforeStartLocation);
    
    UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRelease(context);
    
    SKTexture *shadowTexture = [SKTexture textureWithImage:shadowImage];
    self.shapeShadow = [SKSpriteNode spriteNodeWithTexture:shadowTexture];
    self.backgroundNode.anchorPoint = CGPointMake(1.f,1.f);
    self.shapeShadow.position = CGPointMake(0.f, -CGRectGetHeight(self.frame)/2+15.f);
    
}

- (void)addShadowForReferencePoint:(CGPoint)shapeLocation
{
    [self addChild:self.shapeShadow];
    CGPoint thisLocation = shapeLocation;
    thisLocation.y = -CGRectGetHeight(self.frame)/2+15.f;
    self.shapeShadow.position = thisLocation;
    [self.shapeShadow setZPosition:-.5];
    [self.shapeShadow setXScale:1];
}

-(void) removeShadow {
    [self.shapeShadow removeFromParent];

}

-(void) shadowMoveFollowingHit
{
    SKAction *moveAction = [SKAction moveToY:-CGRectGetHeight(self.frame) duration:1.f];
    SKAction *removeFromParent = [SKAction runBlock:^{
        [self.shapeShadow removeFromParent];
    }];
    SKAction *shadowActions = [SKAction sequence:@[moveAction,removeFromParent]];
    [self.shapeShadow runAction:shadowActions];
}

-(void) moveShadowWithReferencePoint: (CGPoint) shapeLocation
{
    CGPoint thisLocation = shapeLocation;
    thisLocation.y = -CGRectGetHeight(self.frame)/2+15.f;
    CGFloat xScale =-shapeLocation.y/200;
    if (-.5 < xScale && xScale < .75) {
        [self.shapeShadow setXScale:1+xScale];
        if ( xScale <0 ) {
            [self.shapeShadow setYScale:1+xScale];
        }
    }
    
    self.shapeShadow.position = thisLocation;
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
    self.backgroundNode.position = CGPointMake(CGRectGetMidX(self.backgroundFrame), CGRectGetMidY(self.backgroundFrame));
    self.backgroundNode.anchorPoint = CGPointMake(1.f,1.f);
    [self.backgroundNode setZPosition:-1];
    [self addChild:self.backgroundNode];
}

-(void) changeBackgroundImage:(UIImage*) image
{
    if (image) {
        self.minX = 0.f;
        self.maxX = CGRectGetMaxX(self.backgroundFrame);
        
        self.minY = 0.f;
        self.maxY = CGRectGetMaxY(self.backgroundFrame);
        
        self.midX = CGRectGetMaxX(self.backgroundFrame)/2;
        self.midY = CGRectGetMaxY(self.backgroundFrame)/2;
        
        [self.backgroundNode removeFromParent];
        self.backgroundNode.anchorPoint = CGPointZero;
        _backgroundImage = image;
        [self createBackground];
        self.backgroundNode.position = CGPointMake(self.midX, self.midY);
    } else {
        NSLog(@"attempting to add background with nil image");
    }
}

-(UIImage*) combineImages:(NSArray*) images
{
    CGSize finalImageSize = CGSizeMake(CGRectGetWidth(self.backgroundFrame), CGRectGetHeight(self.backgroundFrame));
    UIGraphicsBeginImageContext(finalImageSize);
    [[UIColor clearColor] setFill];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillRect(context, self.backgroundFrame);
    
    for (UIImage *image in images) {
        [image drawInRect:self.backgroundFrame];
    }
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRelease(context);
    return newImage;
}

-(UIImage*) makeRightWall2
{
    CGRect theFrame = self.backgroundFrame;
    
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
    CGRect theFrame = self.backgroundFrame;
    
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
    CGRect theFrame = self.backgroundFrame;
    
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
    CGRect theFrame = self.backgroundFrame;
    
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
    CGRect theFrame = self.backgroundFrame;
    
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
    CGRect theFrame = self.backgroundFrame;
    
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
    CGRect theFrame = self.backgroundFrame;
    
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
