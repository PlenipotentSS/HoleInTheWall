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
#import "JWCDimensions.h"
#import "UIImage+SSImageShadow.h"

#define OFF_CENTER_Y 70.f
#define WALL_WIDTH_OFF_CENTER 20.f
#define SHADOW_OFF_INTERSECT OFF_CENTER_Y

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

@property (nonatomic) UIImage *backgroundImage;

@property (nonatomic) SKSpriteNode *floorNode;

@property (nonatomic) UIImage *floorImage;

@property (nonatomic) SKSpriteNode *shapeShadow;

@end

@implementation SSGameScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.backgroundImage = [UIImage imageNamed:@"geometry"];
        self.floorImage = [UIImage imageNamed:@"food"];
        
        self.minX = CGRectGetMinX(self.frame);
        self.maxX = CGRectGetMaxX(self.frame);
        
        self.minY = CGRectGetMinY(self.frame);
        self.maxY = CGRectGetMaxY(self.frame);
        
        self.midX = CGRectGetMidX(self.frame);
        self.midY = CGRectGetMidY(self.frame)+OFF_CENTER_Y;
        
        self.backgroundFrame = self.frame;
        
        [self createBackground];
        [self createFloor];
    }
    return self;
}

-(void) resetFrameValues
{
    self.minX = 0.f;
    self.maxX = CGRectGetMaxX(self.backgroundFrame);
    
    self.minY = 0.f;
    self.maxY = CGRectGetMaxY(self.backgroundFrame);
    
    self.midX = CGRectGetMaxX(self.backgroundFrame)/2;
    self.midY = CGRectGetMaxY(self.backgroundFrame)/2+OFF_CENTER_Y;
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

#pragma mark - object shadow
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
    
    CGContextDrawRadialGradient(context, shadowGradient, centerShadow, 0.f, centerShadow, size.width/8, kCGGradientDrawsBeforeStartLocation);
    
    UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRelease(context);
    
    SKTexture *shadowTexture = [SKTexture textureWithImage:shadowImage];
    self.shapeShadow = [SKSpriteNode spriteNodeWithTexture:shadowTexture];
    self.backgroundNode.anchorPoint = CGPointMake(1.f,1.f);
    self.shapeShadow.position = CGPointMake(0.f, -CGRectGetHeight(self.frame)/2+15.f);
    
}

