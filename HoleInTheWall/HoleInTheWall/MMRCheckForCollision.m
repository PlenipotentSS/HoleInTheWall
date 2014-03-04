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
    CGFloat xOff = abs(playerShape.position.x-hole.position.x);
    CGFloat yOff = abs(playerShape.position.y-hole.position.y);
    NSLog(@"shape off by x: %f",xOff);
    NSLog(@"shape off by y: %f",yOff);
    
    NSLog(@"shape size w: %f h: %f",playerShape.size.width,playerShape.size.height);
    NSLog(@"hole size w: %f h: %f",hole.size.width,hole.size.height);
    
    if (playerShape.shapeType != hole.shapeType) {
        return YES;
    } else if (playerShape.position.x <= hole.position.x - 12 || playerShape.position.x >= hole.position.x + 12 || playerShape.position.y <= hole.position.y - 12 || playerShape.position.y >= hole.position.y + 12) {
        return YES;
    } else {
        return NO;
    }
}


@end
