//
//  JWCWall.m
//  HoleInTheWall
//
//  Created by Jeff Schwab on 2/23/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCWall.h"

@implementation JWCWall

- (instancetype)initWithScale:(CGFloat)scale
{
    if (self = [super init]) {
        
        UIImage *wallImage = [UIImage imageNamed:@"bluewalls"];
        SKTexture *texture = [SKTexture textureWithImage:wallImage];
        self = [JWCWall spriteNodeWithTexture:texture];
        self.size = [UIScreen mainScreen].bounds.size;
        self.position = CGPointZero;
        self.xScale = scale;
        self.yScale = scale;
        
        [self generateHole];
    }
    return self;
}

- (void)startMovingWithDuration:(CGFloat)duration
{
    SKAction *moveForwardAction = [SKAction scaleTo:1 duration:duration];
    SKAction *scaleOffAction = [SKAction scaleTo:5 duration:.1];
    
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
    NSLog(@"%i", randomHole);
    
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
    
    
    
    self.holeInWall.position = CGPointZero;

    [self addChild:self.holeInWall];
}

#pragma mark - Hole Making Methods
- (SKTexture *)setHoleInWallMaskWithShapeName:(NSString *)shapeName
{
    UIImage *wallImage = [UIImage imageNamed:@"bluewalls"];
    UIImage *squareImage = [UIImage imageNamed:shapeName];
    CGRect contextFrame = self.frame;
    contextFrame.origin.x = CGRectGetMidX(self.frame);
    contextFrame.origin.y = CGRectGetMinY(self.frame)-CGRectGetMinY(self.frame);
    
    UIGraphicsBeginImageContext(contextFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] setFill];
    CGContextFillRect(context, contextFrame);
    
    CGPoint center = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame));
    
    CGFloat unscaledX = 50;
    CGFloat unscaledY = 50;
    
    [[UIColor whiteColor] setFill];
    [squareImage drawInRect:CGRectMake(center.x-unscaledX/2, center.y-unscaledY/2, unscaledX, unscaledY)];
    
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    UIImage *theWall = [self maskImage:wallImage withMask:maskImage];
    return [SKTexture textureWithImage:theWall];
}

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
	CGImageRef imgRef = [image CGImage];
    CGImageRef maskRef = [maskImage CGImage];
    CGImageRef actualMask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                              CGImageGetHeight(maskRef),
                                              CGImageGetBitsPerComponent(maskRef),
                                              CGImageGetBitsPerPixel(maskRef),
                                              CGImageGetBytesPerRow(maskRef),
                                              CGImageGetDataProvider(maskRef), NULL, false);
    CGImageRef masked = CGImageCreateWithMask(imgRef, actualMask);
    return [UIImage imageWithCGImage:masked];
    
}

@end
