//
//  JWCShape.h
//  HoleInTheWall
//
//  Created by Jeff Schwab on 2/23/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "JWCShapeType.h"

@interface JWCShape : SKSpriteNode

@property (nonatomic) JWCShapeType shapeType;

/**
 * Returns a shape using the proper file based on the shapeType, and with size.
 */
- (instancetype)initWithShapeType:(JWCShapeType)shapeType size:(CGSize)size;

@end
