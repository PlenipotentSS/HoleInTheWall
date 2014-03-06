//
//  JWCScrene.m
//  HoleInTheWall
//
//  Created by Jeff Schwab on 2/23/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCScene.h"
#import "JWCShapeType.h"
#import "MMRCheckForCollision.h"
#import "WTMGlyphDetector.h"
#import "MMRGameOverScene.h"
#import "MMRWallOpeningScene.h"

#import "JSGameMenu.h"
#import <GameCenterManager/GameCenterManager.h>
@import AVFoundation;

@interface JWCScene () <WTMGlyphDelegate, GameCenterManagerDelegate>
{
    NSInteger _wallsPassed;
    
    BOOL _glyphDetected;
    BOOL _wallScaling;
    BOOL _shadowRemoved;
    BOOL _collisionChecked;
    BOOL _wallsPassedIncremented;
}

@property (nonatomic) JWCShape *playerShape;

@property (nonatomic) NSMutableArray *glyphs;
@property (nonatomic) WTMGlyphDetector *glyphDetector;

@property (nonatomic) NSInteger lives;

@property (nonatomic) SKLabelNode *labelLives;
@property (nonatomic) SKLabelNode *labelWallsPassed;

@property (nonatomic) AVAudioPlayer *backgroundMusicPlayer;

@property (nonatomic) JSGameMenu *pauseMenu;

@property (nonatomic) MMRGameOverScene *gameOverScene;

@end

@implementation JWCScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        self.lives = 3;
        
        [self setupGlyphCollection];
        [self setupBackgroundMusic];
        [GameCenterManager sharedManager].delegate = self;
        
        self.wall = [[JWCWall alloc] initWithScale:.2];
        [self addChild:self.wall];
        
        [self.wall startMovingWithDuration:6];
        _wallScaling = YES;
   
        self.backgroundColor = [UIColor colorWithRed:0.000 green:0.816 blue:1.000 alpha:1.000];
        
        self.labelLives = [SKLabelNode labelNodeWithFontNamed:@"Prisma"];
        self.labelLives.text = [NSString stringWithFormat:@"Lives Left: %i", self.lives];
        self.labelLives.fontSize = 15;
        
        self.labelWallsPassed = [SKLabelNode labelNodeWithFontNamed:@"Prisma"];
        self.labelWallsPassed.text = [NSString stringWithFormat:@"Walls Passed:%i", _wallsPassed];
        self.labelWallsPassed.fontSize = 15;

        self.pauseMenu = [[JSGameMenu alloc] initWithSize:self.size withReplayHandler:^{
            
        } withExitHandler:^{
            // Go back to opening scene
            [self.backgroundMusicPlayer stop];
            MMRWallOpeningScene *openingScene = [[MMRWallOpeningScene alloc] initWithSize:self.size];
            openingScene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:openingScene];
        }];
        self.pauseMenu.anchorPoint = CGPointMake(.5, .5);
        [self addChild:self.pauseMenu];
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            self.labelLives.position = CGPointMake(-60, 230);
            self.labelWallsPassed.position = CGPointMake(60, 230);
            self.pauseMenu.position = CGPointMake(-120, 245);
        } else {
            self.labelLives.position = CGPointMake(-120, 500);
            self.labelLives.position = CGPointMake(120, 500);
            self.pauseMenu.position = CGPointMake(-120, 500);
        }

        [self addChild:self.labelLives];
        [self addChild:self.labelWallsPassed];
    }
    
    
    return self;
}

#pragma mark - Touch Recognizers
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.pauseMenu handleTouch:touches withEvent:event];
    
    if (!self.isPaused) {
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        [self.glyphDetector addPoint:touchPoint];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_glyphDetected) {
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        [self.glyphDetector addPoint:touchPoint];
    } else {
        _wallsPassedIncremented = NO;
        self.playerShape.position = [[touches anyObject] locationInNode:self];
        [self moveShadowWithReferencePoint:[[touches anyObject] locationInNode:self]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_glyphDetected) {
        [self.glyphDetector addPoint:[[touches anyObject] locationInView:self.view]];
        [self.glyphDetector detectGlyph];
    } else {
        [self removeShape:nil];
    }
}

- (void)removeShape:(id)sender
{
    _glyphDetected = NO;
    _shadowRemoved = NO;
    [self.playerShape removeFromParent];
    [self removeShadow];
}

#pragma mark - Glyph Setup
- (void)setupGlyphCollection
{
    self.glyphDetector = [WTMGlyphDetector detector];
    self.glyphDetector.delegate = self;
    
    for (int i = 1; i < 6; i++) {
        NSString *sqaureFileName = [NSString stringWithFormat:@"square%d",i];
        [self addGlyphWithJSONFileName:sqaureFileName withShapeName:@"square"];
        
        NSString *triangleFileName = [NSString stringWithFormat:@"triangle%d",i];
        [self addGlyphWithJSONFileName:triangleFileName withShapeName:@"triangle"];
        
        NSString *wFileName = [NSString stringWithFormat:@"w%d",i];
        [self addGlyphWithJSONFileName:wFileName withShapeName:@"w"];
    }
    [self addGlyphWithJSONFileName:@"circle" withShapeName:@"circle"];
    
}

