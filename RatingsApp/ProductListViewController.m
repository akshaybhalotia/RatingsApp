//
//  ProductsViewController.m
//  RatingsApp
//
//  Created by Optimus - 113 on 22/08/15.
//  Copyright (c) 2015 iOSRookie. All rights reserved.
//

#import "ProductListViewController.h"
#import "AppDelegate.h"

static NSString *const PRODUCT_CELL_IDENTIFIER = @"ProductCell";
static NSString *const RATING_SEGUE = @"rateProduct";

@interface ProductListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *productName;

@end

@implementation ProductListCell

@end

@interface ProductListViewController ()

@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:RATING_SEGUE]) {
        
    }
}

- (IBAction)signOutClicked:(id)sender {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] userDidSignOut];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
