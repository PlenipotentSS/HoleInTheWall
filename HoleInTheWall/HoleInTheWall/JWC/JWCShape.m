//
//  JWCShape.m
//  HoleInTheWall
//
//  Created by Jeff Schwab on 2/23/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCShape.h"

@interface JWCShape ()
{
    NSString *_shapeFilePath;
}
@end

@implementation JWCShape

- (instancetype)initWithShapeType:(JWCShapeType)shapeType size:(CGSize)size
{
    switch (shapeType) {
        case JWCShapeTypeTriangle:
            self = [super initWithImageNamed:@"triangle.png"];
            _shapeFilePath = [[NSBundle mainBundle] pathForResource:@"Triangle" ofType:@"json"];
            break;
        case JWCShapeTypeSquare:
            self = [super initWithImageNamed:@"square.png"];
            _shapeFilePath = [[NSBundle mainBundle] pathForResource:@"Square" ofType:@"json"];
            break;
        case JWCShapeTypeRectangle:
            self = [super initWithImageNamed:@"rectangle.png"];
            _shapeFilePath = [[NSBundle mainBundle] pathForResource:@"Rectangle" ofType:@"json"];
            break;
        default:
            break;
    }
    
    if (self) {
        self.shapeType = shapeType;
        self.jsonData = [NSData dataWithContentsOfFile:_shapeFilePath];
        
        self.color = [UIColor colorWithRed:0.000 green:0.367 blue:0.911 alpha:0.590];
        self.size = size;
    }
    return self;
}


@end

