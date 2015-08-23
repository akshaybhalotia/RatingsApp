//
//  RatingsDBHandler.h
//  RatingsApp
//
//  Created by Optimus - 113 on 23/08/15.
//  Copyright (c) 2015 iOSRookie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Product.h"
#import "Feedback.h"

@interface RatingsDBHandler : NSObject

+ (RatingsDBHandler *)database;

- (BOOL) addFeedbackForProduct:(NSString *)productID WithUserEmail:(NSString *)email ratings:(NSInteger)rating andFeedback:(NSString *)suggestion onDate:(NSString *)date;

- (NSArray *)searchFeedbackInfoForID:(NSString *)productID;

- (NSArray *)getProducts;

@end
