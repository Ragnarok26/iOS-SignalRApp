//
//  Operation.h
//  SQL
//
//  Created by DESAROLLO on 30/04/15.
//  Copyright (c) 2015 GTM-DESAROLLO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Operation : NSObject

+ (int) Sync_MSSQLServer_To_SQLite;
+ (int) Sync_SQLite_To_MSSQLServer;
+ (int) CONNECTION_STATUS_WIFI_OK;
+ (int) CONNECTION_STATUS_MOBILE_OK;
+ (int) CONNECTION_STATUS_DISABLED;
+ (int) CONNECTION_STATUS_ERROR_EXCEPTION;

@end

