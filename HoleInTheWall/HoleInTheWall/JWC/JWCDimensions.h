//
//  JWCDimensions.h
//  HoleInTheWall
//
//  Created by Jeff Schwab on 3/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface JWCDimensions : NSObject

@property (nonatomic) MCPeerID *localPeerID;

@property (nonatomic) CGSize size;

+ (JWCDimensions *)sharedController;


@end
