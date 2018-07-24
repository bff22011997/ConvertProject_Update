//
//  Database.h
//  ConvertProject
//
//  Created by Trung Kiên on 7/23/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Admin.h"
@interface Database : NSObject {
    sqlite3_stmt  *stmt;
}
+ (Database *)defaultDatabaseManager;
-(void) insertUser :(Admin *)u;
-(NSMutableArray *) getAllUser;
-(void)deleteUserWithID:(NSString *)ID;
@end
