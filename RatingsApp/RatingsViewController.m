//
//  RatingsViewController.m
//  RatingsApp
//
//  Created by Optimus - 113 on 22/08/15.
//  Copyright (c) 2015 iOSRookie. All rights reserved.
//

#import "RatingsViewController.h"
#import "RatingsDBHandler.h"
#import "AppDelegate.h"

@interface RatingsViewController () <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;
@property (strong, nonatomic) IBOutlet UISlider *ratingSlider;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;
@property (strong, nonatomic) IBOutlet UITextView *suggestionBox;

@end

@implementation RatingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.productNameLabel.text = self.productName;
}

- (IBAction)ratingChanged:(id)sender {
    int discreteValue = roundl([self.ratingSlider value]);
    self.ratingSlider.value = (float)discreteValue;
    self.ratingLabel.text = [NSString stringWithFormat:@"%d", discreteValue];
}

- (IBAction)submitFeedback:(id)sender {
    NSString *userEmail = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).userEmail;
    int rating = roundl([self.ratingSlider value]);
    NSString *suggestion = [self.suggestionBox.text isEqualToString:@"Suggestions..."] ? @"" : self.suggestionBox.text;
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *today = [formatter stringFromDate:[NSDate date]];
    BOOL saved = [[RatingsDBHandler database] addFeedbackForProduct:self.productID WithUserEmail:userEmail ratings:rating andFeedback:suggestion onDate:today];
    if (saved) {
        if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success!" message:@"Rating submitted" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Rating submitted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Suggestions..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Suggestions...";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
