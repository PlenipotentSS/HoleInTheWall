//
//  JWCViewController.m
//  HoleInTheWall
//
//  Created by Jeff Schwab on 2/21/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCViewController.h"
#import "JWCScene.h"

@interface JWCViewController ()

@end

@implementation JWCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view = [SKView new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    // Testing wall
    SKView *gameView = (SKView *)self.view;
    
    JWCScene *scene = [JWCScene sceneWithSize:gameView.frame.size];
    scene.scaleMode = SKSceneScaleModeFill;
    
    [gameView presentScene:scene];
}

@end
