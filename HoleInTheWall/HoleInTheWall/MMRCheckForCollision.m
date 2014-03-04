//
//  MMRCheckForCollision.m
//  HoleInTheWall
//
//  Created by Matt Remick on 2/26/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "MMRCheckForCollision.h"

@implementation MMRCheckForCollision

+ (BOOL)checkForCollision:(JWCShape *)playerShape andHoleInTheWall:(JWCHole *)hole
{
    CGFloat playerShapeRadius = playerShape.size.height / 2;
    CGFloat holeRadius = hole.size.height / 2;
    
    CGFloat comparator = holeRadius - playerShapeRadius;
    
    NSLog(@"Comparator: %f",comparator);
    
    if (playerShape.shapeType != hole.shapeType) {
        return YES;
    } else if (playerShape.position.x <= hole.position.x - 12 || playerShape.position.x >= hole.position.x + 12 || playerShape.position.y <= hole.position.y - 12 || playerShape.position.y >= hole.position.y + 12) {
        return YES;
    } else {
        return NO;
    }
    
    
    
}


@end
