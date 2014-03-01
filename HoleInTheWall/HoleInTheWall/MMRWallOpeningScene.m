//
//  MMRWallOpeningScene.m
//  HoleInTheWall
//
//  Created by Matt Remick on 2/28/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "MMRWallOpeningScene.h"
#import "JWCWall.h"

@interface MMRWallOpeningScene() {
    BOOL _wallScaling;

}

@end

@implementation MMRWallOpeningScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        self.wall = [[JWCWall alloc] initWithScale:.2];
        [self addChild:self.wall];
        
        [self.wall startMovingWithDuration:6];
        _wallScaling = YES;

    }
    
    return self; 
}

@end
