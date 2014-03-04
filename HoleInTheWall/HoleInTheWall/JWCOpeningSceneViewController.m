//
//  JWCOpeningSceneViewController.m
//  HoleInTheWall
//
//  Created by Matt Remick on 2/25/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "JWCOpeningSceneViewController.h"
#import "OpeningScene.h"
#import "MMRWallOpeningScene.h"

@interface JWCOpeningSceneViewController ()

@end

@implementation JWCOpeningSceneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    
    MMRWallOpeningScene *scene = [MMRWallOpeningScene sceneWithSize:gameView.frame.size];
    scene.scaleMode = SKSceneScaleModeFill;
    
    [gameView presentScene:scene];
}

@end
