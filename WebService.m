//
//  WebService.m
//  SQL
//
//  Created by DESAROLLO on 01/05/15.
//  Copyright (c) 2015 GTM-DESAROLLO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebService.h"
#import "Operation.h"

@implementation WebService : NSObject

@synthesize marrXMLData;
@synthesize mstrXMLString;
@synthesize mdictXMLPart;

- (instancetype) init:(NSString *)Name :(NSString *)Url : (NSString *)Method :(NSString *)Soap :(int)op {
    if (self = [super init]) {
        self.Name = Name;
        self.Url = Url;
        self.Method = Method;
        self.Soap = Soap;
        self.op = op;
        self.type = 0;
    }
    return self;
}

- (void) setDatos:(NSString *)ipDataBase :(NSString *)userDataBase :(NSString *)passwordDataBase :(NSString *)catalogDataBase :(NSString *)tablesDataBase :(NSString *)separatorDataBase :(NSString *)queriesDataBase {
    self.ipDatabase = ipDataBase;
    self.userDatabase = userDataBase;
    self.passwordDatabase = passwordDataBase;
    self.catalogDatabase = catalogDataBase;
    self.tables = tablesDataBase;
    self.separator = separatorDataBase;
    self.queriesDatabase = queriesDataBase;
    self.type = 4;
}

- (void) setDatos:(NSString *)clientKey :(NSString *)ipDataBase :(NSString *)userDataBase :(NSString *)passwordDataBase :(NSString *)catalogDataBase :(NSString *)tablesDataBase :(NSString *)separatorDataBase :(NSString *)queriesDataBase {
    self.clientKey = clientKey;
    self.ipDatabase = ipDataBase;
    self.userDatabase = userDataBase;
    self.passwordDatabase = passwordDataBase;
    self.catalogDatabase = catalogDataBase;
    self.tables = tablesDataBase;
    self.separator = separatorDataBase;
    self.queriesDatabase = queriesDataBase;
    self.type = 3;
}

- (void) setDatos:(NSString *)ipDataBase :(NSString *)userDataBase :(NSString *)passwordDataBase :(NSString *)catalogDataBase :(NSString *)tablesDataBase :(NSString *)separatorDataBase {
    self.ipDatabase = ipDataBase;
    self.userDatabase = userDataBase;
    self.passwordDatabase = passwordDataBase;
    self.catalogDatabase = catalogDataBase;
    self.tables = tablesDataBase;
    self.separator = separatorDataBase;
    self.type = 2;
}

- (void) setDatos:(NSString *)ipDataBase :(NSString *)userDataBase :(NSString *)passwordDataBase :(NSString *)catalogDataBase :(NSString *)query {
    self.ipDatabase = ipDataBase;
    self.userDatabase = userDataBase;
    self.passwordDatabase = passwordDataBase;
    self.catalogDatabase = catalogDataBase;
    self.cadena = query;
    self.type = 1;
    self.op = 1;
}

