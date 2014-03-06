//
//  JWCMultipeerController.m
//  HoleInTheWall
//
//  Created by Jeff Schwab on 3/6/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCMultipeerController.h"


@implementation JWCMultipeerController

+ (JWCMultipeerController *)sharedController
{
    static JWCMultipeerController *sharedController = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
    });
    
    return sharedController;
}

- (id)init{
    self = [super init];
    
    if (self) {
        _peerID = nil;
        _session = nil;
        _browser = nil;
        _advertiser = nil;
    }
    
    return self;
}


#pragma mark - Public method implementation

- (void)setupPeerAndSessionWithDisplayName:(NSString *)displayName{
    _peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    
    _session = [[MCSession alloc] initWithPeer:_peerID];
    _session.delegate = self;
}


- (void)setupMCBrowser{
    _browser = [[MCBrowserViewController alloc] initWithServiceType:MultiHoleServiceType session:_session];
}


- (void)advertiseSelf:(BOOL)shouldAdvertise{
    if (shouldAdvertise) {
        _advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:MultiHoleServiceType
                                                           discoveryInfo:nil
                                                                 session:_session];
        [_advertiser start];
    }
    else{
        [_advertiser stop];
        _advertiser = nil;
    }
}

#pragma mark - MCBrowserViewControllerDelegate
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [browserViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [browserViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NSStreamDelegate Methods
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    if (state == MCSessionStateConnected) {
        self.connectedPeerId = peerID;
    }
}


@end
