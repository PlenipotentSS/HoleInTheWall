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

- (MCSession *)session
{
    if (!_session) {
        _session = [[MCSession alloc] initWithPeer:[JWCDimensions sharedController].localPeerID
                                  securityIdentity:nil
                              encryptionPreference:MCEncryptionNone];
    }
    return _session;
}

#pragma mark MCNearybyServiceAdvertiser methods
- (void)advertiseService
{
    MCNearbyServiceAdvertiser *advertiser = [[MCNearbyServiceAdvertiser alloc]
                                             initWithPeer:[JWCDimensions sharedController].localPeerID
                                            discoveryInfo:Nil
                                              serviceType:MultiHoleServiceType];
    advertiser.delegate = self;
    [advertiser startAdvertisingPeer];
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser
didReceiveInvitationFromPeer:(MCPeerID *)peerID
       withContext:(NSData *)context
 invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler
{
    self.session = [[MCSession alloc] initWithPeer:[JWCDimensions sharedController].localPeerID
                                  securityIdentity:nil
                              encryptionPreference:MCEncryptionNone];
    self.session.delegate = self;
    self.multiHolePartnerPeerID = peerID;
}

#pragma mark - MCNearbyServiceBrowser Methods
- (MCNearbyServiceBrowser *)browser
{
    if (!_browser) {
        _browser = [[MCNearbyServiceBrowser alloc]
                                        initWithPeer:[JWCDimensions sharedController].localPeerID
                                         serviceType:MultiHoleServiceType];
    }
    _browser.delegate = self;
    return _browser;
}

- (void)browser:(MCNearbyServiceBrowser *)browser
      foundPeer:(MCPeerID *)peerID
withDiscoveryInfo:(NSDictionary *)info
{
    
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    
}

#pragma mark - MCBrowserViewControllerDelegate
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    NSOutputStream *outputStream =
    [self.session startStreamWithName:MultiHoleStreamName
                               toPeer:self.multiHolePartnerPeerID
                                error:nil];
    
    outputStream.delegate = self;
    [outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop]
                      forMode:NSDefaultRunLoopMode];
    [outputStream open];
    
    [browserViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [browserViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MCSessionDelegate
- (void)session:(MCSession *)session
didReceiveStream:(NSInputStream *)stream
       withName:(NSString *)streamName
       fromPeer:(MCPeerID *)peerID
{
    stream.delegate = self;
    [stream scheduleInRunLoop:[NSRunLoop mainRunLoop]
                      forMode:NSDefaultRunLoopMode];
    [stream open];
}

#pragma mark - NSStreamDelegate
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    
}

@end