- (void)addShadowForReferencePoint:(CGPoint)shapeLocation
{
    [self addShadowWithSize:CGSizeMake([[JWCDimensions sharedController] size].width,50.f)];
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

#pragma mark - Modifying Background Image
-(void) changeBackgroundImage:(UIImage*) image
{
    if (image) {
        [self resetFrameValues];
        
        [self.backgroundNode removeFromParent];
        self.backgroundNode.anchorPoint = CGPointZero;
        _backgroundImage = image;
        [self createBackground];
        self.backgroundNode.position = CGPointMake(self.midX, self.midY);
    } else {
        NSLog(@"attempting to add background with nil image");
    }
}

-(void) createBackground
{
    //ceiling
    UIImage *ceiling = [self makeCeiling];
    
    //left wall
    UIImage *leftWall1 = [self makeLeftWall1];
    UIImage *leftWall2 = [self makeLeftWall2];
    
    //right wall
    UIImage *rightWall1 = [self makeRightWall1];
    UIImage *rightWall2 = [self makeRightWall2];
    
    NSArray *images = @[self.backgroundImage,ceiling,leftWall1,leftWall2,rightWall1,rightWall2];
    //    NSArray *images = @[ceiling,floor1,floor2,leftWall1,leftWall2,rightWall1,rightWall2];
    
    UIImage *background = [self combineImages:images];
    SKTexture *backgroundTexture = [SKTexture textureWithImage:background];
    if (self.backgroundNode) {
        [self.backgroundNode removeFromParent];
    }
    self.backgroundNode = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
    self.backgroundNode.position = CGPointMake(CGRectGetMidX(self.backgroundFrame), CGRectGetMidY(self.backgroundFrame));
    self.backgroundNode.anchorPoint = CGPointMake(1.f,1.f);
    [self.backgroundNode setZPosition:-2];
    [self addChild:self.backgroundNode];
}

#pragma mark - Modyfying Floor Image
-(void) changeFloorImage:(UIImage*) image
{
    if (image) {
        [self resetFrameValues];
        
        [self.floorNode removeFromParent];
        self.floorNode.anchorPoint = CGPointZero;
        _floorImage = image;
        [self createFloor];
        self.floorNode.position = CGPointMake(self.midX, self.midY);
    } else {
        NSLog(@"attempting to add background with nil image");
    }
}

- (void)createFloor
{
    //floor
    UIImage *floorBG = [self makeFloorImage];
    UIImage *floor1 = [self makeFloor1];
    UIImage *floor2 = [self makeFloor2];
    
    NSArray *images = @[floorBG,floor1,floor2];
    
    UIImage *floor = [self combineImages:images];
    SKTexture *floorTexture = [SKTexture textureWithImage:floor];
    if (self.floorNode) {
        [self.floorNode removeFromParent];
    }
    self.floorNode = [SKSpriteNode spriteNodeWithTexture:floorTexture];
    self.floorNode.position = CGPointMake(CGRectGetMidX(self.backgroundFrame), CGRectGetMidY(self.backgroundFrame));
    self.floorNode.anchorPoint = CGPointMake(1.f,1.f);
    [self.floorNode setZPosition:-1];
    [self addChild:self.floorNode];
}

#pragma mark - Drawing
#pragma mark Draw Right Wall
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
    CGFloat sVGID_23_2Locations[] = {0.50, 1};
    CGGradientRef sVGID_23_2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_23_2Colors, sVGID_23_2Locations);
    
    UIGraphicsBeginImageContext(theFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, theFrame);
    
    CGFloat widthOffset = WALL_WIDTH_OFF_CENTER;
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
    
    //bottom shadow
    CGContextDrawLinearGradient(context, sVGID_23_2,
                                CGPointMake(CGRectGetMaxX(bezierBounds), CGRectGetMidY(bezierBounds)/2),
                                CGPointMake(CGRectGetMinX(bezierBounds), (CGRectGetMidY(bezierBounds)+SHADOW_OFF_INTERSECT)),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    CGGradientRelease(sVGID_23_2);
    CGColorSpaceRelease(colorSpace);
    
    return [self maskImage:shadowImage withMask:maskImage];
}


#pragma mark Draw Right Wall
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
    CGFloat sVGID_22_2Locations[] = {0.7, 1};
    CGGradientRef sVGID_22_2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_22_2Colors, sVGID_22_2Locations);
    
    UIGraphicsBeginImageContext(theFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, theFrame);
    
    CGFloat widthOffset = WALL_WIDTH_OFF_CENTER;
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
                                CGPointMake(CGRectGetMaxX(bezierBounds), CGRectGetMaxY(bezierBounds) - CGRectGetMidY(bezierBounds)/2),
                                CGPointMake(CGRectGetMinX(bezierBounds), CGRectGetMidY(bezierBounds)+SHADOW_OFF_INTERSECT),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    CGGradientRelease(sVGID_22_2);
    CGColorSpaceRelease(colorSpace);
    
    return [self maskImage:shadowImage withMask:maskImage];
}

#pragma mark Draw Left Wall
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
    CGFloat sVGID_24_2Locations[] = {0.50, 1};
    CGGradientRef sVGID_24_2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_24_2Colors, sVGID_24_2Locations);
    
    UIGraphicsBeginImageContext(theFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, theFrame);
    
//    CGFloat heightOffset = 20;
    CGFloat widthOffset = WALL_WIDTH_OFF_CENTER;
    CGContextMoveToPoint(context, self.midX-widthOffset, self.midY+2*widthOffset);
    CGContextAddLineToPoint(context, self.minX, self.maxY);
    CGContextAddLineToPoint(context, self.minX, self.minY);
    CGContextAddLineToPoint(context, self.midX-widthOffset, self.midY-widthOffset-8);
    CGContextAddLineToPoint(context, self.midX-widthOffset, self.midY+2*widthOffset);
    
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
                                CGPointMake(CGRectGetMinX(bezierBounds), CGRectGetMidY(bezierBounds)/2),
                                CGPointMake(CGRectGetMaxX(bezierBounds), (CGRectGetMidY(bezierBounds)+SHADOW_OFF_INTERSECT)),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    CGGradientRelease(sVGID_24_2);
    CGColorSpaceRelease(colorSpace);
    
    return [self maskImage:shadowImage withMask:maskImage];
}

