//
//  SSGameScene.h
//  HoleInTheWall
//
//  Created by Stevenson on 21/02/2014.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SSGameScene : SKScene

/**
 *
 * add image to background
 * @param UIImage image
 *
**/
-(void) changeBackgroundImage:(UIImage*) image;


-(void) addShadowForReferencePoint: (CGPoint) shapeLocation;

-(void) removeShadow;

-(void) moveShadowWithReferencePoint: (CGPoint) shapeLocation;

-(void) shadowMoveFollowingHit;

@end
