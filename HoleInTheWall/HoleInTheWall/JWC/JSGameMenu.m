//
//  JSGameMenu.m
//  JSGameMenu
//
//  Created by Jared Sealey on 9/22/13.
//  Copyright (c) 2013 Jared Sealey. All rights reserved.
//

#import "JSGameMenu.h"

@implementation JSGameMenu

#define FRONT 1001
#define BACK  1000


-(id)initWithSize:(CGSize)size  withReplayHandler:(dispatch_block_t)replay withExitHandler:(dispatch_block_t)exit {
    return [self initWithSize:size withColorTheme:[UIColor grayColor] withReplayHandler:replay withExitHandler:exit];
}

-(id)initWithSize:(CGSize)size withColorTheme:(UIColor*)theme  withReplayHandler:(dispatch_block_t)replay withExitHandler:(dispatch_block_t)exit{
    if (self = [super init]) {
        
        /* Set the position of the game menu to the top right corner of the current frame */
        self.position = CGPointMake(size.width - 25, size.height - 30);
        
        /* Set up PAUSE button */
        [self addButtonWithSprite:&_pause withImageName:@"pause" withColor:theme withSize:CGSizeMake(50,50)  withPosition:CGPointMake(_pause.position.x, _pause.position.y - 10)];
        
        /* Set up PLAY button */
        [self addButtonWithSprite:&_play withImageName:@"play" withColor:theme withSize:CGSizeMake(44,44)  withPosition:CGPointMake(-15, -30)];
        
        /* Set up REPLAY button */
        [self addButtonWithSprite:&_replay withImageName:@"replay" withColor:theme withSize:CGSizeMake(44,44)  withPosition:CGPointMake(-15, -74)];
        
        /* Set up EXIT button */
        [self addButtonWithSprite:&_exit withImageName:@"exit" withColor:theme withSize:CGSizeMake(44,44)  withPosition:CGPointMake(-15, -118)];
        
        /* The PLAY, REPLAY and EXIT button start out hidden */
        [_play   setHidden:YES];
        [_replay setHidden:YES];
        [_exit   setHidden:YES];
        
        /* Make sure all of the buttons show up above the current scene and in the correct order */
        _pause.zPosition = FRONT;
        _play.zPosition = _replay.zPosition = _exit.zPosition = BACK;
        
        /* Set the handlers for use later */
        _replayHandler = replay;
        _exitHandler   = exit;
        
    }
    return self;
}

-(void) handleTouch:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        
        NSLog(@"%@",node.name);
        
        if (self.parent.isPaused == NO) {
            if ([node.name isEqualToString:@"pause"]) {
                
                [self.parent setPaused:YES];
                
                _pause.zPosition = BACK;
                _play.zPosition  = FRONT;

                [_pause  setHidden:YES];
                [_play   setHidden:NO];
                [_replay setHidden:NO];
                [_exit   setHidden:NO];

            }
        } else {
            if ([node.name isEqualToString:@"play"]) {
                
                [self.parent setPaused:NO];
                
                _pause.zPosition = FRONT;
                _play.zPosition  = BACK;
                
                [_pause  setHidden:NO];
                [_play   setHidden:YES];
                [_replay setHidden:YES];
                [_exit   setHidden:YES];
                
            } else if ([node.name isEqualToString:@"replay"]) {
                _replayHandler();
            } else if([node.name isEqualToString:@"exit"]) {
                _exitHandler();
            }
        }
    }
}

/* I had to pass the sprite as strongly indirect since ARC requires their pointer types to be passed for double pointers */
-(void) addButtonWithSprite:(SKSpriteNode * __strong *)sprite withImageName:(NSString*)name withColor:(UIColor*)theme withSize:(CGSize)size withPosition:(CGPoint)position {
    
    *sprite = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:size];
    [*sprite setPosition:position];
    [*sprite setName:name];
    
    SKSpriteNode *image = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"%@.png",name]];
    image.name = name;
    image.color = theme;
    image.colorBlendFactor = 1.0;
    
    if([name isEqualToString:@"pause"])
        image.alpha = 0.5;
    
    [*sprite addChild:image];
    [self addChild:*sprite];
}

@end
