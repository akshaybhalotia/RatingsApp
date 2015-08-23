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

@interface RatingsViewController () <UITextViewDelegate, UIGestureRecognizerDelegate> {
    UITextView *activeField;
    UITapGestureRecognizer *tapGesture;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;
@property (strong, nonatomic) IBOutlet UISlider *ratingSlider;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;
@property (strong, nonatomic) IBOutlet UITextView *suggestionBox;

@end

@implementation RatingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(!tapGesture)
    {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enableEndEditing)];
    }
    
    // Sets parameters for the Tap Gesture Recognizer and adds it to the view.
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
    
    self.suggestionBox.layer.borderColor = [[UIColor grayColor] CGColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.productNameLabel.text = self.productName;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
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
    activeField = textView;
    [textView becomeFirstResponder];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Suggestions...";
        textView.textColor = [UIColor lightGrayColor];
    }
    activeField = nil;
    [textView resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    // Unregister the view for keyboard notifications.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *)aNotification
{
    // scroll to the text view
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 10, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible.
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGRect thisFrame = [activeField.superview convertRect:activeField.frame toView:self.view];
    if (!CGRectContainsPoint(aRect, thisFrame.origin) ) {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    // scroll back..
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
}

- (void)enableEndEditing
{
    [self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
