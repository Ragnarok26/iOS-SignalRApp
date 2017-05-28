//
//  Synchronization.m
//  SQL
//
//  Created by DESAROLLO on 30/04/15.
//  Copyright (c) 2015 GTM-DESAROLLO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Synchronization.h"
#import "Reachability.h"
#import "Operation.h"
#import "FMDatabase.h"
#import "WebService.h"

@implementation Synchronization : NSObject

@synthesize NAMESPACE = _NAMESPACE;
@synthesize URL = _URL;
@synthesize METHOD_NAME_SYNC_TO_CLIENT = _METHOD_NAME_SYNC_TO_CLIENT;
@synthesize SOAP_ACTION_SYNC_TO_CLIENT = _SOAP_ACTION_SYNC_TO_CLIENT;
@synthesize METHOD_NAME_SYNC_TO_SERVER = _METHOD_NAME_SYNC_TO_SERVER;
@synthesize SOAP_ACTION_SYNC_TO_SERVER = _SOAP_ACTION_SYNC_TO_SERVER;
@synthesize tables = _tables;
@synthesize separator = _separator;
@synthesize ipDatabase = _ipDatabase;
@synthesize userDatabase = _userDatabase;
@synthesize passwordDatabase = _passwordDatabase;
@synthesize catalogDatabase = _catalogDatabase;
@synthesize queriesDatabase = _queriesDatabase;
@synthesize clientKey = _clientKey;
@synthesize ndb = _ndb;
@synthesize statusConnection = _statusConnection;
@synthesize internetReachable = _internetReachable;
@synthesize hostReachable = _hostReachable;
@synthesize syncFinished = _syncFinished;
@synthesize syncStatus = _syncStatus;

- (instancetype) init {
    if (self = [super init]) {
        _ndb = [[NSMutableArray alloc] init];
        _NAMESPACE = [[NSString alloc] init];
        _URL = [[NSString alloc] init];
        _METHOD_NAME_SYNC_TO_CLIENT = [[NSString alloc] init];
        _SOAP_ACTION_SYNC_TO_CLIENT = [[NSString alloc] init];
        _METHOD_NAME_SYNC_TO_SERVER = [[NSString alloc] init];
        _SOAP_ACTION_SYNC_TO_SERVER = [[NSString alloc] init];
        _tables = [[NSString alloc] init];
        _separator = [[NSString alloc] init];
        _ipDatabase = [[NSString alloc] init];
        _userDatabase = [[NSString alloc] init];
        _passwordDatabase = [[NSString alloc] init];
        _catalogDatabase = [[NSString alloc] init];
        _queriesDatabase = [[NSString alloc] init];
        _clientKey = [[NSString alloc] init];
        _statusConnection = [Operation CONNECTION_STATUS_DISABLED];
        _ndb = [[NSMutableArray alloc] init];
        [_ndb addObject:@"sqlite_sequence"];
        _syncFinished = NO;
        _syncStatus = 0;
        _internetReachable = [Reachability reachabilityForInternetConnection];
        // check if a pathway to a random host exists
        _hostReachable = [Reachability reachabilityWithHostName:@"www.google.com"];
        
        NetworkStatus internetStatus = [_internetReachable currentReachabilityStatus];
        switch (internetStatus)
        {
            case NotReachable:
            {
                _statusConnection = [Operation CONNECTION_STATUS_DISABLED];
                break;
            }
            case ReachableViaWiFi:
            {
                _statusConnection = [Operation CONNECTION_STATUS_WIFI_OK];
                break;
            }
            case ReachableViaWWAN:
            {
                _statusConnection = [Operation CONNECTION_STATUS_MOBILE_OK];
                break;
            }
        }
        
        NetworkStatus hostStatus = [_hostReachable currentReachabilityStatus];
        switch (hostStatus)
        {
            case NotReachable:
            {
                _statusConnection = [Operation CONNECTION_STATUS_DISABLED];
                break;
            }
            case ReachableViaWiFi:
            {
                _statusConnection = [Operation CONNECTION_STATUS_WIFI_OK];
                break;
            }
            case ReachableViaWWAN:
            {
                _statusConnection = [Operation CONNECTION_STATUS_MOBILE_OK];
                break;
            }
        }
        
        // now patiently wait for the notification
    }
    return self;
}