- (void)addGlyphWithJSONFileName:(NSString *)fileName withShapeName:(NSString *)shapeName
{
    NSString *glyphFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *glyphData = [NSData dataWithContentsOfFile:glyphFilePath];
    
    [self.glyphDetector addGlyphFromJSON:glyphData name:shapeName];
}

#pragma mark - WTMGlyphDetector Callback
- (void)glyphDetected:(WTMGlyph *)glyph withScore:(float)score
{
    if (!_glyphDetected) {
        _collisionChecked = NO;
        _glyphDetected = YES;
        [self.glyphDetector reset];
            
        CGSize playerShapeSize = [JWCDimensions sharedController].size;
        
        if ([glyph.name isEqualToString:@"square"]) {
            self.playerShape = [[JWCShape alloc] initWithShapeType:JWCShapeTypeSquare size:playerShapeSize];
            self.playerShape.position = CGPointZero;
        } else if ([glyph.name isEqualToString:@"triangle"]) {
            self.playerShape = [[JWCShape alloc] initWithShapeType:JWCShapeTypeTriangle size:playerShapeSize];
            self.playerShape.position = CGPointZero;
        } else if ([glyph.name isEqualToString:@"circle"]) {
            self.playerShape = [[JWCShape alloc] initWithShapeType:JWCShapeTypeCircle size:playerShapeSize];
            self.playerShape.position = CGPointZero;
        } else if ([glyph.name isEqualToString:@"w"]) {
            self.playerShape = [[JWCShape alloc] initWithShapeType:JWCShapeTypeW size:playerShapeSize];
            self.playerShape.position = CGPointZero;
        }
        
        [self addChild:self.playerShape];
        [self addShadowForReferencePoint:CGPointZero];
    }
}

- (void)update:(CFTimeInterval)currentTime
{
    if (self.wall.yScale >= 0.85 && self.wall.yScale <= 0.862) {
        
        if (!_collisionChecked && [MMRCheckForCollision checkForCollision:self.playerShape andHole:self.wall.holeInWall inWall:self.wall]) {
            
            _collisionChecked = YES;
            
            float xValue = (arc4random() % (int)self.size.width) * 2;
            float yValue = (arc4random() % (int)self.size.height) * 2;
            
            self.lives--;
            self.labelLives.text = [NSString stringWithFormat:@"Lives Left: %i", self.lives];
            
            if (self.lives == 0) {
                [self.backgroundMusicPlayer stop];
                
                if (!self.gameOverScene) {
                    self.gameOverScene = [[MMRGameOverScene alloc] initWithSize:self.size];
                    self.gameOverScene.gameScene = self;
                }
                self.gameOverScene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:self.gameOverScene transition:[SKTransition doorwayWithDuration:1.0]];
            }
            
            SKAction *sendToPoint = [SKAction moveTo:CGPointMake(xValue, yValue) duration:1.0];
            SKAction *scalePlayerSHape = [SKAction scaleBy:3 duration:1.0];
            SKAction *oneRevolution = [SKAction rotateByAngle:-M_PI*2 duration:1.0];

            SKAction *group = [SKAction group:@[sendToPoint,scalePlayerSHape,oneRevolution]];
            [self.playerShape runAction:group completion:^{
                [self removeShape:nil];
            }];
            
            if (self.playerShape.parent && !_shadowRemoved) {
                _shadowRemoved = NO;
            }
        } else {
            if (!_collisionChecked && !self.wall.wallPassed) {
                _wallsPassed++;
                self.wall.wallPassed = YES;
                self.labelWallsPassed.text = [NSString stringWithFormat:@"Walls Passed:%i", _wallsPassed];
            }
            
            if (_wallsPassed != 0) {
                int randomValue = 75 + arc4random() % (250 - 75);
                [JWCDimensions sharedController].size = CGSizeMake(randomValue, randomValue);
            }
        }
    }
}

#pragma mark - Background Music player
- (void)setupBackgroundMusic
{
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"Pamgaea" withExtension:@"mp3"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
}

#pragma mark - GameCenterManagerDelegate
- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController
{
    
}

- (void)reportScore
{
//    // TODO: Implement this with our real achievement name
//    [[GameCenterManager sharedManager] saveAndReportScore:_wallsPassed
//                                              leaderboard:@"com.jeffwritescode.holeinthewall.hiscore" sortOrder:GameCenterSortOrderHighToLow];
}

@end
