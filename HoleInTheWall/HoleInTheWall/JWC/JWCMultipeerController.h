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

@property (nonatomic) MCPeerID *peerID;
@property (nonatomic) MCSession *session;
@property (nonatomic) MCBrowserViewController *browser;
@property (nonatomic) MCAdvertiserAssistant *advertiser;

@property (nonatomic) MCPeerID *connectedPeerId;
@property (nonatomic) NSInputStream *inputStream;
@property (nonatomic) NSOutputStream *outputStream;

+ (JWCMultipeerController *)sharedController;

- (void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
- (void)setupMCBrowser;
- (void)advertiseSelf:(BOOL)shouldAdvertise;

@end