-(int) getStatusConnection
{
    _internetReachable = [Reachability reachabilityForInternetConnection];
    // check if a pathway to a random host exists
    _hostReachable = [Reachability reachabilityWithHostName:@"www.google.com"];
    // called after network status changes
    NetworkStatus internetStatus = [_internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            _statusConnection = [Operation CONNECTION_STATUS_DISABLED];
            break;
        }
        case ReachableViaWiFi:
        {
            _statusConnection = [Operation CONNECTION_STATUS_WIFI_OK];
            break;
        }
        case ReachableViaWWAN:
        {
            _statusConnection = [Operation CONNECTION_STATUS_MOBILE_OK];
            break;
        }
    }
    
    NetworkStatus hostStatus = [_hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            _statusConnection = [Operation CONNECTION_STATUS_DISABLED];
            break;
        }
        case ReachableViaWiFi:
        {
            _statusConnection = [Operation CONNECTION_STATUS_WIFI_OK];
            break;
        }
        case ReachableViaWWAN:
        {
            _statusConnection = [Operation CONNECTION_STATUS_MOBILE_OK];
            break;
        }
    }
    
    return _statusConnection;
}

- (bool) isFirstSync {
    @try {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *path = [docsPath stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.db", _catalogDatabase]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path] && [[NSFileManager defaultManager] fileExistsAtPath:[path  stringByReplacingOccurrencesOfString: @".db" withString: @"_Sync.db"]])
        {
            return NO;
        }
        else {
            return YES;
        }
    }
    @catch (NSException *ex) {
        return YES;
    }
}

- (void) Synchronize {
    _syncFinished = NO;
    _syncStatus = 0;
    bool firstSync = [self isFirstSync];
    if (firstSync) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *path = [docsPath stringByAppendingPathComponent: [NSString stringWithFormat: @"%@_Sync.db", _catalogDatabase]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        BOOL fileExists = [fileManager fileExistsAtPath:path];
        if (fileExists) {
            [fileManager removeItemAtPath:path error:&error];
            path = [docsPath stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.db", _catalogDatabase]];
            fileExists = [fileManager fileExistsAtPath:path];
            if (fileExists) {
                [fileManager removeItemAtPath:path error:&error];
            }
        }
    }
    WebService *webServ = [[WebService alloc] init: _NAMESPACE :_URL :_METHOD_NAME_SYNC_TO_CLIENT :_SOAP_ACTION_SYNC_TO_CLIENT :Operation.Sync_MSSQLServer_To_SQLite];
    [webServ setDatos:_ipDatabase :_userDatabase :_passwordDatabase :_catalogDatabase :_tables :_separator];
    NSString * resp = [webServ request];
    if (![resp hasPrefix:@"#E"]) {
        _syncStatus = 1;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *path = [docsPath stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.db", _catalogDatabase]];
        FMDatabase *database = [FMDatabase databaseWithPath:path];
        if (!firstSync) {
            NSMutableArray *table = nil;
            if ([[_tables stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"*"]) {
                [database open];
                FMResultSet *results = [database executeQuery:@"SELECT name FROM sqlite_master WHERE type='table'"];
                table = [[NSMutableArray alloc] init];
                while([results next]) {
                    if (![_ndb containsObject:[results objectForColumnIndex:0]]) {
                        [table addObject:[results objectForColumnIndex:0]];
                    }
                }
                [database close];
            }
            else {
                table = ((NSMutableArray *)[_tables componentsSeparatedByString:_separator]);
            }
            if (table != nil) {
                [database open];
                for (int x = 0; x < [table count]; x++) {
                    if (![[table objectAtIndex:x] isEqualToString:@""]) {
                        [database executeUpdate:[NSString stringWithFormat:@"DROP TABLE %@", [table objectAtIndex:x]]];
                    }
                }
                [database close];
            }
        }
        NSMutableArray *query = ((NSMutableArray *)[resp componentsSeparatedByString:@";\n"]);
        [database open];
        for (int x = 0; x < [query count]; x++) {
            if (![[query objectAtIndex:x] isEqualToString:@""] && ![[query objectAtIndex:x] isEqualToString:@"\n"]) {
                [database executeUpdate:[query objectAtIndex:x]];
            }
        }
        [database close];
        path = [path stringByReplacingOccurrencesOfString:@".db" withString:@"_Sync.db"];
        database = [FMDatabase databaseWithPath:path];
        [database open];
        [database close];
    }
    else {
        resp = [resp stringByReplacingOccurrencesOfString:@"#E" withString:@""];
        _syncStatus = [resp intValue];
        _syncStatus *= -1;
    }
    _syncFinished = YES;
}

- (void) SynchronizePartial {
    _syncFinished = NO;
    _syncStatus = 0;
    bool firstSync = [self isFirstSync];
    if (firstSync) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *path = [docsPath stringByAppendingPathComponent: [NSString stringWithFormat: @"%@_Sync.db", _catalogDatabase]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        BOOL fileExists = [fileManager fileExistsAtPath:path];
        if (fileExists) {
            [fileManager removeItemAtPath:path error:&error];
            path = [docsPath stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.db", _catalogDatabase]];
            fileExists = [fileManager fileExistsAtPath:path];
            if (fileExists) {
                [fileManager removeItemAtPath:path error:&error];
            }
        }
    }
    WebService *webServ = [[WebService alloc] init: _NAMESPACE :_URL :_METHOD_NAME_SYNC_TO_CLIENT :_SOAP_ACTION_SYNC_TO_CLIENT :Operation.Sync_MSSQLServer_To_SQLite];
    [webServ setDatos:_ipDatabase :_userDatabase :_passwordDatabase :_catalogDatabase :_tables :_separator :_queriesDatabase];
    NSString * resp = [webServ request];
    if (![resp hasPrefix:@"#E"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *path = [docsPath stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.db", _catalogDatabase]];
        FMDatabase *database = [FMDatabase databaseWithPath:path];
        if (!firstSync) {
            NSMutableArray *table = nil;
            if ([[_tables stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"*"]) {
                [database open];
                FMResultSet *results = [database executeQuery:@"SELECT name FROM sqlite_master WHERE type='table'"];
                table = [[NSMutableArray alloc] init];
                while([results next]) {
                    if (![_ndb containsObject:[results objectForColumnIndex:0]]) {
                        [table addObject:[results objectForColumnIndex:0]];
                    }
                }
                [database close];
            }
            else {
                table = ((NSMutableArray *)[_tables componentsSeparatedByString:_separator]);
            }
            if (table != nil) {
                [database open];
                for (int x = 0; x < [table count]; x++) {
                    if (![[table objectAtIndex:x] isEqualToString:@""]) {
                        [database executeUpdate:[NSString stringWithFormat:@"DROP TABLE %@", [table objectAtIndex:x]]];
                    }
                }
                [database close];
            }
        }
        NSMutableArray *query = ((NSMutableArray *)[resp componentsSeparatedByString:@";\n"]);
        [database open];
        for (int x = 0; x < [query count]; x++) {
            if (![[query objectAtIndex:x] isEqualToString:@""] && ![[query objectAtIndex:x] isEqualToString:@"\n"]) {
                [database executeUpdate:[query objectAtIndex:x]];
            }
        }
        [database close];
        path = [path stringByReplacingOccurrencesOfString:@".db" withString:@"_Sync.db"];
        database = [FMDatabase databaseWithPath:path];
        [database open];
        [database close];
    }
    else {
        resp = [resp stringByReplacingOccurrencesOfString:@"#E" withString:@""];
        _syncStatus = [resp intValue];
        _syncStatus *= -1;
    }
    _syncFinished = YES;
}

- (void) SynchronizeByKey {
    _syncFinished = NO;
    _syncStatus = 0;
    bool firstSync = [self isFirstSync];
    if (firstSync) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *path = [docsPath stringByAppendingPathComponent: [NSString stringWithFormat: @"%@_Sync.db", _catalogDatabase]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        BOOL fileExists = [fileManager fileExistsAtPath:path];
        if (fileExists) {
            [fileManager removeItemAtPath:path error:&error];
            path = [docsPath stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.db", _catalogDatabase]];
            fileExists = [fileManager fileExistsAtPath:path];
            if (fileExists) {
                [fileManager removeItemAtPath:path error:&error];
            }
        }
    }
    WebService *webServ = [[WebService alloc] init: _NAMESPACE :_URL :_METHOD_NAME_SYNC_TO_CLIENT :_SOAP_ACTION_SYNC_TO_CLIENT :Operation.Sync_MSSQLServer_To_SQLite];
    [webServ setDatos:_clientKey :_ipDatabase :_userDatabase :_passwordDatabase :_catalogDatabase :_tables :_separator :_queriesDatabase];
    NSString * resp = [webServ request];
    if (![resp hasPrefix:@"#E"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *path = [docsPath stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.db", _catalogDatabase]];
        FMDatabase *database = [FMDatabase databaseWithPath:path];
        if (!firstSync) {
            NSMutableArray *table = nil;
            if ([[_tables stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"*"]) {
                [database open];
                FMResultSet *results = [database executeQuery:@"SELECT name FROM sqlite_master WHERE type='table'"];
                table = [[NSMutableArray alloc] init];
                while([results next]) {
                    if (![_ndb containsObject:[results objectForColumnIndex:0]]) {
                        [table addObject:[results objectForColumnIndex:0]];
                    }
                }
                [database close];
            }
            else {
                table = ((NSMutableArray *)[_tables componentsSeparatedByString:_separator]);
            }
            if (table != nil) {
                [database open];
                for (int x = 0; x < [table count]; x++) {
                    if (![[table objectAtIndex:x] isEqualToString:@""]) {
                        [database executeUpdate:[NSString stringWithFormat:@"DROP TABLE %@", [table objectAtIndex:x]]];
                    }
                }
                [database close];
            }
        }
        NSMutableArray *query = ((NSMutableArray *)[resp componentsSeparatedByString:@";\n"]);
        [database open];
        for (int x = 0; x < [query count]; x++) {
            if (![[query objectAtIndex:x] isEqualToString:@""] && ![[query objectAtIndex:x] isEqualToString:@"\n"]) {
                [database executeUpdate:[query objectAtIndex:x]];
            }
        }
        [database close];
        path = [path stringByReplacingOccurrencesOfString:@".db" withString:@"_Sync.db"];
        database = [FMDatabase databaseWithPath:path];
        [database open];
        [database close];
    }
    else {
        resp = [resp stringByReplacingOccurrencesOfString:@"#E" withString:@""];
        _syncStatus = [resp intValue];
        _syncStatus *= -1;
    }
    _syncFinished = YES;
}

- (void) saveInQueue:(NSString *)sql {
    @try {
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *path = [docsPath stringByAppendingPathComponent: [NSString stringWithFormat: @"%@_Sync.db", _catalogDatabase]];
        FMDatabase *database = [FMDatabase databaseWithPath:path];
        [database open];
        bool n = [database executeUpdate:@"CREATE TABLE IF NOT EXISTS Queue(Id integer PRIMARY KEY AUTOINCREMENT NOT NULL, Date TEXT NOT NULL, Query TEXT NOT NULL, Database TEXT NOT NULL, State INT NOT NULL);"];
        n =[database executeUpdate:[NSString stringWithFormat: @"INSERT INTO Queue(Date, Query, Database, State) VALUES('%@', \"%@\", '%@', 0);", [DateFormatter stringFromDate:[NSDate date]], sql, _catalogDatabase]];
        [database close];
    }
    @catch (NSException *ex) {
    }
    @finally {
    }
}

- (int) ExecuteNonQuery:(NSString *)sql {
    int rowsAffected = -1;
    @try {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *path = [docsPath stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.db", _catalogDatabase]];
        FMDatabase *database = [FMDatabase databaseWithPath:path];
        [database open];
        rowsAffected = [database executeUpdate:sql];
        [database close];
    }
    @catch (NSException *ex) {
        rowsAffected = -1;
    }
    @finally {
        if (![sql isEqualToString:@""] && rowsAffected > 0) {
            [self saveInQueue:sql];
        }
        return rowsAffected;
    }
}

- (NSMutableArray *) ExecuteSelect:(NSString *)sql {
    NSMutableArray *rows = nil;
    NSMutableArray *row = nil;
    @try {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *path = [docsPath stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.db", _catalogDatabase]];
        FMDatabase *database = [FMDatabase databaseWithPath:path];
        [database open];
        FMResultSet *results = [database executeQuery:sql];
        rows = [[NSMutableArray alloc] init];
        while([results next]) {
            row = [[NSMutableArray alloc] init];
            for (int x = 0; x < [results columnCount]; x++) {
                [row addObject:[results objectForColumnIndex:x]];
            }
            [rows addObject:row];
            row = nil;
        }
        [database close];
        return rows;
    }
    @catch (NSException *exception) {
        return rows;
    }
    @finally {
        rows = nil;
        row = nil;
    }
}

- (void) ApplyChanges {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent: [NSString stringWithFormat: @"%@_Sync.db", _catalogDatabase]];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT Id, Query FROM Queue WHERE State = 0 ORDER BY Date ASC"];
    NSString *res = @"%@%@";
    NSString *ids = @"%@%@";
    bool flag = NO;
    while([results next]) {
        flag = YES;
        ids = [NSString stringWithFormat:ids,[results stringForColumnIndex:0],@",%@%@"];
        res = [NSString stringWithFormat:res,[results stringForColumnIndex:1],@";%@%@"];
    }
    if (!flag) {
        ids = @"";
        res = @"";
    }
    else {
        ids = [NSString stringWithFormat:ids,@"",@""];
        res = [NSString stringWithFormat:res,@"",@""];
        ids = [ids substringToIndex:[ids length] - 1];
        res = [res substringToIndex:[res length] - 1];
    }
    [database close];
    if (![res isEqual: @""]) {
        WebService *web = [[WebService alloc] init:_NAMESPACE :_URL :_METHOD_NAME_SYNC_TO_SERVER :_SOAP_ACTION_SYNC_TO_SERVER :Operation.Sync_MSSQLServer_To_SQLite];
        [web setDatos:_ipDatabase :_userDatabase :_passwordDatabase :_catalogDatabase :res];
        @try {
            res = web.request;
        }
        @catch (NSException *ex) {
            res = @"";
        }
        /*@try {
            ids = [ids substringToIndex:ids.length - 1];
        }
        @catch (NSException *) {
            ids = @"";
        }*/
        if (![ids isEqual:@""]) {
            [database open];
            [database executeUpdate:[NSString stringWithFormat:@"UPDATE Queue SET State = 1 WHERE Id IN(%@)", ids]];
            [database close];
        }
    }
}

- (void) ApplyChanges:(NSInteger *)n {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent: [NSString stringWithFormat: @"%@_Sync.db", _catalogDatabase]];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    NSString *query = @"SELECT Id, Query FROM Queue WHERE State = 0 ORDER BY Date ASC%@";
    if (n > 0) {
        query = [NSString stringWithFormat:query,@" LIMIT %ld"];
        query = [NSString stringWithFormat:query,(long)n];
    }
    else {
        query = [NSString stringWithFormat:query,@""];
    }
    FMResultSet *results = [database executeQuery:query];
    NSString *res = @"%@%@";
    NSString *ids = @"%@%@";
    bool flag = NO;
    while([results next]) {
        flag = YES;
        ids = [NSString stringWithFormat:ids,[results stringForColumnIndex:0],@",%@%@"];
        res = [NSString stringWithFormat:res,[results stringForColumnIndex:1],@";%@%@"];
    }
    if (!flag) {
        ids = @"";
        res = @"";
    }
    else {
        ids = [NSString stringWithFormat:ids,@"",@""];
        res = [NSString stringWithFormat:res,@"",@""];
        ids = [ids substringToIndex:[ids length] - 1];
        res = [res substringToIndex:[res length] - 1];
    }
    [database close];
    if (![res isEqual: @""]) {
        WebService *web = [[WebService alloc] init:_NAMESPACE :_URL :_METHOD_NAME_SYNC_TO_SERVER :_SOAP_ACTION_SYNC_TO_SERVER :Operation.Sync_MSSQLServer_To_SQLite];
        [web setDatos:_ipDatabase :_userDatabase :_passwordDatabase :_catalogDatabase :res];
        @try {
            res = web.request;
        }
        @catch (NSException *ex) {
            res = @"";
        }
        /*@try {
            ids = [ids substringToIndex:ids.length - 1];
        }
        @catch (NSException *) {
            ids = @"";
        }*/
        if (![ids isEqual:@""]) {
            [database open];
            [database executeUpdate:[NSString stringWithFormat:@"UPDATE Queue SET State = 1 WHERE Id IN(%@)", ids]];
            [database close];
        }
    }
}

- (void) clearQueue {
    NSString *sqlQueue = @"DELETE FROM Queue WHERE State=1";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent: [NSString stringWithFormat: @"%@_Sync.db", _catalogDatabase]];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    [database executeUpdate:sqlQueue];
    [database close];
}

- (void) dealloc {
    _ndb = nil;
    _NAMESPACE = nil;
    _URL = nil;
    _METHOD_NAME_SYNC_TO_CLIENT = nil;
    _SOAP_ACTION_SYNC_TO_CLIENT = nil;
    _METHOD_NAME_SYNC_TO_SERVER = nil;
    _SOAP_ACTION_SYNC_TO_SERVER = nil;
    _tables = nil;
    _separator = nil;
    _ipDatabase = nil;
    _userDatabase = nil;
    _passwordDatabase = nil;
    _catalogDatabase = nil;
    _queriesDatabase = nil;
    _clientKey = nil;
    _statusConnection = 0;
}

@end
