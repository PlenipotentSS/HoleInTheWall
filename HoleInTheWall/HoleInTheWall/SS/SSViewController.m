//
//  SSViewController.m
//  HoleInTheWall
//
//  Created by Stevenson on 24/02/2014.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "SSViewController.h"
#import "SSGameScene.h"

#import "SSBackgroundView.h"

@interface SSViewController ()

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property(nonatomic) SSBackgroundView *backgroundView;

@end

@implementation SSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Testing wall
    SKView *blahView = [[SKView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:blahView];
    SSGameScene *scene = [SSGameScene sceneWithSize:self.view.frame.size];
    scene.scaleMode = SKSceneScaleModeFill;
    [blahView presentScene:scene];
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGRect destFrame = self.view.bounds;
    destFrame.size.width = self.view.bounds.size.height;
    destFrame.size.height = self.view.bounds.size.width;
    [UIView animateWithDuration:duration animations:^{
        self.backgroundView.frame = destFrame;
    }];
    
    NSLog(@"frame w: %f h: %f ",self.backgroundView.frame.size.width,self.backgroundView.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillLayoutSubviews
//{
//
//
//}


@end
