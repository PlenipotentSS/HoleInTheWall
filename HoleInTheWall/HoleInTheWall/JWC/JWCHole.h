//
//  JWCHole.h
//  HoleInTheWall
//
//  Created by Jeff Schwab on 2/23/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "JWCShape.h"

@interface JWCHole : SKSpriteNode

- (instancetype)initWithShapeType:(JWCShapeType)holeShape shapeSize:(CGSize)shapeSize;

@property (nonatomic) JWCShapeType shapeType;

@end
