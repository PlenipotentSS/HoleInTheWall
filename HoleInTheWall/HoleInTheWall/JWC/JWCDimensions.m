//
//  JWCDimensions.m
//  HoleInTheWall
//
//  Created by Jeff Schwab on 3/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCDimensions.h"

@implementation JWCDimensions

+ (JWCDimensions *)sharedController
{
    static JWCDimensions *sharedController = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
        sharedController.size = CGSizeMake(150, 150);
    });
    
    return sharedController;
}

- (MCPeerID *)localPeerID
{
    if (!_localPeerID) {
        _localPeerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    }
    return _localPeerID;
}

@end