#pragma mark Draw Left Wall
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
    CGFloat sVGID_25_2Locations[] = {0.7, 1};
    CGGradientRef sVGID_25_2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_25_2Colors, sVGID_25_2Locations);
    
    UIGraphicsBeginImageContext(theFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, theFrame);
    
//    CGFloat heightOffset = 20;
    CGFloat widthOffset = WALL_WIDTH_OFF_CENTER;
    CGContextMoveToPoint(context, self.midX-widthOffset, self.midY+2*widthOffset);
    CGContextAddLineToPoint(context, self.minX, self.maxY);
    CGContextAddLineToPoint(context, self.minX, self.minY);
    CGContextAddLineToPoint(context, self.midX-widthOffset, self.midY-widthOffset-8);
    CGContextAddLineToPoint(context, self.midX-widthOffset, self.midY+2*widthOffset);

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
                                CGPointMake(CGRectGetMinX(bezierBounds), CGRectGetMaxY(bezierBounds) - CGRectGetMidY(bezierBounds)/2),
                                CGPointMake(CGRectGetMaxX(bezierBounds), CGRectGetMidY(bezierBounds)+SHADOW_OFF_INTERSECT),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    CGGradientRelease(sVGID_25_2);
    CGColorSpaceRelease(colorSpace);
    
    return [self maskImage:shadowImage withMask:maskImage];
}

#pragma mark Draw Floor
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
    CGFloat sVGID_27_2Locations[] = {0.15, .4};
    CGGradientRef sVGID_27_2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_27_2Colors, sVGID_27_2Locations);
    
    UIGraphicsBeginImageContext(theFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    
    [[UIColor lightGrayColor] setFill];
    CGContextFillRect(context, theFrame);
    
//    CGFloat heightOffset = 20;
    CGFloat widthOffset = WALL_WIDTH_OFF_CENTER;
    CGContextMoveToPoint(context, self.minX, self.maxY);
    CGContextAddLineToPoint(context, self.maxX, self.maxY);
    CGContextAddLineToPoint(context, self.midX+widthOffset, self.midY+2*widthOffset);
    CGContextAddLineToPoint(context, self.midX-widthOffset, self.midY+2*widthOffset);
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
                                CGPointMake(CGRectGetMidX(bezierBounds), CGRectGetMaxY(bezierBounds)),
                                CGPointMake(CGRectGetMinX(bezierBounds), (CGRectGetMinY(bezierBounds)-SHADOW_OFF_INTERSECT)),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    CGGradientRelease(sVGID_27_2);
    CGColorSpaceRelease(colorSpace);
    
    return [self maskImage:shadowImage withMask:maskImage];
}

#pragma mark Draw Floor
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
    CGFloat sVGID_26_2Locations[] = {0.15, .4};
    CGGradientRef sVGID_26_2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_26_2Colors, sVGID_26_2Locations);

    UIGraphicsBeginImageContext(theFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    
    [[UIColor lightGrayColor] setFill];
    CGContextFillRect(context, theFrame);
    
//    CGFloat heightOffset = 20;
    CGFloat widthOffset = WALL_WIDTH_OFF_CENTER;
    CGContextMoveToPoint(context, self.minX, self.maxY);
    CGContextAddLineToPoint(context, self.maxX, self.maxY);
    CGContextAddLineToPoint(context, self.midX+widthOffset, self.midY+2*widthOffset);
    CGContextAddLineToPoint(context, self.midX-widthOffset, self.midY+2*widthOffset);
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
                                CGPointMake(CGRectGetMidX(bezierBounds), CGRectGetMaxY(bezierBounds)),
                                CGPointMake(CGRectGetMaxX(bezierBounds), (CGRectGetMinY(bezierBounds)-SHADOW_OFF_INTERSECT)),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    
    //    CGContextClipToMask(context, self.view.bounds, textureImage.CGImage);
    UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    CGGradientRelease(sVGID_26_2);
    CGColorSpaceRelease(colorSpace);
    
    return [self maskImage:shadowImage withMask:maskImage];
}

