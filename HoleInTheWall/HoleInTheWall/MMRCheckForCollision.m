//
//  MMRCheckForCollision.m
//  HoleInTheWall
//
//  Created by Matt Remick on 2/26/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "MMRCheckForCollision.h"

@implementation MMRCheckForCollision

- (BOOL)checkForCollision:(JWCShape *)playerShape andHoleInTheWall:(JWCHole *)hole
{
    
    
    if (!hole) {
        return YES;
    }
    
    else if (playerShape.position.x <= hole.position.x - 8 || playerShape.position.x >= hole.position.x + 8 || playerShape.position.y <= hole.position.y - 8 || playerShape.position.y >= hole.position.y + 8) {
        
        NSLog(@"COLLISION");
        return YES;
    } else {
        return NO;
    }
}


@end
