//
//  OpeningScene.m
//  HoleInTheWall
//
//  Created by Matt Remick on 2/25/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "OpeningScene.h"

@interface OpeningScene()

@property (strong,nonatomic) SKLabelNode *holeLabel;
@property (strong,nonatomic) SKLabelNode *inTheLabel;
@property (strong,nonatomic) SKLabelNode *wallLabel;

@end

@implementation OpeningScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        

        self.holeLabel = [SKLabelNode labelNodeWithFontNamed:@"Prisma"];
        self.holeLabel.fontSize = 50;
        self.holeLabel.fontColor = [SKColor yellowColor];
        self.holeLabel.zPosition = 100;
        
        self.holeLabel.text = @"Hole";
        self.holeLabel.position = CGPointMake(-600, self.size.height - 180);
        [self addChild:self.holeLabel];
        
        self.inTheLabel = [SKLabelNode labelNodeWithFontNamed:@"Prisma"];
        self.inTheLabel.fontSize = 50;
        self.inTheLabel.fontColor = [SKColor yellowColor];
        self.inTheLabel.zPosition = 100;
        
        self.inTheLabel.text = @"In The";
        self.inTheLabel.position = CGPointMake(600, self.size.height - 250);
        [self addChild:self.inTheLabel];
        
        self.wallLabel = [SKLabelNode labelNodeWithFontNamed:@"Prisma"];
        
        self.wallLabel.hidden = YES;
        
        self.wallLabel.fontSize = 100;
        self.wallLabel.fontColor = [SKColor yellowColor];
        self.wallLabel.zPosition = 100;
        
        self.wallLabel.text = @"WALL";
        self.wallLabel.position = CGPointMake(self.size.width / 2, self.size.height - 320);
        [self addChild:self.wallLabel];
        
        [self performSelector:@selector(performSKActions) withObject:nil afterDelay:.4];
        
//        [wallLabel runAction:moveForwardAction completion:^{
//            [wallLabel runAction:scaleOffAction completion:^{
//                
//            }];
//        }];
        
        
    }
    return self;
}

- (void)performSKActions
{
    SKAction *moveForwardAction = [SKAction scaleTo:1 duration:0.5];
    SKAction *scaleOffAction = [SKAction scaleTo:100 duration:2.0];
    
    SKAction *moveInHoleLabel = [SKAction moveTo:CGPointMake(self.size.width / 2, self.size.height - 180) duration:.4];
    SKAction *moveInInTheLabel = [SKAction moveTo:CGPointMake(self.size.width / 2, self.size.height - 225) duration:.4];
    
    [self.holeLabel runAction:moveInHoleLabel completion:^{
        [self.inTheLabel runAction:moveInInTheLabel completion:^{
            self.wallLabel.hidden = NO;
            [self performSelector:@selector(scaleWall) withObject:nil afterDelay:.5];
            
        }];
    }];
    
}

- (void)scaleWall
{
    SKAction *scaleWall = [SKAction scaleTo:23 duration:2.4];
    [self.wallLabel runAction:scaleWall completion:^{
        self.wallLabel.hidden = YES;
        SKAction *scaleWallToNormal = [SKAction scaleTo:1 duration:0.01];
        [self.wallLabel runAction:scaleWallToNormal completion:^{
            self.wallLabel.alpha = 0;
            self.wallLabel.hidden = NO;
            SKAction *fadeWallLabelIn = [SKAction fadeInWithDuration:2.0];
            [self.wallLabel runAction:fadeWallLabelIn];
            
        }];
    }];
}

@end
