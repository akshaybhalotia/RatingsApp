//
//  ResultsViewController.m
//  RatingsApp
//
//  Created by Optimus - 113 on 22/08/15.
//  Copyright (c) 2015 iOSRookie. All rights reserved.
//

#import "ResultsViewController.h"
#import "RatingsDBHandler.h"

static NSString *const HEADER_CELL_IDENTIFIER = @"HeaderCell";
static NSString *const RATING_CELL_IDENTIFIER = @"RatingCell";

@interface FeedbackPerProduct : NSObject
@property NSString *productName;
@property CGFloat MTD;
@property CGFloat YTD;

@end

@implementation FeedbackPerProduct

@end


@interface RatingListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *MTDRating;
@property (strong, nonatomic) IBOutlet UILabel *YTDRating;

@end

@implementation RatingListCell

@end

@interface ResultsViewController () <UITableViewDataSource> {
    NSArray *products;
    NSMutableArray *feedbacks;
}

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    products = [[RatingsDBHandler database] getProducts];
    feedbacks = [NSMutableArray array];
    [self calculateFeedBackPerProduct];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([products count]) {
        return [products count] + 1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HEADER_CELL_IDENTIFIER forIndexPath:indexPath];
        return cell;
    }
    else {
        RatingListCell *cell = [tableView dequeueReusableCellWithIdentifier:RATING_CELL_IDENTIFIER forIndexPath:indexPath];
        cell.productNameLabel.text = ((FeedbackPerProduct *)feedbacks[indexPath.row]).productName;
        cell.MTDRating.text = [NSString stringWithFormat:@"%f", ((FeedbackPerProduct *)feedbacks[indexPath.row]).MTD];
        cell.YTDRating.text = [NSString stringWithFormat:@"%f", ((FeedbackPerProduct *)feedbacks[indexPath.row]).YTD];
        return cell;
    }
}

- (void)calculateFeedBackPerProduct {
    for (Product *thisProduct in products) {
        FeedbackPerProduct *feedbackForProduct = [FeedbackPerProduct new];
        feedbackForProduct.productName = thisProduct.productName;
        NSArray *listOfFeedbacks = [[RatingsDBHandler database] searchFeedbackInfoForID:thisProduct.productID];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
