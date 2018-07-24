//
//  Database.m
//  ConvertProject
//
//  Created by Trung Kiên on 7/23/18.
//  Copyright © 2018 Trung Kiên. All rights reserved.
//

#import "Database.h"

@implementation Database {
    NSString *dbPathString;
    sqlite3 *UserDB;
}
static Database  *sharedObject = nil;
+ (Database *)defaultDatabaseManager {
    if (sharedObject == nil) {
        @synchronized(self){
            if (sharedObject == nil) {
                sharedObject = [[Database alloc] init];
            }
        }
    }
    return sharedObject;
}
- (NSString *)getDBPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"Restaurent.sqlite"];
}
-(void) insertUser :(Admin *)u {
    int check = [[[NSUserDefaults standardUserDefaults] objectForKey:@"checkAddUser"] intValue];
    if (check == 0) {
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = [path objectAtIndex:0];
        dbPathString = [docPath stringByAppendingPathComponent:@"Restaurent.sqlite"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        char *error;
        if ([fileManager fileExistsAtPath:dbPathString]) {
            const char *dbPath = [dbPathString UTF8String];
            if (sqlite3_open(dbPath, &UserDB)==SQLITE_OK) {
                const char *sql_stmt = "CREATE TABLE IF NOT EXISTS User (ID INTEGER PRIMARY KEY AUTOINCREMENT , Username TEXT,Password TEXT)";
                sqlite3_exec(UserDB, sql_stmt, NULL, NULL, &error);
                sqlite3_close(UserDB);
                
            }
        }
    }
    
    sqlite3 *database;
    NSString *dbPath = [self getDBPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        sqlite3_stmt *compiledStatement = nil;
        NSString *sqlQuery = [NSString stringWithFormat:@"insert into User (Username,Password) values('%@','%@')",u.name,u.password];
        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
            if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
                NSLog(@"SQL execution failed: %s", sqlite3_errmsg(database));
                
            }
        }
        
        sqlite3_finalize(compiledStatement);
        
    }
    sqlite3_close(database);
}
-(void)deleteUserWithID:(NSString *)ID {
    sqlite3 *database;
    NSString *dbPath = [self getDBPath];
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        sqlite3_stmt *compiledStatement = nil;
        
        NSString *sqlQuery = [NSString stringWithFormat:@"DELETE from User WHERE Username = '%@'",ID];
        
        if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &compiledStatement, nil) == SQLITE_OK) {
            
            if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
                NSLog(@"SQL execution failed: %s", sqlite3_errmsg(database));
                
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
}
-(NSMutableArray *) getAllUser {
    NSMutableArray *arrr = [[NSMutableArray alloc] init];
    sqlite3 *database;
    NSString *dbPath = [self getDBPath];
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *selectStatement;
        NSString *selectSql = [NSString stringWithFormat:@"select *from User"];
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &selectStatement, NULL) == SQLITE_OK) {
            while(sqlite3_step(selectStatement) == SQLITE_ROW){
                Admin *u = [[Admin alloc]init];
                //u.ID = (int)sqlite3_column_int64(selectStatement, 0);
                u.name = [NSString stringWithCString:(char *)sqlite3_column_text(selectStatement, 1) encoding:NSUTF8StringEncoding];
                u.password = [NSString stringWithCString:(char *)sqlite3_column_text(selectStatement, 2) encoding:NSUTF8StringEncoding];
                [arrr addObject:u];
                
            }
        }
        else {
            
            NSLog(@"Error %s",sqlite3_errmsg(database));
        }
        sqlite3_finalize(selectStatement);
        
    }
    sqlite3_close(database);
    return arrr;
}
@end

