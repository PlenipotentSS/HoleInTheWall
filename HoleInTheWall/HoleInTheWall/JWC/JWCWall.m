//
//  JWCWall.m
//  HoleInTheWall
//
//  Created by Jeff Schwab on 2/23/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCWall.h"

#define MAX_SCALE 5
#define SHAPE_SIZE 1000

@interface JWCWall ()

{
    BOOL _wallInitedWithSize;
    CGPoint _holeCenter;
}

@property (nonatomic) UIImage *wallImage;
@property (nonatomic) SKTexture *texture;
@property (nonatomic) UIImage *holeImage;

@end

@implementation JWCWall

- (instancetype)initWithScale:(CGFloat)scale
{
    if (self = [super init]) {
        
        self = [JWCWall spriteNodeWithImageNamed:@"purty_wood"];
        self.wallImage = [UIImage imageNamed:@"purty_wood"];
        self.size = [UIScreen mainScreen].bounds.size;
        self.position = CGPointZero;
        self.xScale = scale;
        self.yScale = scale;
        
        [self setScale:MAX_SCALE];
        [self generateHole];
        [self setScale:.2];
    }

    return self;
}

- (instancetype)initWithOpeningLabelAndScale:(CGFloat)scale
{
    if (self = [super init]) {
        self = [JWCWall spriteNodeWithImageNamed:@"purty_wood"];
        self.wallImage = [UIImage imageNamed:@"purty_wood"];
        self.size = [UIScreen mainScreen].bounds.size;
        self.position = CGPointZero;
        self.xScale = scale;
        self.yScale = scale;
        
        self.texture = [self setHoleInWallMaskWithShapeName:@"whiteWallText"];
    }
    
    return self;
}

- (void)startMovingWithDuration:(CGFloat)duration
{
    [self removeAllActions];
    
    SKAction *moveForwardAction = [SKAction scaleTo:1 duration:duration];
    SKAction *scaleOffAction = [SKAction scaleTo:MAX_SCALE duration:.1];
    
    [self runAction:moveForwardAction completion:^{
        [self runAction:scaleOffAction completion:^{
            [self generateHole];
            [self setScale:.2];
            [self startMovingWithDuration:5];
        }];
    }];
}

- (void)generateHole
{
    if ([self.children containsObject:self.holeInWall]) {
        [self.holeInWall removeFromParent];
    }
    
    int randomHole = arc4random() % 3;
    
    switch (randomHole) {
        case 0:
            self.holeInWall = [[JWCHole alloc] initWithShapeType:JWCShapeTypeSquare
                                                       shapeSize:CGSizeMake(150, 150)];
            self.texture = [self setHoleInWallMaskWithShapeName:@"squaremask"];
            break;
        case 1:
            self.holeInWall = [[JWCHole alloc] initWithShapeType:JWCShapeTypeTriangle
                                                       shapeSize:CGSizeMake(150, 150)];
            self.texture = [self setHoleInWallMaskWithShapeName:@"trianglemask"];
            break;
        case 2:
            self.holeInWall = [[JWCHole alloc] initWithShapeType:JWCShapeTypeCircle
                                                       shapeSize:CGSizeMake(150, 150)];
            self.texture = [self setHoleInWallMaskWithShapeName:@"circlemask"];
            break;
    }

    self.holeInWall.position = [self convertHoleCenterFromMask:_holeCenter];

    [self addChild:self.holeInWall];
}

#pragma mark - Hole Making Methods
- (SKTexture *)setHoleInWallMaskWithShapeName:(NSString *)shapeName
{
    self.holeImage = [UIImage imageNamed:shapeName];
    CGRect contextFrame = self.frame;
    contextFrame.origin.x = CGRectGetMidX(self.frame);
    contextFrame.origin.y = CGRectGetMinY(self.frame)-CGRectGetMinY(self.frame);
    
    UIGraphicsBeginImageContext(contextFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] setFill];
    CGContextFillRect(context, contextFrame);
    
    NSInteger maxXChange = CGRectGetWidth(self.frame)-SHAPE_SIZE;
    NSInteger maxYChange = CGRectGetHeight(self.frame)-SHAPE_SIZE;
    
    CGFloat randomX = arc4random() % maxXChange;
    randomX -= maxXChange/2;
    
    CGFloat randomY = arc4random() % maxYChange;
    randomY -= maxYChange/2;
    
    self.holeCenter = CGPointMake(CGRectGetMaxX(self.frame)+randomX, CGRectGetMaxY(self.frame)+randomY);
    
    CGFloat unscaledX = SHAPE_SIZE;
    CGFloat unscaledY = SHAPE_SIZE;
    
    [[UIColor whiteColor] setFill];
    [self.holeImage drawInRect:CGRectMake(_holeCenter.x-unscaledX/2, _holeCenter.y-unscaledY/2, unscaledX, unscaledY)];
    
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    UIImage *theWall = [self maskImage:self.wallImage withMask:maskImage];
    return [SKTexture textureWithImage:theWall];
}

- (CGPoint)convertHoleCenterFromMask:(CGPoint)holeCenter
{
    CGPoint newCenter = holeCenter;
    newCenter.x = (holeCenter.x-CGRectGetMaxX(self.frame))/MAX_SCALE;
    newCenter.y = -(holeCenter.y-CGRectGetMaxY(self.frame))/MAX_SCALE;
    return newCenter;
}

- (UIImage *) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
	CGImageRef imgRef = [image CGImage];
    CGImageRef maskRef = [maskImage CGImage];
    CGImageRef actualMask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                              CGImageGetHeight(maskRef),
                                              CGImageGetBitsPerComponent(maskRef),
                                              CGImageGetBitsPerPixel(maskRef),
                                              CGImageGetBytesPerRow(maskRef),
                                              CGImageGetDataProvider(maskRef), NULL, false);
    CGImageRef masked = CGImageCreateWithMask(imgRef, actualMask);
    UIImage *maskedImage = [UIImage imageWithCGImage:masked];
    
    imgRef = nil;
    maskRef = nil;
    CGImageRelease(actualMask);
    CGImageRelease(masked);
    
    return maskedImage;
}

@end
