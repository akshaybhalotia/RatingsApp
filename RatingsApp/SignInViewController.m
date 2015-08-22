//
//  ViewController.m
//  RatingsApp
//
//  Created by Optimus - 113 on 22/08/15.
//  Copyright (c) 2015 iOSRookie. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()
@property (strong, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property (strong, nonatomic) IBOutlet UIImageView *signInImage;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [GIDSignIn sharedInstance].uiDelegate = self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.signInButton bringSubviewToFront:self.signInImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
