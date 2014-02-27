//
//  JWCHole.m
//  HoleInTheWall
//
//  Created by Jeff Schwab on 2/23/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCHole.h"

@implementation JWCHole

- (instancetype)initWithShapeType:(JWCShapeType)shapeType shapeSize:(CGSize)shapeSize
{
    if (self = [super init]) {
        self.color = [UIColor colorWithWhite:0.171 alpha:1.000];
        switch (shapeType) {
            case JWCShapeTypeSquare:
                self.size = CGSizeMake(shapeSize.width*1.1, shapeSize.height*1.1);
                break;
            case JWCShapeTypeTriangle:
                self = [JWCHole spriteNodeWithImageNamed:@"triangle"];
                self.size = CGSizeMake(shapeSize.width*1.1, shapeSize.height*1.1);
                break;
            case JWCShapeTypeCircle:
                self = [JWCHole spriteNodeWithImageNamed:@"circle"];
                self.size = CGSizeMake(shapeSize.width*1.1, shapeSize.height*1.1);
            default:
                break;
        }
    }
    self.hidden = YES;
    return self;
}

@end
