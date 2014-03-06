//
//  JWCMultipeerController.h
//  HoleInTheWall
//
//  Created by Jeff Schwab on 3/6/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@interface JWCMultipeerController : NSObject
<MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCBrowserViewControllerDelegate, MCSessionDelegate, NSStreamDelegate>

@property (nonatomic) MCNearbyServiceBrowser *browser;
@property (nonatomic) MCSession *session;
@property (nonatomic) MCPeerID *multiHolePartnerPeerID;

+ (JWCMultipeerController *)sharedController;

- (void)advertiseService;


@end
