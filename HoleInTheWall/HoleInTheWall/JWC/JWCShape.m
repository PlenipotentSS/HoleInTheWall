//
//  JWCShape.m
//  HoleInTheWall
//
//  Created by Jeff Schwab on 2/23/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCShape.h"

@interface JWCShape ()

@end

@implementation JWCShape

- (instancetype)initWithShapeType:(JWCShapeType)shapeType size:(CGSize)size
{
    switch (shapeType) {
        case JWCShapeTypeTriangle:
            self = [super initWithImageNamed:@"triangle.png"];
            break;
        case JWCShapeTypeSquare:
            self = [super initWithImageNamed:@"square.png"];
            break;
        case JWCShapeTypeCircle:
            self = [super initWithImageNamed:@"circle.png"];
            break;
        case JWCShapeTypeW:
            self = [super initWithImageNamed:@"w.png"];
            break;
        default:
            break;
    }
    
    if (self) {
        self.shapeType = shapeType;
        
        self.color = [UIColor colorWithRed:0.000 green:0.367 blue:0.911 alpha:0.590];
        self.size = size;
    }
    return self;
}


@end

