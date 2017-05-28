//
//  Synchronization.h
//  SQL
//
//  Created by DESAROLLO on 30/04/15.
//  Copyright (c) 2015 GTM-DESAROLLO. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Reachability;

@interface Synchronization : NSObject
@property (retain, nonatomic) Reachability* internetReachable;
@property (retain, nonatomic) Reachability* hostReachable;

@property (strong, nonatomic) NSString *NAMESPACE;
@property (strong, nonatomic) NSString *URL;
@property (strong, nonatomic) NSString *METHOD_NAME_SYNC_TO_CLIENT;
@property (strong, nonatomic) NSString *SOAP_ACTION_SYNC_TO_CLIENT;
@property (strong, nonatomic) NSString *METHOD_NAME_SYNC_TO_SERVER;
@property (strong, nonatomic) NSString *SOAP_ACTION_SYNC_TO_SERVER;
@property (strong, nonatomic) NSString *tables;
@property (strong, nonatomic) NSString *separator;
@property (strong, nonatomic) NSString *ipDatabase;
@property (strong, nonatomic) NSString *userDatabase;
@property (strong, nonatomic) NSString *passwordDatabase;
@property (strong, nonatomic) NSString *catalogDatabase;
@property (strong, nonatomic) NSString *queriesDatabase;
@property (strong, nonatomic) NSString *clientKey;
@property (strong, nonatomic) NSMutableArray *ndb;
@property (readonly) int statusConnection;
@property (atomic) BOOL syncFinished;
@property (atomic) int syncStatus;

- (instancetype) init;
- (int) getStatusConnection;
- (void) dealloc;
- (bool) isFirstSync;
- (void) Synchronize;
- (void) SynchronizePartial;
- (void) SynchronizeByKey;
- (void) saveInQueue:(NSString *)sql;
- (int) ExecuteNonQuery:(NSString *)sql;
- (NSMutableArray *) ExecuteSelect:(NSString *)sql;
- (void) ApplyChanges;
- (void) ApplyChanges:(NSInteger *)n;
- (void) clearQueue;

@end