//
//  JWCScrene.m
//  HoleInTheWall
//
//  Created by Jeff Schwab on 2/23/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCScene.h"
#import "JWCShapeType.h"

@interface JWCScene ()

@property (nonatomic) JWCShape *playerShape;

@end

@implementation JWCScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        //TODO: Set the shape based on player gesture
        self.playerShape = [[JWCShape alloc] initWithShapeType:JWCShapeTypeSquare size:CGSizeMake(150, 150)];
        
        JWCHole *hole = [[JWCHole alloc] initWithShapeType:self.playerShape.shapeType
                                                 shapeSize:self.playerShape.size];
        
        self.wall = [[JWCWall alloc] initWithScale:.2
                                           andHole:hole
                                      withPosition:CGPointZero];
        self.wall.hidden = YES;
        [self addChild:self.wall];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.wall.hidden = NO;
    self.playerShape.position = [[touches anyObject] locationInNode:self];
    [self addChild:self.playerShape];
    [self.wall startMovingWithDuration:1];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.playerShape.position = [[touches anyObject] locationInNode:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.wall.hidden = YES;
    [self.playerShape removeFromParent];
    [self.wall removeAllActions];
    [self.wall setScale:.2];
    [self.wall.holeInWall setScale:1];
}

- (void)update:(CFTimeInterval)currentTime
{

}

@end
