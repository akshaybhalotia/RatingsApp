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
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.estimatedRowHeight = 2.0;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
        cell.productNameLabel.text = ((FeedbackPerProduct *)feedbacks[indexPath.row - 1]).productName;
        cell.MTDRating.text = [NSString stringWithFormat:@"%.02f", ((FeedbackPerProduct *)feedbacks[indexPath.row - 1]).MTD];
        cell.YTDRating.text = [NSString stringWithFormat:@"%.02f", ((FeedbackPerProduct *)feedbacks[indexPath.row - 1]).YTD];
        return cell;
    }
}

- (void)calculateFeedBackPerProduct {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [gregorian dateFromComponents:comp];
    [comp setMonth:1];
    NSDate *firstDayOfYearDate = [gregorian dateFromComponents:comp];
    
    for (Product *thisProduct in products) {
        FeedbackPerProduct *feedbackForProduct = [FeedbackPerProduct new];
        feedbackForProduct.productName = thisProduct.productName;
        NSArray *listOfFeedbacks = [[RatingsDBHandler database] searchFeedbackInfoForID:thisProduct.productID];
        int MTDCounter = 0;
        float MTDAccumulator = 0.0;
        int YTDCounter = 0;
        float YTDAccumulator = 0.0;
        for (Feedback *thisFeedback in listOfFeedbacks) {
            NSDate *feedbackDate = [dateFormatter dateFromString:thisFeedback.ratingDate];
            if ([firstDayOfMonthDate compare:feedbackDate] == NSOrderedAscending) {
                MTDAccumulator += thisFeedback.productRating;
                MTDCounter++;
            }
            if ([firstDayOfYearDate compare:feedbackDate] == NSOrderedAscending) {
                YTDAccumulator += thisFeedback.productRating;
                YTDCounter++;
            }
        }
        if (MTDCounter) {
            feedbackForProduct.MTD = MTDAccumulator / MTDCounter;
        }
        else {
            feedbackForProduct.MTD = 0.0;
        }
        if (YTDCounter) {
            feedbackForProduct.YTD = YTDAccumulator / YTDCounter;
        }
        else {
            feedbackForProduct.YTD = 0.0;
        }
        [feedbacks addObject:feedbackForProduct];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
