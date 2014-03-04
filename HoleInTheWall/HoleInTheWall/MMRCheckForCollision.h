//
//  MMRCheckForCollision.h
//  HoleInTheWall
//
//  Created by Matt Remick on 2/26/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JWCHole.h"
#import "JWCWall.h"
#import "JWCShape.h"

@interface MMRCheckForCollision : NSObject

+ (BOOL)checkForCollision:(JWCShape *)playerShape andHoleInTheWall:(JWCHole *)hole;

@end
