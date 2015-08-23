//
//  RatingsDBHandler.m
//  RatingsApp
//
//  Created by Optimus - 113 on 23/08/15.
//  Copyright (c) 2015 iOSRookie. All rights reserved.
//

#import "RatingsDBHandler.h"

@interface RatingsDBHandler () {
    NSString *databasePath;
    sqlite3 *ratingsDB;
}

@end

@implementation RatingsDBHandler

static RatingsDBHandler *ratingsDatabase;

+ (RatingsDBHandler *)database {
    if (ratingsDatabase == nil) {
        ratingsDatabase = [[RatingsDBHandler alloc] init];
    }
    return ratingsDatabase;
}

- (id)init {
    
    // Checks if the object is only initialized with the properties of its superclass. If yes, then perform the following steps.
    if ((self = [super init])) {
        
        // Get the documents directory
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = [dirPaths objectAtIndex:0];
        
        // Build the path to the database file
        databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"ratings.db"]];
        NSFileManager *filemgr = [NSFileManager defaultManager];
        
        // Checks if file at the path for databse exists. If not, it creates the database file and the table(s).
        if ([filemgr fileExistsAtPath: databasePath ] == NO)
        {
            const char *dbpath = [databasePath UTF8String];
            if (sqlite3_open(dbpath, &ratingsDB) == SQLITE_OK)
            {
                char *err;
                const char *sql_stmt = "CREATE TABLE IF NOT EXISTS feedback(productid varchar(10), useremail varchar(50) NOT NULL, rating integer NOT NULL, suggestion varchar(2000) NOT NULL, date varchar(11) NOT NULL)";
                if (sqlite3_exec(ratingsDB, sql_stmt, NULL, NULL, &err) != SQLITE_OK)
                {
                    NSLog(@"Failed to create table");
                }
            }
            else {
                NSLog(@"Failed to open/create database");
            }
        }
        
        // If the file at the path for database exists, it creates a new table if there is no table.
        else {
            const char *dbpath = [databasePath UTF8String];
            sqlite3_open(dbpath, &ratingsDB);
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS feedback(productid varchar(10), useremail varchar(50) NOT NULL, rating integer NOT NULL, suggestion varchar(2000) NOT NULL, date varchar(11) NOT NULL)";
            char *err;
            if (sqlite3_exec(ratingsDB, sql_stmt, NULL, NULL, &err) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
        }
    }
    sqlite3_close(ratingsDB);
    return self;
}

- (BOOL) addFeedbackForProduct:(NSString *)productID WithUserEmail:(NSString *)email ratings:(NSInteger)rating andFeedback:(NSString *)suggestion onDate:(NSString *)date
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &ratingsDB) == SQLITE_OK)
    {
        sqlite3_stmt *statement;
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO feedback (productid, useremail, rating, suggestion, date) VALUES (\"%@\", \"%@\", \"%ld\", \"%@\", \"%@\")", productID, email, rating, suggestion, date];
        const char *insert_stmt = [insertSQL UTF8String];
        int x = sqlite3_prepare_v2(ratingsDB, insert_stmt, -1, &statement, nil);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            sqlite3_close(ratingsDB);
            return YES;
        }
        else {
            NSLog(@"Failed to add record, error:%d", x);
        }
        sqlite3_finalize(statement);
        sqlite3_close(ratingsDB);
    }
    return NO;
}

-(NSArray *)searchFeedbackInfoForID:(NSString *)productID {
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM feedback WHERE productid = \'%@\'", productID];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_open(dbpath, &ratingsDB);
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(ratingsDB, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *product = (char *) sqlite3_column_text(statement, 0);
            char *useremail = (char *) sqlite3_column_text(statement, 1);
            int rating = sqlite3_column_int(statement, 2);
            char *suggestion = (char *) sqlite3_column_text(statement, 3);
            char *date = (char *) sqlite3_column_text(statement, 4);
            Feedback *details = [Feedback new];
            details.productID = [[NSString alloc] initWithUTF8String:product];
            details.userEmail = [[NSString alloc] initWithUTF8String:useremail];
            details.productRating = rating;
            details.suggestion = [[NSString alloc] initWithUTF8String:suggestion];
            details.ratingDate = [[NSString alloc] initWithUTF8String:date];
            [retval addObject:details];
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(ratingsDB);
    return retval;
}

-(NSArray *)getProducts {
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Product List" ofType: @"plist"];
    NSArray *products = [NSArray arrayWithContentsOfFile: path];
    NSMutableArray *productList = [NSMutableArray array];
    for (NSDictionary *thisProduct in products) {
        Product *newProduct = [Product new];
        newProduct.productID = thisProduct[@"productID"];
        newProduct.productName = thisProduct[@"productName"];
        [productList addObject:newProduct];
    }
    return productList;
}

@end
