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

@property (nonatomic) NSMutableArray *shapePoints;
@property (nonatomic) NSMutableArray *jsonArray;

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
        case JWCShapeTypeCircle:
            
            break;
        default:
            break;
    }
    
    if (self) {
        self.shapeType = shapeType;
        
        NSData *jsonData = [NSData dataWithContentsOfFile:_shapeFilePath];
        self.jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        for (NSArray *pointArray in self.jsonArray) {
            NSNumber *xNumber = [pointArray firstObject];
            CGFloat xPoint = xNumber.floatValue;
            
            NSString *yNumber = [pointArray lastObject];
            CGFloat yPoint = yNumber.floatValue;
            
            NSValue *currentPoint = [NSValue valueWithCGPoint:CGPointMake(xPoint, yPoint)];
            [self.shapePoints addObject:currentPoint];
        }
        
        self.color = [UIColor colorWithRed:0.000 green:0.367 blue:0.911 alpha:0.590];
        self.size = size;
    }
    return self;
}

- (NSMutableArray *)shapePoints
{
    if (!_shapePoints) {
        _shapePoints = [NSMutableArray new];
    }
    return _shapePoints;
}
@end
