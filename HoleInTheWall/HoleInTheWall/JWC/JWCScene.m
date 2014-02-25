//
//  JWCScrene.m
//  HoleInTheWall
//
//  Created by Jeff Schwab on 2/23/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCScene.h"
#import "JWCShapeType.h"

#import "WTMGlyphDetector.h"

@interface JWCScene () <WTMGlyphDelegate>
{
    BOOL _glyphDetected;
    BOOL _wallScaling;
}


@property (nonatomic) JWCShape *playerShape;
@property (nonatomic) JWCHole *currentHole;

@property (nonatomic) NSMutableArray *glyphs;
@property (nonatomic) WTMGlyphDetector *glyphDetector;

@end

@implementation JWCScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        [self setupGlyphCollection];
        
        self.wall = [[JWCWall alloc] initWithScale:.2];
        [self addChild:self.wall];
        
        [self.wall startMovingWithDuration:6];
        _wallScaling = YES;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInNode:self];
    [self.glyphDetector addPoint:touchPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_glyphDetected) {
        CGPoint touchPoint = [[touches anyObject] locationInNode:self];
        [self.glyphDetector addPoint:touchPoint];
    } else {
        self.playerShape.position = [[touches anyObject] locationInNode:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_glyphDetected) {
        [self.glyphDetector detectGlyph];
    } else {
        _glyphDetected = NO;
        [self.playerShape removeFromParent];
    }
}

#pragma mark - Glyph Setup
- (void)setupGlyphCollection
{
    self.glyphDetector = [WTMGlyphDetector detector];
    self.glyphDetector.delegate = self;
    
    NSString *glyphSquareFilePath = [[NSBundle mainBundle] pathForResource:@"Square" ofType:@"json"];
    NSData *glyphSqaureData = [NSData dataWithContentsOfFile:glyphSquareFilePath];
    
    NSString *glyphTriangleFilePath = [[NSBundle mainBundle] pathForResource:@"Triangle" ofType:@"json"];
    NSData *glyphTriangleData = [NSData dataWithContentsOfFile:glyphTriangleFilePath];
    
    NSString *glyphRectangleFilePath = [[NSBundle mainBundle] pathForResource:@"Rectangle" ofType:@"json"];
    NSData *glyphRectangleData = [NSData dataWithContentsOfFile:glyphRectangleFilePath];
    
    [self.glyphDetector addGlyphFromJSON:glyphSqaureData name:@"square"];
    [self.glyphDetector addGlyphFromJSON:glyphTriangleData name:@"triangle"];
    [self.glyphDetector addGlyphFromJSON:glyphRectangleData name:@"rectangle"];
    
}

- (void)glyphDetected:(WTMGlyph *)glyph withScore:(float)score
{
    if (!_glyphDetected) {
        _glyphDetected = YES;
        [self.glyphDetector reset];
        
        if ([glyph.name isEqualToString:@"square"]) {
            self.playerShape = [[JWCShape alloc] initWithShapeType:JWCShapeTypeSquare size:CGSizeMake(150, 150)];
            self.playerShape.position = CGPointZero;
        } else if ([glyph.name isEqualToString:@"triangle"]) {
            self.playerShape = [[JWCShape alloc] initWithShapeType:JWCShapeTypeTriangle size:CGSizeMake(150, 150)];
            self.playerShape.position = CGPointZero;
        }
        
        [self addChild:self.playerShape];
    }
}

- (void)update:(CFTimeInterval)currentTime
{

}

@end
