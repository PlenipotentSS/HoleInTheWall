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
                self = [JWCHole spriteNodeWithImageNamed:@"square"];
                self.size = CGSizeMake(shapeSize.width*1.2, shapeSize.height*1.2);
                self.shapeType = shapeType;
                break;
            case JWCShapeTypeTriangle:
                self = [JWCHole spriteNodeWithImageNamed:@"triangle"];
                self.size = CGSizeMake(shapeSize.width*1.2, shapeSize.height*1.2);
                self.shapeType = shapeType;
                break;
            case JWCShapeTypeCircle:
                self = [JWCHole spriteNodeWithImageNamed:@"circle"];
                self.size = CGSizeMake(shapeSize.width*1.2, shapeSize.height*1.2);
                self.shapeType = shapeType;
                break;
            case JWCShapeTypeWallLabel:
                self = [JWCHole spriteNodeWithImageNamed:@"whiteWallText"];
                self.size = CGSizeMake(shapeSize.width*1.2, shapeSize.height*1.2);
                self.shapeType = shapeType;
            default:
                break;
        }
    }
    self.hidden = YES;
    return self;
    
}

@end
