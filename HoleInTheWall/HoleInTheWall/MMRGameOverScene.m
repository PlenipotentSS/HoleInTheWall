//
//  MMRGameOverScene.m
//  HoleInTheWall
//
//  Created by Matt Remick on 3/3/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "MMRGameOverScene.h"
#import "JWCScene.h"

@implementation MMRGameOverScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Avenir"];
        gameOverLabel.text = @"Game Over";
        gameOverLabel.position = CGPointMake(100, 100);
        [self addChild:gameOverLabel];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    JWCScene* gameScene = [[JWCScene alloc] initWithSize:self.size];
    gameScene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:gameScene transition:[SKTransition doorwayWithDuration:1.0]];
}

@end
