//
//  WebService.h
//  SQL
//
//  Created by DESAROLLO on 01/05/15.
//  Copyright (c) 2015 GTM-DESAROLLO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebService : NSObject

@property (strong, nonatomic) NSString *tables;
@property (strong, nonatomic) NSString *separator;
@property (strong, nonatomic) NSString *ipDatabase;
@property (strong, nonatomic) NSString *userDatabase;
@property (strong, nonatomic) NSString *passwordDatabase;
@property (strong, nonatomic) NSString *catalogDatabase;
@property (strong, nonatomic) NSString *queriesDatabase;
@property (strong, nonatomic) NSString *clientKey;
@property (strong, nonatomic) NSString *cadena;
@property NSString *Name;
@property NSString *Url;
@property NSString *Method;
@property NSString *Soap;
@property int op;
@property int type;
@property (nonatomic, strong) NSMutableDictionary *dictData;
@property (nonatomic,strong) NSMutableArray *marrXMLData;
@property (nonatomic,strong) NSMutableString *mstrXMLString;
@property (nonatomic,strong) NSMutableDictionary *mdictXMLPart;

- (instancetype) init:(NSString *)Name :(NSString *)Url : (NSString *)Method :(NSString *)Soap :(int)op;

- (NSString *) getResponse:(NSString *)soapMessage;

- (void) setDatos:(NSString *)ipDataBase :(NSString *)userDataBase :(NSString *)passwordDataBase :(NSString *)catalogDataBase :(NSString *)tablesDataBase :(NSString *)separatorDataBase :(NSString *)queriesDataBase;

- (void) setDatos:(NSString *)clientKey :(NSString *)ipDataBase :(NSString *)userDataBase :(NSString *)passwordDataBase :(NSString *)catalogDataBase :(NSString *)tablesDataBase :(NSString *)separatorDataBase :(NSString *)queriesDataBase;

- (void) setDatos:(NSString *)ipDataBase :(NSString *)userDataBase :(NSString *)passwordDataBase :(NSString *)catalogDataBase :(NSString *)tablesDataBase :(NSString *)separatorDataBase;

- (void) setDatos:(NSString *)ipDataBase :(NSString *)userDataBase :(NSString *)passwordDataBase :(NSString *)catalogDataBase :(NSString *)query;

- (NSString *)request;

@end
