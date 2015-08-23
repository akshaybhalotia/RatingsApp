//
//  ResultsViewController.m
//  RatingsApp
//
//  Created by Optimus - 113 on 22/08/15.
//  Copyright (c) 2015 iOSRookie. All rights reserved.
//

#import "ResultsViewController.h"

static NSString *const HEADER_CELL_IDENTIFIER = @"HeaderCell";
static NSString *const RATING_CELL_IDENTIFIER = @"RatingCell";

@interface RatingListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *MTDRating;
@property (strong, nonatomic) IBOutlet UILabel *YTDRating;

@end

@implementation RatingListCell

@end

@interface ResultsViewController () <UITableViewDataSource>

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
