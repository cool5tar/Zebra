//
//  ZBProxyPackage.m
//  Zebra
//
//  Created by Wilson Styres on 2/23/20.
//  Copyright © 2020 Wilson Styres. All rights reserved.
//

#import "ZBProxyPackage.h"

#import <Database/ZBDatabaseManager.h>

@implementation ZBProxyPackage

@synthesize name;
@synthesize identifier;
@synthesize version;
@synthesize repoID;

@synthesize author;
@synthesize iconURL;
@synthesize section;

@synthesize package;

- (id)initWithSQLiteStatement:(sqlite3_stmt *)statement {
    self = [super init];
    
    if (self) {
        const char *packageIDChars   = (const char *)sqlite3_column_text(statement, 0);
        const char *packageNameChars = (const char *)sqlite3_column_text(statement, 1);
        const char *versionChars     = (const char *)sqlite3_column_text(statement, 2);
        int repoID                   =               sqlite3_column_int(statement, 3);
        
        [self setIdentifier:[NSString stringWithUTF8String:packageIDChars]]; // This should never be NULL
        [self setName:packageNameChars != 0 ? [NSString stringWithUTF8String:packageNameChars] : (self.identifier ? self.identifier : @"Unknown")]; // fall back to ID if NULL, or Unknown if things get worse
        [self setVersion:versionChars != 0 ? [NSString stringWithUTF8String:versionChars] : NULL];
        [self setRepoID:repoID];
    }
    
    return self;
}

- (ZBPackage *)loadPackage {
    if (package) return package;
    
    ZBDatabaseManager *databaseManager = [ZBDatabaseManager sharedInstance];
    package = [databaseManager packageFromProxy:self];
    
    return package;
}

@end