- (NSString *)request {
    bool flag;
    NSString *res = @"";
    NSString *params = @"<%@>%@</%@>%@";
    NSString *soapMessage = @"<%@ xmlns=\"%@\">%@</%@>";
    if (self.op == Operation.Sync_MSSQLServer_To_SQLite) {
        flag = YES;
        res = [NSString stringWithFormat:params, @"ipDataBase", _ipDatabase, @"ipDataBase", params];
        res = [NSString stringWithFormat:res, @"userDataBase", _userDatabase, @"userDataBase", params];
        res = [NSString stringWithFormat:res, @"passwordDataBase", _passwordDatabase, @"passwordDataBase", params];
        res = [NSString stringWithFormat:res, @"catalogDataBase", _catalogDatabase, @"catalogDataBase", params];
        res = [NSString stringWithFormat:res, @"tables", _tables, @"tables", params];
        res = [NSString stringWithFormat:res, @"separator", _separator, @"separator", @"%@"];
        if (_type == 3 || _type == 4) {
            res = [NSString stringWithFormat:res, params];
            if (_type == 3) {
                res = [NSString stringWithFormat:res, @"key", _clientKey, @"key", params];
            }
            res = [NSString stringWithFormat:res, @"queries", _queriesDatabase, @"queries", @""];
        }
        else {
            res = [NSString stringWithFormat:res, @""];
        }
        soapMessage = [NSString stringWithFormat:soapMessage, _Method, _Name, res, _Method];
        res = @"";
        soapMessage = [NSString stringWithFormat:
                                 @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                                 "<SOAP-ENV:Envelope \n"
                                 "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" \n"
                                 "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \n"
                                 "xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" \n"
                                 "SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" \n"
                                 "xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"> \n"
                                 "<SOAP-ENV:Body> \n"
                                 "%@ \n"
                                 "</SOAP-ENV:Body> \n"
                                 "</SOAP-ENV:Envelope>", soapMessage];
    }
    else if (self.op == Operation.Sync_SQLite_To_MSSQLServer) {
        flag = YES;
        res = [NSString stringWithFormat:params, @"ipDataBase", _ipDatabase, @"ipDataBase", params];
        res = [NSString stringWithFormat:res, @"userDataBase", _userDatabase, @"userDataBase", params];
        res = [NSString stringWithFormat:res, @"passwordDataBase", _passwordDatabase, @"passwordDataBase", params];
        res = [NSString stringWithFormat:res, @"catalogDataBase", _catalogDatabase, @"catalogDataBase", params];
        res = [NSString stringWithFormat:res, @"queryArray", _cadena, @"queryArray", @""];
        soapMessage = [NSString stringWithFormat:soapMessage, _Method, _Name, res, _Method];
        res = @"";
        soapMessage = [NSString stringWithFormat:
                       @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                       "<SOAP-ENV:Envelope \n"
                       "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" \n"
                       "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \n"
                       "xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" \n"
                       "SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" \n"
                       "xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"> \n"
                       "<SOAP-ENV:Body> \n"
                       "%@ \n"
                       "</SOAP-ENV:Body> \n"
                       "</SOAP-ENV:Envelope>", soapMessage];
    }
    else {
        flag = NO;
    }
    if (flag) {
        @try {
            res = [self getResponse:soapMessage];
        }
        @catch (NSException *ex) {
            res = @"E1";
        }
    }
    return res;
}

- (NSString *) getResponse:(NSString *)soapMessage {
    //Web Service Call
    NSURL *url = [NSURL URLWithString:_Url];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: _Soap forHTTPHeaderField:@"Soapaction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];     
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLResponse *respon;
    NSError *error;
    NSMutableData *webData = ((NSMutableData *)[NSURLConnection sendSynchronousRequest:((NSURLRequest *)theRequest) returningResponse:&respon error:&error]);
    NSString *response;
    if (!error) {
        NSXMLParser *xml = [[NSXMLParser alloc] initWithData:((NSData *)webData)];
        xml.delegate = self;
        if (![xml parse]) {
            response = @"";
        }
        else {
            response = [mdictXMLPart valueForKey:[NSString stringWithFormat:@"%@Result", _Method]];
            response = [[response stringByReplacingOccurrencesOfString:@"True" withString:@"1"] stringByReplacingOccurrencesOfString:@"False" withString:@"0"];
        }
    }
    else {
        response = @"";
    }
    return response;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString     *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"s:Envelope"]) {
        marrXMLData = [[NSMutableArray alloc] init];
    }
    if ([elementName isEqualToString:@"s:Body"]) {
        mdictXMLPart = [[NSMutableDictionary alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!mstrXMLString) {
        mstrXMLString = [[NSMutableString alloc] initWithString:string];
    }
    else {
        [mstrXMLString appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:[NSString stringWithFormat:@"%@Result", _Method]]) {
        [mdictXMLPart setObject:mstrXMLString forKey:elementName];
    }
    if ([elementName isEqualToString:@"s:Body"]) {
        [marrXMLData addObject:mdictXMLPart];
    }
    mstrXMLString = nil;
}

@end