//
//  ProductsViewController.m
//  RatingsApp
//
//  Created by Optimus - 113 on 22/08/15.
//  Copyright (c) 2015 iOSRookie. All rights reserved.
//

#import "ProductListViewController.h"
#import "AppDelegate.h"
#import "RatingsViewController.h"
#import "RatingsDBHandler.h"

static NSString *const PRODUCT_CELL_IDENTIFIER = @"ProductCell";
static NSString *const RATING_SEGUE = @"rateProduct";

@interface ProductListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *productName;

@end

@implementation ProductListCell

@end

@interface ProductListViewController () {
    NSArray *products;
}

@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    products = [[RatingsDBHandler database] getProducts];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [products count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:PRODUCT_CELL_IDENTIFIER forIndexPath:indexPath];
    cell.productName.text = ((Product *)[products objectAtIndex:indexPath.row]).productName;
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:RATING_SEGUE]) {
        ((RatingsViewController *)segue.destinationViewController).productID = ((Product *)[products objectAtIndex:[self.tableView indexPathForSelectedRow].row]).productID;
        ((RatingsViewController *)segue.destinationViewController).productName = ((Product *)[products objectAtIndex:[self.tableView indexPathForSelectedRow].row]).productName;
    }
}

- (IBAction)signOutClicked:(id)sender {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] userDidSignOut];
}

-(void)rate:(UIStoryboardSegue *)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
