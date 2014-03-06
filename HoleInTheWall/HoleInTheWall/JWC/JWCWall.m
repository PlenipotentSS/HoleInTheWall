//
//  JWCWall.m
//  HoleInTheWall
//
//  Created by Jeff Schwab on 2/23/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCWall.h"
#import "UIImage+SSImageShadow.h"

#define MAX_SCALE 5
#define SHAPE_SIZE [JWCDimensions sharedController].size.width*6

@interface JWCWall ()

{
    NSInteger _wallsPassed;
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
        self.position = CGPointMake(CGPointZero.x, CGPointZero.y-70);
        
        [self setScale:MAX_SCALE];
        [self generateHole];
        [self setScale:.2];
        
        _wallsPassed = 0;
    }

    return self;
}

- (instancetype)initWithOpeningLabelAndScale:(CGFloat)scale
{
    if (self = [super init]) {
        
        self = [JWCWall spriteNodeWithImageNamed:@"purty_wood"];
        self.wallImage = [UIImage imageNamed:@"purty_wood"];
        self.size = [UIScreen mainScreen].bounds.size;
        self.position = CGPointMake(CGPointZero.x, CGPointZero.y-65);
        self.xScale = scale;
        self.yScale = scale;
        
        [self setScale:MAX_SCALE];
        self.holeInWall = [[JWCHole alloc] initWithShapeType:JWCShapeTypeWallLabel shapeSize:CGSizeMake(100, 100)];
        self.texture = [self setHoleInWallMaskWithShapeName:@"whiteWallText"];
        self.holeInWall.position = CGPointZero;
        [self addChild:self.holeInWall];
        [self setScale:.2];
    }
    
    return self;
}

