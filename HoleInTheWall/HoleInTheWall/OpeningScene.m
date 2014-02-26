//
//  OpeningScene.m
//  HoleInTheWall
//
//  Created by Matt Remick on 2/25/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "OpeningScene.h"

@implementation OpeningScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */

        SKLabelNode* holeLabel = [SKLabelNode labelNodeWithFontNamed:@"Prisma"];
        holeLabel.fontSize = 50;
        holeLabel.fontColor = [SKColor yellowColor];
        holeLabel.zPosition = 100;
        
        holeLabel.text = @"Hole";
        holeLabel.position = CGPointMake(self.size.width / 2, self.size.height - 180);
        [self addChild:holeLabel];
        
        SKLabelNode* inTheLabel = [SKLabelNode labelNodeWithFontNamed:@"Prisma"];
        inTheLabel.fontSize = 50;
        inTheLabel.fontColor = [SKColor yellowColor];
        inTheLabel.zPosition = 100;
        
        inTheLabel.text = @"In The";
        inTheLabel.position = CGPointMake(self.size.width / 2, self.size.height - 225);
        [self addChild:inTheLabel];
        
        SKLabelNode* wallLabel = [SKLabelNode labelNodeWithFontNamed:@"Prisma"];
        wallLabel.fontSize = 100;
        wallLabel.fontColor = [SKColor yellowColor];
        wallLabel.zPosition = 100;
        
        wallLabel.text = @"WALL";
        wallLabel.position = CGPointMake(self.size.width / 2, self.size.height - 320);
        [self addChild:wallLabel];
        
        SKAction *moveForwardAction = [SKAction scaleTo:1 duration:0.5];
        SKAction *scaleOffAction = [SKAction scaleTo:175 duration:0.5];
        
        SKAction *scaleBack = [SKAction scaleTo:1 duration:1.5];
        
        
//        [wallLabel runAction:moveForwardAction completion:^{
//            [wallLabel runAction:scaleOffAction completion:^{
//                
//            }];
//        }];
        
        [holeLabel runAction:moveForwardAction completion:^{
            [holeLabel runAction:scaleOffAction completion:^{
                [inTheLabel runAction:moveForwardAction completion:^{
                    [inTheLabel runAction:scaleOffAction completion:^{
                        [wallLabel runAction:moveForwardAction completion:^{
                            [wallLabel runAction:scaleOffAction completion:^{
                                [holeLabel runAction:scaleBack];
                                [inTheLabel runAction:scaleBack];
                                [wallLabel runAction:scaleBack];
                                
                                
                            }];
                        }];

                    }];
                }];
            }];
        }];
    }
    return self;
}

@end
