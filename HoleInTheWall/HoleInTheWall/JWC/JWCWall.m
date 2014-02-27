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
        [self generateHole];
        
        self = [JWCWall spriteNodeWithImageNamed:@"skulls"];
        
        self.size = [UIScreen mainScreen].bounds.size;
        self.position = CGPointZero;
        self.xScale = scale;
        self.yScale = scale;
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
    
    int randomHole = arc4random() % 4;
    NSLog(@"%i", randomHole);
    
    switch (randomHole) {
        case 0:
            self.holeInWall = [[JWCHole alloc] initWithShapeType:JWCShapeTypeSquare
                                                       shapeSize:CGSizeMake(150, 160)];
            break;
        case 1:
            self.holeInWall = [[JWCHole alloc] initWithShapeType:JWCShapeTypeTriangle
                                                       shapeSize:CGSizeMake(150, 160)];
            break;
        case 2:
            self.holeInWall = [[JWCHole alloc] initWithShapeType:JWCShapeTypeRectangle
                                                       shapeSize:CGSizeMake(100, 250)];
            break;
        case 3:
            self.holeInWall = [[JWCHole alloc] initWithShapeType:JWCShapeTypeCircle
                                                       shapeSize:CGSizeMake(150, 150)];
            break;
    }
    
    
    
    self.holeInWall.position = CGPointZero;
    [self addChild:self.holeInWall];
}

@end
