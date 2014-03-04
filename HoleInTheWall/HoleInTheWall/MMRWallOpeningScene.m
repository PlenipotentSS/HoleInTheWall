//
//  MMRWallOpeningScene.m
//  HoleInTheWall
//
//  Created by Matt Remick on 2/28/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "MMRWallOpeningScene.h"
#import "JWCWall.h"
#import "JWCScene.h"
#import "JWCHole.h"

@interface MMRWallOpeningScene() <UIGestureRecognizerDelegate> {
    BOOL _wallScaling;

}


@property (strong,nonatomic) SKLabelNode *holeLabel;
@property (strong,nonatomic) SKLabelNode *inTheLabel;
@property (strong,nonatomic) SKSpriteNode *startButton;
@property (strong,nonatomic) SKSpriteNode *gameCenterButton;


@end

@implementation MMRWallOpeningScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        self.wall = [[JWCWall alloc] initWithOpeningLabelAndScale:.2];
        
        [self addChild:self.wall];
        
        [self.wall startMovingWithDuration:6];
        _wallScaling = YES;
        self.holeLabel = [SKLabelNode labelNodeWithFontNamed:@"Prisma"];
        self.holeLabel.fontSize = 30;
        self.holeLabel.fontColor = [SKColor purpleColor];
        self.holeLabel.zPosition = 100;
        [self.holeLabel setScale:0.4f];
        
        self.holeLabel.text = @"Hole";
        self.holeLabel.position = CGPointMake(0, 150);
        [self addChild:self.holeLabel];
        
        self.inTheLabel = [SKLabelNode labelNodeWithFontNamed:@"Prisma"];
        self.inTheLabel.fontSize = 30; 
        self.inTheLabel.fontColor = [SKColor purpleColor];
        self.inTheLabel.zPosition = 100;
        [self.inTheLabel setScale:0.4f];
        
        self.inTheLabel.text = @"In The";
        self.inTheLabel.position = CGPointMake(0, 100);
        [self addChild:self.inTheLabel];
        
        self.startButton = [SKSpriteNode spriteNodeWithImageNamed:@"startButton"];
        self.startButton.zPosition = 100;
        self.startButton.position = CGPointMake(0, -200);
        self.startButton.name = @"startButton";
        self.startButton.alpha = 0.0f;
        [self addChild:self.startButton];
        
        self.gameCenterButton = [SKSpriteNode spriteNodeWithImageNamed:@"gameCenterButton"];
        self.gameCenterButton.zPosition = 100;
        self.gameCenterButton.position = CGPointMake(0, -130);
        self.gameCenterButton.name = @"gameCenterButton";
        self.gameCenterButton.alpha = 0.0f;
        [self addChild:self.gameCenterButton];

    }
    
    return self; 
}

- (void)update:(NSTimeInterval)currentTime
{
    //NSLog(@"WALL Y Sscale:%f",self.wall.yScale);
    
    if (self.wall.yScale >= .7 && self.wall.yScale <= .705 ) {
        _wallScaling = NO;
        //[self.wall removeAllActions];
        //scale wall
        SKAction *scaleWall = [SKAction scaleTo:2.0f duration:0.2f];
        SKAction *scaleHoleLabel = [SKAction scaleTo:3.0f duration:0.2f];
        SKAction *moveHoleLabel = [SKAction moveTo:CGPointMake(0, 150) duration:0.2];
        SKAction *scaleInTheLabel = [SKAction scaleTo:3.0 duration:0.2f];
        SKAction *moveInTheLabel = [SKAction moveTo:CGPointMake(0, 70) duration:0.2];
        
        SKAction *holeLabelGroup = [SKAction group:@[scaleHoleLabel,moveHoleLabel]];
        SKAction *inTheLabelGroup = [SKAction group:@[scaleInTheLabel,moveInTheLabel]];
        
        SKAction *fadeInStartButton = [SKAction fadeAlphaTo:1.0f duration:.3];
        SKAction *fadeInGameCenterButton = [SKAction fadeAlphaTo:1.0f duration:.3];

        
        [self.wall runAction:scaleWall completion:^{
            [self.wall removeAllActions];
            [self.startButton runAction:fadeInStartButton];
            [self.gameCenterButton runAction:fadeInGameCenterButton];
        }];
        [self.holeLabel runAction:holeLabelGroup];
        [self.inTheLabel runAction:inTheLabelGroup];
        
        
        
        //scale labels with wall
        NSLog(@"WALL SCALE");
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //if fire button touched, bring the rain
    if ([node.name isEqualToString:@"startButton"]) {
        JWCScene* gameScene = [[JWCScene alloc] initWithSize:self.size];
        gameScene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:gameScene transition:[SKTransition doorwayWithDuration:1.0]];
        
    }
    
    if ([node.name isEqualToString:@"gameCenterButton"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:/me/account"]];
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:/games/recommendations"]];


    }
}

@end
