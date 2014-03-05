//
//  JWCResetScene.m
//  HoleInTheWall
//
//  Created by Jeff Schwab on 3/5/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCResetScene.h"
#import "JWCScene.h"

@implementation JWCResetScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        JWCScene *gameScene = [[JWCScene alloc] initWithSize:self.size];
        gameScene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:gameScene transition:[SKTransition flipVerticalWithDuration:.3]];
    }
    return self;
}

@end
