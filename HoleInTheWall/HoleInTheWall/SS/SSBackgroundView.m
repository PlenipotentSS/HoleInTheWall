//
//  SSBackgroundView.m
//  HoleInTheWall
//
//  Created by Stevenson on 25/02/2014.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "SSBackgroundView.h"

@implementation SSBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.heightOfWall = 40;
        self.widthOfWall = 20;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* noneColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    UIColor* color14 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIColor* color15 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5];
    UIColor* color23 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    UIColor* color24 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5];
    UIColor* color25 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    
    //// Gradient Declarations
    NSArray* sVGID_22_2Colors = [NSArray arrayWithObjects:
                                 (id)noneColor2.CGColor,
                                 (id)color15.CGColor, nil];
    CGFloat sVGID_22_2Locations[] = {0.91, 1};
    CGGradientRef sVGID_22_2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_22_2Colors, sVGID_22_2Locations);
    NSArray* sVGID_27_2Colors = [NSArray arrayWithObjects:
                                 (id)noneColor2.CGColor,
                                 (id)color15.CGColor, nil];
    CGFloat sVGID_27_2Locations[] = {0.88, 1};
    CGGradientRef sVGID_27_2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_27_2Colors, sVGID_27_2Locations);
    NSArray* sVGID_24_2Colors = [NSArray arrayWithObjects:
                                 (id)noneColor2.CGColor,
                                 (id)color15.CGColor, nil];
    CGFloat sVGID_24_2Locations[] = {0.92, 1};
    CGGradientRef sVGID_24_2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_24_2Colors, sVGID_24_2Locations);
    NSArray* sVGID_26_2Colors = [NSArray arrayWithObjects:
                                 (id)noneColor2.CGColor,
                                 (id)color15.CGColor, nil];
    CGFloat sVGID_26_2Locations[] = {0.88, 1};
    CGGradientRef sVGID_26_2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_26_2Colors, sVGID_26_2Locations);
    NSArray* sVGID_23_2Colors = [NSArray arrayWithObjects:
                                 (id)noneColor2.CGColor,
                                 (id)color15.CGColor, nil];
    CGFloat sVGID_23_2Locations[] = {0.89, 1};
    CGGradientRef sVGID_23_2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_23_2Colors, sVGID_23_2Locations);
    NSArray* sVGID_25_2Colors = [NSArray arrayWithObjects:
                                 (id)noneColor2.CGColor,
                                 (id)color15.CGColor, nil];
    CGFloat sVGID_25_2Locations[] = {0.91, 1};
    CGGradientRef sVGID_25_2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_25_2Colors, sVGID_25_2Locations);
    NSArray* sVGID_1_4Colors = [NSArray arrayWithObjects:
                                (id)color23.CGColor,
                                (id)color24.CGColor, nil];
    CGFloat sVGID_1_4Locations[] = {0.6, 1};
    CGGradientRef sVGID_1_4 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)sVGID_1_4Colors, sVGID_1_4Locations);
    
    //// Frames
    CGRect frame = rect;
    
    CGFloat heightOffset = self.heightOfWall/2;
    CGFloat widthOffset = self.widthOfWall/2;
    
    //// Group
    {
        //// Walls
        {
            //// Right Wall
            {
                //// Bezier 73 Drawing
                UIBezierPath* bezier73Path = [UIBezierPath bezierPath];
                [bezier73Path moveToPoint: CGPointMake(CGRectGetMidX(frame)+widthOffset, CGRectGetMidY(frame)+2*widthOffset)];
                [bezier73Path addLineToPoint: CGPointMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame))];
                [bezier73Path addLineToPoint: CGPointMake(CGRectGetMaxX(frame), CGRectGetMinY(frame))];
                [bezier73Path addLineToPoint: CGPointMake(CGRectGetMidX(frame)+widthOffset, CGRectGetMidY(frame)-widthOffset)];
                [bezier73Path closePath];
                CGContextSaveGState(context);
                [bezier73Path addClip];
                CGRect bezier73Bounds = CGPathGetPathBoundingBox(bezier73Path.CGPath);
                CGContextDrawLinearGradient(context, sVGID_22_2,
                                            CGPointMake(CGRectGetMidX(bezier73Bounds) + 419.47 * CGRectGetWidth(bezier73Bounds) / 305.2, CGRectGetMidY(bezier73Bounds) + 186.87 * CGRectGetHeight(bezier73Bounds) / 1136),
                                            CGPointMake(CGRectGetMidX(bezier73Bounds) + -114.27 * CGRectGetWidth(bezier73Bounds) / 305.2, CGRectGetMidY(bezier73Bounds) + -186.87 * CGRectGetHeight(bezier73Bounds) / 1136),
                                            kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
                CGContextRestoreGState(context);
                [color14 setStroke];
                bezier73Path.lineWidth = 0.5;
                [bezier73Path stroke];
                
                
                //// Bezier 74 Drawing
                UIBezierPath* bezier74Path = [UIBezierPath bezierPath];
                [bezier74Path moveToPoint: CGPointMake(CGRectGetMidX(frame)+widthOffset, CGRectGetMidY(frame)+2*widthOffset)];
                [bezier74Path addLineToPoint: CGPointMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame))];
                [bezier74Path addLineToPoint: CGPointMake(CGRectGetMaxX(frame), CGRectGetMinY(frame))];
                [bezier74Path addLineToPoint: CGPointMake(CGRectGetMidX(frame)+widthOffset, CGRectGetMidY(frame)-widthOffset)];
                [bezier74Path closePath];
                CGContextSaveGState(context);
                [bezier74Path addClip];
                CGRect bezier74Bounds = CGPathGetPathBoundingBox(bezier74Path.CGPath);
                CGContextDrawLinearGradient(context, sVGID_23_2,
                                            CGPointMake(CGRectGetMidX(bezier74Bounds) + 422.7 * CGRectGetWidth(bezier74Bounds) / 305.2, CGRectGetMidY(bezier74Bounds) + -196.24 * CGRectGetHeight(bezier74Bounds) / 1136),
                                            CGPointMake(CGRectGetMidX(bezier74Bounds) + -117.5 * CGRectGetWidth(bezier74Bounds) / 305.2, CGRectGetMidY(bezier74Bounds) + 196.24 * CGRectGetHeight(bezier74Bounds) / 1136),
                                            kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
                CGContextRestoreGState(context);
                [color14 setStroke];
                bezier74Path.lineWidth = 0.5;
                [bezier74Path stroke];
            }
            
            
            //// Left Wall
            {
                //// Bezier 75 Drawing
                UIBezierPath* bezier75Path = [UIBezierPath bezierPath];
                [bezier75Path moveToPoint: CGPointMake(CGRectGetMidX(frame)-widthOffset, CGRectGetMidY(frame)+heightOffset)];
                [bezier75Path addLineToPoint: CGPointMake(CGRectGetMinX(frame), CGRectGetMaxY(frame))];
                [bezier75Path addLineToPoint: CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame))];
                [bezier75Path addLineToPoint: CGPointMake(CGRectGetMidX(frame)-widthOffset, CGRectGetMidY(frame)-heightOffset/2)];
                [bezier75Path addLineToPoint: CGPointMake(CGRectGetMidX(frame)-widthOffset, CGRectGetMidY(frame)+heightOffset)];
                [bezier75Path closePath];
                CGContextSaveGState(context);
                [bezier75Path addClip];
                CGRect bezier75Bounds = CGPathGetPathBoundingBox(bezier75Path.CGPath);
                CGContextDrawLinearGradient(context, sVGID_24_2,
                                            CGPointMake(CGRectGetMidX(bezier75Bounds) + -412.05 * CGRectGetWidth(bezier75Bounds) / 305.2, CGRectGetMidY(bezier75Bounds) + 168.49 * CGRectGetHeight(bezier75Bounds) / 1136),
                                            CGPointMake(CGRectGetMidX(bezier75Bounds) + 106.85 * CGRectGetWidth(bezier75Bounds) / 305.2, CGRectGetMidY(bezier75Bounds) + -168.49 * CGRectGetHeight(bezier75Bounds) / 1136),
                                            kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
                CGContextRestoreGState(context);
                [color14 setStroke];
                bezier75Path.lineWidth = 0.5;
                [bezier75Path stroke];
                
                
                //// Bezier 76 Drawing
                UIBezierPath* bezier76Path = [UIBezierPath bezierPath];
                [bezier76Path moveToPoint: CGPointMake(CGRectGetMidX(frame)-widthOffset, CGRectGetMidY(frame)+heightOffset)];
                [bezier76Path addLineToPoint: CGPointMake(CGRectGetMinX(frame), CGRectGetMaxY(frame))];
                [bezier76Path addLineToPoint: CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame))];
                [bezier76Path addLineToPoint: CGPointMake(CGRectGetMidX(frame)-widthOffset, CGRectGetMidY(frame)-heightOffset/2)];
                [bezier76Path addLineToPoint: CGPointMake(CGRectGetMidX(frame)-widthOffset, CGRectGetMidY(frame)+heightOffset)];
                [bezier76Path closePath];
                CGContextSaveGState(context);
                [bezier76Path addClip];
                CGRect bezier76Bounds = CGPathGetPathBoundingBox(bezier76Path.CGPath);
                CGContextDrawLinearGradient(context, sVGID_25_2,
                                            CGPointMake(CGRectGetMidX(bezier76Bounds) + -415.92 * CGRectGetWidth(bezier76Bounds) / 305.2, CGRectGetMidY(bezier76Bounds) + -177.61 * CGRectGetHeight(bezier76Bounds) / 1136),
                                            CGPointMake(CGRectGetMidX(bezier76Bounds) + 110.72 * CGRectGetWidth(bezier76Bounds) / 305.2, CGRectGetMidY(bezier76Bounds) + 177.61 * CGRectGetHeight(bezier76Bounds) / 1136),
                                            kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
                CGContextRestoreGState(context);
                [color14 setStroke];
                bezier76Path.lineWidth = 0.5;
                [bezier76Path stroke];
            }
        }
        
        
        //// Bottom
        {
            //// Group 31
            {
                //// Bezier 77 Drawing
                UIBezierPath* bezier77Path = [UIBezierPath bezierPath];
                [bezier77Path moveToPoint: CGPointMake(CGRectGetMinX(frame), CGRectGetMaxY(frame))];
                [bezier77Path addLineToPoint: CGPointMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame))];
                [bezier77Path addLineToPoint: CGPointMake(CGRectGetMidX(frame)+widthOffset, CGRectGetMidY(frame)+heightOffset)];
                [bezier77Path addLineToPoint: CGPointMake(CGRectGetMidX(frame)-widthOffset, CGRectGetMidY(frame)+heightOffset)];
                [bezier77Path addLineToPoint: CGPointMake(CGRectGetMinX(frame), CGRectGetMaxY(frame))];
                [bezier77Path closePath];
                CGContextSaveGState(context);
                [bezier77Path addClip];
                CGRect bezier77Bounds = CGPathGetPathBoundingBox(bezier77Path.CGPath);
                CGContextDrawLinearGradient(context, sVGID_26_2,
                                            CGPointMake(CGRectGetMidX(bezier77Bounds) + -342.47 * CGRectGetWidth(bezier77Bounds) / 640, CGRectGetMidY(bezier77Bounds) + 220.42 * CGRectGetHeight(bezier77Bounds) / 541.75),
                                            CGPointMake(CGRectGetMidX(bezier77Bounds) + 191.66 * CGRectGetWidth(bezier77Bounds) / 640, CGRectGetMidY(bezier77Bounds) + -17.39 * CGRectGetHeight(bezier77Bounds) / 541.75),
                                            kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
                CGContextRestoreGState(context);
                [color14 setStroke];
                bezier77Path.lineWidth = 0.5;
                [bezier77Path stroke];
                
                
                //// Bezier 78 Drawing
                UIBezierPath* bezier78Path = [UIBezierPath bezierPath];
                [bezier78Path moveToPoint: CGPointMake(CGRectGetMinX(frame), CGRectGetMaxY(frame))];
                [bezier78Path addLineToPoint: CGPointMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame))];
                [bezier78Path addLineToPoint: CGPointMake(CGRectGetMidX(frame)+widthOffset, CGRectGetMidY(frame)+heightOffset)];
                [bezier78Path addLineToPoint: CGPointMake(CGRectGetMidX(frame)-widthOffset, CGRectGetMidY(frame)+heightOffset)];
                [bezier78Path addLineToPoint: CGPointMake(CGRectGetMinX(frame), CGRectGetMaxY(frame))];                [bezier78Path closePath];
                CGContextSaveGState(context);
                [bezier78Path addClip];
                CGRect bezier78Bounds = CGPathGetPathBoundingBox(bezier78Path.CGPath);
                CGContextDrawLinearGradient(context, sVGID_27_2,
                                            CGPointMake(CGRectGetMidX(bezier78Bounds) + 342.46 * CGRectGetWidth(bezier78Bounds) / 640, CGRectGetMidY(bezier78Bounds) + 220.42 * CGRectGetHeight(bezier78Bounds) / 541.75),
                                            CGPointMake(CGRectGetMidX(bezier78Bounds) + -191.66 * CGRectGetWidth(bezier78Bounds) / 640, CGRectGetMidY(bezier78Bounds) + -17.39 * CGRectGetHeight(bezier78Bounds) / 541.75),
                                            kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
                CGContextRestoreGState(context);
                [color14 setStroke];
                bezier78Path.lineWidth = 0.5;
                [bezier78Path stroke];
            }
        }
        
    
        //// Top
        {
            //// Bezier Drawing
            UIBezierPath* bezierPath = [UIBezierPath bezierPath];
            [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + CGRectGetWidth(frame), CGRectGetMinY(frame))];
            [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame))];
            [bezierPath addLineToPoint: CGPointMake(CGRectGetMidX(frame)-widthOffset, CGRectGetMidY(frame)-widthOffset)];
            [bezierPath addLineToPoint: CGPointMake(CGRectGetMidX(frame)+widthOffset, CGRectGetMidY(frame)-widthOffset)];
            [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + CGRectGetWidth(frame), CGRectGetMinY(frame))];
            [bezierPath closePath];
            CGContextSaveGState(context);
            [bezierPath addClip];
            CGRect bezierBounds = CGPathGetPathBoundingBox(bezierPath.CGPath);
            CGFloat bezierResizeRatio = MIN(CGRectGetWidth(bezierBounds) / CGRectGetWidth(frame), CGRectGetHeight(bezierBounds) / 541.75);
            CGContextDrawRadialGradient(context, sVGID_1_4,
                                        CGPointMake(CGRectGetMidX(bezierBounds) + -0 * bezierResizeRatio, CGRectGetMidY(bezierBounds) + -0 * bezierResizeRatio), 0 * bezierResizeRatio,
                                        CGPointMake(CGRectGetMidX(bezierBounds) + -0 * bezierResizeRatio, CGRectGetMidY(bezierBounds) + -0 * bezierResizeRatio), 444.69 * bezierResizeRatio,
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGContextRestoreGState(context);
            [color25 setStroke];
            bezierPath.lineWidth = 0.5;
            [bezierPath stroke];
        }
    }
    
    
    //// Cleanup
    CGGradientRelease(sVGID_22_2);
    CGGradientRelease(sVGID_27_2);
    CGGradientRelease(sVGID_24_2);
    CGGradientRelease(sVGID_26_2);
    CGGradientRelease(sVGID_23_2);
    CGGradientRelease(sVGID_25_2);
    CGGradientRelease(sVGID_1_4);
    CGColorSpaceRelease(colorSpace);


}


@end
