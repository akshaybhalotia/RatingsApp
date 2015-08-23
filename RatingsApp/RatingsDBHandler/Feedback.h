//
//  Feedback.h
//  RatingsApp
//
//  Created by Optimus - 113 on 23/08/15.
//  Copyright (c) 2015 iOSRookie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feedback : NSObject

@property NSString *productID;
@property NSString *userEmail;
@property NSInteger productRating;
@property NSString *suggestion;
@property NSString *ratingDate;

@end
