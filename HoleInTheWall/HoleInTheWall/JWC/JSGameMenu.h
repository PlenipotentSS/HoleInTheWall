//
//  JSGameMenu.h
//  JSGameMenu
//
//  Created by Jared Sealey on 9/22/13.
//  Copyright (c) 2013 Jared Sealey. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JSGameMenu : SKSpriteNode

@property SKSpriteNode *pause;
@property SKSpriteNode *play;
@property SKSpriteNode *replay;
@property SKSpriteNode *exit;

@property (nonatomic, strong) dispatch_block_t replayHandler;
@property (nonatomic, strong) dispatch_block_t exitHandler;

-(id)initWithSize:(CGSize)size withReplayHandler:(dispatch_block_t)replay withExitHandler:(dispatch_block_t)exit;
-(id)initWithSize:(CGSize)size withColorTheme:(UIColor*)theme withReplayHandler:(dispatch_block_t)replay withExitHandler:(dispatch_block_t)exit;

-(void) handleTouch:(NSSet *)touches withEvent:(UIEvent *)event;


@end
