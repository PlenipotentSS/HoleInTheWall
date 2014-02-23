//
//  JWCWall.h
//  HoleInTheWall
//
//  Created by Jeff Schwab on 2/23/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "JWCHole.h"

@interface JWCWall : SKSpriteNode

- (instancetype)initWithScale:(CGFloat)scale andHole:(JWCHole *)hole withPosition:(CGPoint)holePosition;
- (void)startMovingWithDuration:(CGFloat)duration;

@property (nonatomic) JWCHole *holeInWall;

@end
