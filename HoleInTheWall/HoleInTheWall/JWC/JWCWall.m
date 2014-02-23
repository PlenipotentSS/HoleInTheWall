//
//  JWCWall.m
//  HoleInTheWall
//
//  Created by Jeff Schwab on 2/23/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCWall.h"

@implementation JWCWall

- (instancetype)initWithScale:(CGFloat)scale andHole:(JWCHole *)hole withPosition:(CGPoint)holePosition
{
    if (self = [super init]) {
        self.holeInWall = hole;
        self.holeInWall.position = holePosition;
        
        self.size = CGSizeMake(320, 568);
        self.position = CGPointZero;
        self.color = [UIColor blueColor];
        self.xScale = scale;
        self.yScale = scale;
        
        [self addChild:self.holeInWall];
    }
    return self;
}

- (void)startMovingWithDuration:(CGFloat)duration
{
    SKAction *moveForwardAction = [SKAction scaleTo:1 duration:duration];

    [self runAction:moveForwardAction completion:^{
        
    }];
}

@end
