//
//  Operation.m
//  SQL
//
//  Created by DESAROLLO on 30/04/15.
//  Copyright (c) 2015 GTM-DESAROLLO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Operation.h"

@implementation Operation

static int Sync_MSSQLServer_To_SQLite = 0;
static int Sync_SQLite_To_MSSQLServer = 1;
static int CONNECTION_STATUS_WIFI_OK = 1;
static int CONNECTION_STATUS_MOBILE_OK = 2;
static int CONNECTION_STATUS_DISABLED = -1;
static int CONNECTION_STATUS_ERROR_EXCEPTION = -2;

+ (int) Sync_MSSQLServer_To_SQLite
{
    return Sync_MSSQLServer_To_SQLite;
}

+ (int) Sync_SQLite_To_MSSQLServer
{
    return Sync_SQLite_To_MSSQLServer;
}

+ (int) CONNECTION_STATUS_WIFI_OK
{
    return CONNECTION_STATUS_WIFI_OK;
}

+ (int) CONNECTION_STATUS_MOBILE_OK
{
    return CONNECTION_STATUS_MOBILE_OK;
}

+ (int) CONNECTION_STATUS_DISABLED
{
    return CONNECTION_STATUS_DISABLED;
}

+ (int) CONNECTION_STATUS_ERROR_EXCEPTION
{
    return CONNECTION_STATUS_ERROR_EXCEPTION;
}

@end
