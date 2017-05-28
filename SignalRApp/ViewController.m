//
//  ViewController.m
//  SignalRApp
//
//  Created by DESAROLLO on 03/02/16.
//  Copyright © 2016 GTM-DESAROLLO. All rights reserved.
//

#import "ViewController.h"
#import "SignalR.h"
#import "AT5Pulsos.h"
#import "Operation.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize txt;
@synthesize in01;
@synthesize in02;
@synthesize in03;
@synthesize in04;
@synthesize in05;
@synthesize in06;
@synthesize in07;
@synthesize in08;
@synthesize in09;
@synthesize in10;
@synthesize in11;
@synthesize in12;
@synthesize in13;
@synthesize in14;
@synthesize in15;
@synthesize in16;
@synthesize in17;
@synthesize in18;
@synthesize in19;
@synthesize in20;
@synthesize in21;
@synthesize in22;
@synthesize in23;
@synthesize in24;
@synthesize out01;
@synthesize out02;
@synthesize out03;
@synthesize out04;
@synthesize out05;
@synthesize out06;
@synthesize out07;
@synthesize out08;
@synthesize out09;
@synthesize out10;
@synthesize out11;
@synthesize out12;

- (void)viewDidLoad {
    [super viewDidLoad];
    alert = [[UIAlertView alloc] initWithTitle:@"Cargando..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [alert show];
    // Do any additional setup after loading the view, typically from a nib.
    txt.text = @"";
    imei = nil;
    sync = [[Synchronization alloc] init];
    [sync setSeparator:@";"];
    [sync setUserDatabase:@"sa"];
    [sync setURL:@"http://star911.com.mx/DBSync/DatabaseSync.svc?wsdl"];
    [sync setTables:@"Pulsos"];
    [sync setSOAP_ACTION_SYNC_TO_SERVER:@"http://star911.com.mx/DBSync/IDatabaseSync/ExecuteQuery"];
    [sync setSOAP_ACTION_SYNC_TO_CLIENT:@"http://star911.com.mx/DBSync/IDatabaseSync/SyncMSSQLServerToSQLite"];
    [sync setPasswordDatabase:@"gTMp911sTAR"];
    [sync setNAMESPACE:@"http://star911.com.mx/DBSync/"];
    [sync setMETHOD_NAME_SYNC_TO_SERVER:@"ExecuteQuery"];
    [sync setMETHOD_NAME_SYNC_TO_CLIENT:@"SyncMSSQLServerToSQLite"];
    [sync setIpDatabase:@"187.253.132.139"];
    [sync setCatalogDatabase:@"AT5_IO"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString *host = @"http://www.star911.com.mx/IOProject";
    hubConnection = [SRHubConnection connectionWithURLString:host];
    hubProxy = [hubConnection createHubProxy:@"at5"];
    [hubConnection setStarted:^{
        [hubProxy on:@"updatePulsos" perform:self selector:@selector(updatePulsos:)];
        txt.text = @"ESTADO DE CONEXIÓN: ->> Conexión Establecida.";
        NSLog(@"ESTADO DE CONEXIÓN: ->> Conexión Establecida.");
        if ([sync getStatusConnection] == Operation.CONNECTION_STATUS_WIFI_OK || [sync getStatusConnection] == Operation.CONNECTION_STATUS_MOBILE_OK) {
            [sync Synchronize];
            NSMutableArray *data = [sync ExecuteSelect:@"SELECT Imei, IN01, IN02, IN03, IN04, IN05, IN06, IN07, IN08, IN09, IN10, IN11, IN12, IN13, IN14, IN15, IN16, IN17, IN18, IN19, IN20, IN21, IN22, IN23, IN24, OUT01, OUT02, OUT03, OUT04, OUT05, OUT06, OUT07, OUT08, OUT09, OUT10, OUT11, OUT12 FROM Pulsos"];
            if (data != nil) {
                if (data.count > 0) {
                    imei = [[data objectAtIndex:0] objectAtIndex:0];
                    [self changeState:in01 :[[[data objectAtIndex:0] objectAtIndex:1] boolValue]];
                    [self changeState:in02 :[[[data objectAtIndex:0] objectAtIndex:2] boolValue]];
                    [self changeState:in03 :[[[data objectAtIndex:0] objectAtIndex:3] boolValue]];
                    [self changeState:in04 :[[[data objectAtIndex:0] objectAtIndex:4] boolValue]];
                    [self changeState:in05 :[[[data objectAtIndex:0] objectAtIndex:5] boolValue]];
                    [self changeState:in06 :[[[data objectAtIndex:0] objectAtIndex:6] boolValue]];
                    [self changeState:in07 :[[[data objectAtIndex:0] objectAtIndex:7] boolValue]];
                    [self changeState:in08 :[[[data objectAtIndex:0] objectAtIndex:8] boolValue]];
                    [self changeState:in09 :[[[data objectAtIndex:0] objectAtIndex:9] boolValue]];
                    [self changeState:in10 :[[[data objectAtIndex:0] objectAtIndex:10] boolValue]];
                    [self changeState:in11 :[[[data objectAtIndex:0] objectAtIndex:11] boolValue]];
                    [self changeState:in12 :[[[data objectAtIndex:0] objectAtIndex:12] boolValue]];
                    [self changeState:in13 :[[[data objectAtIndex:0] objectAtIndex:13] boolValue]];
                    [self changeState:in14 :[[[data objectAtIndex:0] objectAtIndex:14] boolValue]];
                    [self changeState:in15 :[[[data objectAtIndex:0] objectAtIndex:15] boolValue]];
                    [self changeState:in16 :[[[data objectAtIndex:0] objectAtIndex:16] boolValue]];
                    [self changeState:in17 :[[[data objectAtIndex:0] objectAtIndex:17] boolValue]];
                    [self changeState:in18 :[[[data objectAtIndex:0] objectAtIndex:18] boolValue]];
                    [self changeState:in19 :[[[data objectAtIndex:0] objectAtIndex:19] boolValue]];
                    [self changeState:in20 :[[[data objectAtIndex:0] objectAtIndex:20] boolValue]];
                    [self changeState:in21 :[[[data objectAtIndex:0] objectAtIndex:21] boolValue]];
                    [self changeState:in22 :[[[data objectAtIndex:0] objectAtIndex:22] boolValue]];
                    [self changeState:in23 :[[[data objectAtIndex:0] objectAtIndex:23] boolValue]];
                    [self changeState:in24 :[[[data objectAtIndex:0] objectAtIndex:24] boolValue]];
                    [self changeState:out01 :[[[data objectAtIndex:0] objectAtIndex:25] boolValue]];
                    [self changeState:out02 :[[[data objectAtIndex:0] objectAtIndex:26] boolValue]];
                    [self changeState:out03 :[[[data objectAtIndex:0] objectAtIndex:27] boolValue]];
                    [self changeState:out04 :[[[data objectAtIndex:0] objectAtIndex:28] boolValue]];
                    [self changeState:out05 :[[[data objectAtIndex:0] objectAtIndex:29] boolValue]];
                    [self changeState:out06 :[[[data objectAtIndex:0] objectAtIndex:30] boolValue]];
                    [self changeState:out07 :[[[data objectAtIndex:0] objectAtIndex:31] boolValue]];
                    [self changeState:out08 :[[[data objectAtIndex:0] objectAtIndex:32] boolValue]];
                    [self changeState:out09 :[[[data objectAtIndex:0] objectAtIndex:33] boolValue]];
                    [self changeState:out10 :[[[data objectAtIndex:0] objectAtIndex:34] boolValue]];
                    [self changeState:out11 :[[[data objectAtIndex:0] objectAtIndex:35] boolValue]];
                    [self changeState:out12 :[[[data objectAtIndex:0] objectAtIndex:36] boolValue]];
                }
            }
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        }
        sync.syncFinished = YES;
    }];
    [hubConnection setReceived:^(NSString *message) {
        txt.text = [NSString stringWithFormat:@"ESTADO DE CONEXIÓN: ->> Datos Recibidos (%@).", message];
        NSLog(@"ESTADO DE CONEXIÓN: ->> Datos Recibidos (%@).", message);
    }];
    [hubConnection setConnectionSlow:^{
        txt.text = @"ESTADO DE CONEXIÓN: ->> Conexión Lenta.";
        NSLog(@"ESTADO DE CONEXIÓN: ->> Conexión Lenta.");
    }];
    [hubConnection setReconnecting:^{
        txt.text = @"ESTADO DE CONEXIÓN: ->> Intentando Reestablecer la Conexión.";
        NSLog(@"ESTADO DE CONEXIÓN: ->> Intentando Reestablecer la Conexión.");
    }];
    [hubConnection setReconnected:^{
        txt.text = @"ESTADO DE CONEXIÓN: ->> Conexión Reestablecida.";
        NSLog(@"ESTADO DE CONEXIÓN: ->> Conexión Reestablecida.");
    }];
    [hubConnection setClosed:^{
        txt.text = @"ESTADO DE CONEXIÓN: ->> Conexión Cerrada.";
        NSLog(@"ESTADO DE CONEXIÓN: ->> Conexión Cerrada.");
    }];
    [hubConnection setError:^(NSError *error) {
        txt.text = [NSString stringWithFormat:@"ESTADO DE CONEXIÓN: ->> Error de Conexión (%@).", error];
        NSLog(@"ESTADO DE CONEXIÓN: ->> Error de Conexión (%@).",error);
    }];
    // Start the connection
    [hubConnection start];
}

- (void)viewDidDisappear:(BOOL)animated {
    [hubConnection stop];
    //[hubConnection disconnect];
    hubProxy = nil;
    hubConnection = nil;
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updatePulsos:(id)message {
    NSData *jsonData = [[NSString stringWithFormat:@"%@", message] dataUsingEncoding:NSUTF8StringEncoding];
    //NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    AT5Pulsos *pulso = nil;
    NSMutableArray *pulsosElements = [[NSMutableArray alloc] init];
    NSArray *pulsos = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&e];
    if ([pulsos isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dictionary in pulsos) {
            pulso = [[AT5Pulsos alloc] init];
            pulso.Imei = [dictionary objectForKey:@"Imei"];
            pulso.FechaHora = [dictionary objectForKey:@"FechaHora"];
            pulso.FechaHoraTransmision = [dictionary objectForKey:@"FechaHoraTransmision"];
            pulso.Latitud = [[dictionary objectForKey:@"Latitud"] doubleValue];
            pulso.Longitud = [[dictionary objectForKey:@"Longitud"] doubleValue];
            pulso.IN01 = [[dictionary objectForKey:@"IN01"] boolValue];
            pulso.IN02 = [[dictionary objectForKey:@"IN02"] boolValue];
            pulso.IN03 = [[dictionary objectForKey:@"IN03"] boolValue];
            pulso.IN04 = [[dictionary objectForKey:@"IN04"] boolValue];
            pulso.IN05 = [[dictionary objectForKey:@"IN05"] boolValue];
            pulso.IN06 = [[dictionary objectForKey:@"IN06"] boolValue];
            pulso.IN07 = [[dictionary objectForKey:@"IN07"] boolValue];
            pulso.IN08 = [[dictionary objectForKey:@"IN08"] boolValue];
            pulso.IN09 = [[dictionary objectForKey:@"IN09"] boolValue];
            pulso.IN10 = [[dictionary objectForKey:@"IN10"] boolValue];
            pulso.IN11 = [[dictionary objectForKey:@"IN11"] boolValue];
            pulso.IN12 = [[dictionary objectForKey:@"IN12"] boolValue];
            pulso.IN13 = [[dictionary objectForKey:@"IN13"] boolValue];
            pulso.IN14 = [[dictionary objectForKey:@"IN14"] boolValue];
            pulso.IN15 = [[dictionary objectForKey:@"IN15"] boolValue];
            pulso.IN16 = [[dictionary objectForKey:@"IN16"] boolValue];
            pulso.IN17 = [[dictionary objectForKey:@"IN17"] boolValue];
            pulso.IN18 = [[dictionary objectForKey:@"IN18"] boolValue];
            pulso.IN19 = [[dictionary objectForKey:@"IN19"] boolValue];
            pulso.IN20 = [[dictionary objectForKey:@"IN20"] boolValue];
            pulso.IN21 = [[dictionary objectForKey:@"IN21"] boolValue];
            pulso.IN22 = [[dictionary objectForKey:@"IN22"] boolValue];
            pulso.IN23 = [[dictionary objectForKey:@"IN23"] boolValue];
            pulso.IN24 = [[dictionary objectForKey:@"IN24"] boolValue];
            pulso.OUT01 = [[dictionary objectForKey:@"OUT01"] boolValue];
            pulso.OUT02 = [[dictionary objectForKey:@"OUT02"] boolValue];
            pulso.OUT03 = [[dictionary objectForKey:@"OUT03"] boolValue];
            pulso.OUT04 = [[dictionary objectForKey:@"OUT04"] boolValue];
            pulso.OUT05 = [[dictionary objectForKey:@"OUT05"] boolValue];
            pulso.OUT06 = [[dictionary objectForKey:@"OUT06"] boolValue];
            pulso.OUT07 = [[dictionary objectForKey:@"OUT07"] boolValue];
            pulso.OUT08 = [[dictionary objectForKey:@"OUT08"] boolValue];
            pulso.OUT09 = [[dictionary objectForKey:@"OUT09"] boolValue];
            pulso.OUT10 = [[dictionary objectForKey:@"OUT10"] boolValue];
            pulso.OUT11 = [[dictionary objectForKey:@"OUT11"] boolValue];
            pulso.OUT12 = [[dictionary objectForKey:@"OUT12"] boolValue];
            [pulsosElements addObject:pulso];
        }
    }
    pulso = nil;
    if (pulsosElements != nil) {
        if (pulsosElements.count > 0) {
            pulso = (AT5Pulsos *)[pulsosElements objectAtIndex:0];
            if (pulso != nil) {
                imei = [NSString stringWithFormat:@"%@", pulso.Imei];
                [self changeState:in01 :pulso.IN01];
                [self changeState:in02 :pulso.IN02];
                [self changeState:in03 :pulso.IN03];
                [self changeState:in04 :pulso.IN04];
                [self changeState:in05 :pulso.IN05];
                [self changeState:in06 :pulso.IN06];
                [self changeState:in07 :pulso.IN07];
                [self changeState:in08 :pulso.IN08];
                [self changeState:in09 :pulso.IN09];
                [self changeState:in10 :pulso.IN10];
                [self changeState:in11 :pulso.IN11];
                [self changeState:in12 :pulso.IN12];
                [self changeState:in13 :pulso.IN13];
                [self changeState:in14 :pulso.IN14];
                [self changeState:in15 :pulso.IN15];
                [self changeState:in16 :pulso.IN16];
                [self changeState:in17 :pulso.IN17];
                [self changeState:in18 :pulso.IN18];
                [self changeState:in19 :pulso.IN19];
                [self changeState:in20 :pulso.IN20];
                [self changeState:in21 :pulso.IN21];
                [self changeState:in22 :pulso.IN22];
                [self changeState:in23 :pulso.IN23];
                [self changeState:in24 :pulso.IN24];
                [self changeState:out01 :pulso.OUT01];
                [self changeState:out02 :pulso.OUT02];
                [self changeState:out03 :pulso.OUT03];
                [self changeState:out04 :pulso.OUT04];
                [self changeState:out05 :pulso.OUT05];
                [self changeState:out06 :pulso.OUT06];
                [self changeState:out07 :pulso.OUT07];
                [self changeState:out08 :pulso.OUT08];
                [self changeState:out09 :pulso.OUT09];
                [self changeState:out10 :pulso.OUT10];
                [self changeState:out11 :pulso.OUT11];
                [self changeState:out12 :pulso.OUT12];
            }
        }
    }
}

- (IBAction)AplicarCambiosEvent:(id)sender {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [sync ExecuteNonQuery:[NSString stringWithFormat:@"UPDATE Pulsos SET IN01 = %d, IN02 = %d, IN03 = %d, IN04 = %d, IN05 = %d, IN06 = %d, IN07 = %d, IN08 = %d, IN09 = %d, IN10 = %d, IN11 = %d, IN12 = %d, IN13 = %d, IN14 = %d, IN15 = %d, IN16 = %d, IN17 = %d, IN18 = %d, IN19 = %d, IN20 = %d, IN21 = %d, IN22 = %d, IN23 = %d, IN24 = %d, OUT01 = %d, OUT02 = %d, OUT03 = %d, OUT04 = %d, OUT05 = %d, OUT06 = %d, OUT07 = %d, OUT08 = %d, OUT09 = %d, OUT10 = %d, OUT11 = %d, OUT12 = %d, FechaHora = '%@' WHERE Imei = %@", ((int)[in01 isOn]), ((int)[in02 isOn]), ((int)[in03 isOn]), ((int)[in04 isOn]), ((int)[in05 isOn]), ((int)[in06 isOn]), ((int)[in07 isOn]), ((int)[in08 isOn]), ((int)[in09 isOn]), ((int)[in10 isOn]), ((int)[in11 isOn]), ((int)[in12 isOn]), ((int)[in13 isOn]), ((int)[in14 isOn]), ((int)[in15 isOn]), ((int)[in16 isOn]), ((int)[in17 isOn]), ((int)[in18 isOn]), ((int)[in19 isOn]), ((int)[in20 isOn]), ((int)[in21 isOn]), ((int)[in22 isOn]), ((int)[in23 isOn]), ((int)[in24 isOn]), ((int)[out01 isOn]), ((int)[out02 isOn]), ((int)[out03 isOn]), ((int)[out04 isOn]), ((int)[out05 isOn]), ((int)[out06 isOn]), ((int)[out07 isOn]), ((int)[out08 isOn]), ((int)[out09 isOn]), ((int)[out10 isOn]), ((int)[out11 isOn]), ((int)[out12 isOn]), [dateFormatter stringFromDate:[NSDate date]], imei]];
    [sync ApplyChanges];
    [sync clearQueue];
}

- (void) changeState:(UISwitch *)sender :(BOOL)value {
    [sender setOn:value animated:YES];
}

@end
