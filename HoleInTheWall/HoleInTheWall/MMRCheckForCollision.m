//
//  MMRCheckForCollision.m
//  HoleInTheWall
//
//  Created by Matt Remick on 2/26/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "MMRCheckForCollision.h"
#import "JWCWall.h"

@implementation MMRCheckForCollision

+ (BOOL)checkForCollision:(JWCShape *)playerShape andHole:(JWCHole *)hole inWall:(JWCWall *)wall
{
    CGFloat playerShapeRadius = playerShape.size.height / 2;
    CGFloat holeRadius = hole.size.height / 2;
    
    CGFloat comparator = holeRadius - playerShapeRadius+10;
    
    if (playerShape.shapeType != hole.shapeType) {
        return YES;
    }
    
    else if (playerShape.position.x <= hole.position.x - comparator || playerShape.position.x >= hole.position.x + comparator || playerShape.position.y <= hole.position.y - comparator || playerShape.position.y >= hole.position.y + comparator) {
        return YES;
    } else {
        return NO;
    }
}


@end