- (void)startMovingWithDuration:(CGFloat)duration
{
    [self removeAllActions];
    
    self.wallPassed = NO;
    
    NSInteger randomWallNumber = (arc4random() % 5) + 1;
    if (_wallsPassed > 2 && _wallsPassed % randomWallNumber == 0) {
        duration = randomWallNumber % 4 + 1;
    }
    _wallsPassed++;
    self.position = CGPointMake(CGPointZero.x, CGPointZero.y-65);
    
    SKAction *moveForwardAction = [SKAction scaleTo:.92 duration:duration];
    SKAction *moveToAction = [SKAction moveTo:CGPointMake(CGPointZero.x, CGPointZero.y) duration:duration];
    
    SKAction *scaleOffAction = [SKAction scaleTo:MAX_SCALE duration:.1];
    
    SKAction *groupOfActions = [SKAction group:@[moveForwardAction, moveToAction]];
    
    [self runAction:groupOfActions completion:^{
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
    
    int randomHole = arc4random() % 4;
    
    CGSize holeSize = [JWCDimensions sharedController].size;
    
    switch (randomHole) {
        case 0:
            self.holeInWall = [[JWCHole alloc] initWithShapeType:JWCShapeTypeSquare
                                                       shapeSize:holeSize];
            self.texture = [self setHoleInWallMaskWithShapeName:@"squaremask"];
            break;
        case 1:
            self.holeInWall = [[JWCHole alloc] initWithShapeType:JWCShapeTypeTriangle
                                                       shapeSize:holeSize];
            self.texture = [self setHoleInWallMaskWithShapeName:@"trianglemask"];
            break;
        case 2:
            self.holeInWall = [[JWCHole alloc] initWithShapeType:JWCShapeTypeCircle
                                                       shapeSize:holeSize];
            self.texture = [self setHoleInWallMaskWithShapeName:@"circlemask"];
            break;
        case 3:
            self.holeInWall = [[JWCHole alloc] initWithShapeType:JWCShapeTypeW
                                                       shapeSize:holeSize];
            self.texture = [self setHoleInWallMaskWithShapeName:@"wmask"];
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
    CGContextFillRect(context, CGRectMake(WALL_OUTER_SHADOW_SIDE/2,WALL_OUTER_SHADOW_TOPBOTTOM/2,CGRectGetWidth(contextFrame)-WALL_OUTER_SHADOW_SIDE,CGRectGetHeight(contextFrame)-WALL_OUTER_SHADOW_TOPBOTTOM));
    
    NSInteger maxXChange = CGRectGetWidth(self.frame)-(SHAPE_SIZE+WALL_OUTER_SHADOW_SIDE);
    NSInteger maxYChange = CGRectGetHeight(self.frame)-(SHAPE_SIZE+WALL_OUTER_SHADOW_TOPBOTTOM);
    
    CGFloat randomX = arc4random() % maxXChange;
    randomX -= maxXChange/2;
    
    CGFloat randomY = arc4random() % maxYChange;
    randomY -= maxYChange/2;
    
    self.holeCenter = CGPointMake(CGRectGetMaxX(self.frame)+randomX, CGRectGetMaxY(self.frame)+randomY);
    
    CGFloat unscaledX = SHAPE_SIZE;
    CGFloat unscaledY = SHAPE_SIZE;
    
    if ([shapeName isEqualToString:@"whiteWallText"]) {
        self.holeCenter = CGPointMake(CGRectGetWidth(self.frame)*.5-45, CGRectGetHeight(self.frame)*.5-30);
        unscaledX -= 150;
        unscaledY -= 150;
    }
    
    [[UIColor whiteColor] setFill];
    [self.holeImage drawInRect:CGRectMake(_holeCenter.x-unscaledX/2, _holeCenter.y-unscaledY/2, unscaledX, unscaledY)];
    
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);

//    //back wall mask
//    unscaledX = unscaledX*.95;
//    unscaledY = unscaledY*.95;
//    UIGraphicsBeginImageContext(contextFrame.size);
//    CGContextRef backImageContext = UIGraphicsGetCurrentContext();
//    
//    [[UIColor blackColor] setFill];
//    CGContextFillRect(backImageContext, CGRectMake(WALL_OUTER_SHADOW_SIDE/2,WALL_OUTER_SHADOW_TOPBOTTOM/2,CGRectGetWidth(contextFrame)-WALL_OUTER_SHADOW_SIDE,CGRectGetHeight(contextFrame)-WALL_OUTER_SHADOW_TOPBOTTOM));
//    
//    CGFloat xPos =_holeCenter.x-unscaledX/2;
//    CGFloat yPos = _holeCenter.y-unscaledY/2;
//    
//    CGFloat backWallOffValue = 100.f;
//    
//    if (_holeCenter.x < CGRectGetMidX(contextFrame)) {
//        CGFloat xOff = (CGRectGetMidX(contextFrame)-_holeCenter.x)/CGRectGetMidX(contextFrame);
//        xPos += backWallOffValue*xOff;
//    } else {
//        CGFloat xOff = (_holeCenter.x-CGRectGetMidX(contextFrame))/_holeCenter.x;
//        xPos -= backWallOffValue*xOff;
//    }
//    
//    if (_holeCenter.y < CGRectGetMidY(contextFrame)) {
//        CGFloat yOff = (CGRectGetMidY(contextFrame)-_holeCenter.y )/CGRectGetMidY(contextFrame);
//        yPos += backWallOffValue*yOff;
//    } else {
//        CGFloat yOff = (_holeCenter.y-CGRectGetMidY(contextFrame))/_holeCenter.y;
//        yPos -= backWallOffValue*yOff;
//    }
//    
//    [[UIColor whiteColor] setFill];
//    [self.holeImage drawInRect:CGRectMake(xPos, yPos, unscaledX, unscaledY)];
//    
//    UIImage *backWallImageMask = UIGraphicsGetImageFromCurrentImageContext();
//    CGContextRelease(backImageContext);
//    
//    //full black mask
//    UIGraphicsBeginImageContext(contextFrame.size);
//    CGContextRef fullFillContext = UIGraphicsGetCurrentContext();
//    
//    [self.wallImage drawInRect:CGRectMake(WALL_OUTER_SHADOW_SIDE/2,WALL_OUTER_SHADOW_TOPBOTTOM/2,CGRectGetWidth(contextFrame)-WALL_OUTER_SHADOW_SIDE,CGRectGetHeight(contextFrame)-WALL_OUTER_SHADOW_TOPBOTTOM)];
//    
//    [[UIColor colorWithRed:0.1f green:0.1f blue:.1f alpha:.85f] setFill];
//    CGContextFillRect(fullFillContext, CGRectMake(25.f,2.5f,CGRectGetWidth(contextFrame)-50.f,CGRectGetHeight(contextFrame)-5.f));
//    
//    UIImage *blackImage = UIGraphicsGetImageFromCurrentImageContext();
//    CGContextRelease(fullFillContext);
//    
//    //combine images and masks
//    UIImage *backWallImage = [self maskImage:blackImage withMask:backWallImageMask];
//    UIImage *shadowWallImage = [UIImage createShadowBoxImageWithImage:self.wallImage forSize:contextFrame.size];
    UIImage *theWall = [self maskImage:self.wallImage withMask:maskImage];
//    theWall = [UIImage combineImages:@[backWallImage,theWall] withSize:contextFrame.size];
    
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
