//
//  MMRGameOverScene.m
//  HoleInTheWall
//
//  Created by Matt Remick on 3/3/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "MMRGameOverScene.h"

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
    self.gameScene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:self.gameScene transition:[SKTransition doorwayWithDuration:1.0]];
}

@end