- (UIImage*)makeFloorImage
{
    CGRect theFrame = self.backgroundFrame;
    
    //// General Declarations
    UIGraphicsBeginImageContext(theFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, theFrame);
    
    //    CGFloat heightOffset = 20;
    CGFloat widthOffset = WALL_WIDTH_OFF_CENTER;
    CGContextMoveToPoint(context, self.minX, self.maxY);
    CGContextAddLineToPoint(context, self.maxX, self.maxY);
    CGContextAddLineToPoint(context, self.midX+widthOffset, self.midY+2*widthOffset);
    CGContextAddLineToPoint(context, self.midX-widthOffset, self.midY+2*widthOffset);
    CGContextAddLineToPoint(context, self.minX, self.maxY);
    CGRect bezierBounds = CGPathGetPathBoundingBox( CGContextCopyPath(context) );
    
    CGContextSetLineWidth(context, 0.5f);
    [[UIColor blackColor] setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);

    //draw floor image
    UIGraphicsBeginImageContext(theFrame.size);
    CGContextRef contextFloor = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(contextFloor, bezierBounds, [self.floorImage CGImage]);
    
    UIImage *floorImageCut = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(contextFloor);
    
    UIGraphicsBeginImageContext(theFrame.size);

    UIImage *warningImage = [UIImage imageNamed:@"warning_floor"];
    [warningImage drawInRect:CGRectMake(0.f, CGRectGetMaxY(theFrame)-40.f, CGRectGetWidth(theFrame), 40.f)];
    UIImage *warningFloor = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *floorWarning = [self maskImage:warningFloor withMask:maskImage];
    UIImage *floorFinal = [self maskImage:floorImageCut withMask:maskImage];
    return [self combineImages:@[floorFinal,floorWarning]];
}

-(UIImage*)renderFloorWith3DTransform:(UIImage*)image
{
    return image;
}

#pragma mark Draw Ceiling Wall
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
    CGFloat sVGID_1_4Locations[] = {0.3, 1};
    CGGradientRef sVGID_1_4 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_1_4Colors, sVGID_1_4Locations);
    
    CGFloat sVGID_linearLocations[] = {0.4, .6};
    CGGradientRef sVGIDlinear = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_1_4Colors, sVGID_linearLocations);
    
    UIGraphicsBeginImageContext(theFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, theFrame);
    
    CGFloat widthOffset = WALL_WIDTH_OFF_CENTER;
    CGRect frame = theFrame;
    CGContextMoveToPoint(context, self.maxX, self.minY);
    CGContextAddLineToPoint(context,self.minX, self.minY);
    CGContextAddLineToPoint(context,self.midX-widthOffset, self.midY-widthOffset);
    CGContextAddLineToPoint(context, self.midX-widthOffset, self.midY+widthOffset*2);
    CGContextAddLineToPoint(context, self.midX+widthOffset, self.midY+widthOffset*2);
    CGContextAddLineToPoint(context,self.midX+widthOffset, self.midY-widthOffset);
    CGContextAddLineToPoint(context,self.maxX, self.minY);
    
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
    
    CGContextDrawLinearGradient(context, sVGIDlinear,
                                CGPointMake(CGRectGetMidX(bezierBounds), CGRectGetMinY(bezierBounds)),
                                CGPointMake(CGRectGetMidX(bezierBounds), CGRectGetMaxY(bezierBounds)),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    //    CGContextClipToMask(context, self.view.bounds, textureImage.CGImage);
    UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    CGGradientRelease(sVGID_1_4);
    CGGradientRelease(sVGIDlinear);
    CGColorSpaceRelease(colorSpace);
    
    return [self maskImage:shadowImage withMask:maskImage];
}


#pragma mark Drawing Helper
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
