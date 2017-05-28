//
//  ViewController.h
//  SignalRApp
//
//  Created by DESAROLLO on 03/02/16.
//  Copyright © 2016 GTM-DESAROLLO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignalR.h"
#import "Synchronization.h"

@interface ViewController : UIViewController
{
    SRHubConnection *hubConnection;
    SRHubProxy *hubProxy;
    Synchronization *sync;
    UIAlertView *alert;
    NSString *imei;
}

@property (strong, atomic) IBOutlet UILabel *txt;
@property (strong, nonatomic) IBOutlet UISwitch *in01;
@property (strong, nonatomic) IBOutlet UISwitch *in02;
@property (strong, nonatomic) IBOutlet UISwitch *in03;
@property (strong, nonatomic) IBOutlet UISwitch *in04;
@property (strong, nonatomic) IBOutlet UISwitch *in05;
@property (strong, nonatomic) IBOutlet UISwitch *in06;
@property (strong, nonatomic) IBOutlet UISwitch *in07;
@property (strong, nonatomic) IBOutlet UISwitch *in08;
@property (strong, nonatomic) IBOutlet UISwitch *in09;
@property (strong, nonatomic) IBOutlet UISwitch *in10;
@property (strong, nonatomic) IBOutlet UISwitch *in11;
@property (strong, nonatomic) IBOutlet UISwitch *in12;
@property (strong, nonatomic) IBOutlet UISwitch *in13;
@property (strong, nonatomic) IBOutlet UISwitch *in14;
@property (strong, nonatomic) IBOutlet UISwitch *in15;
@property (strong, nonatomic) IBOutlet UISwitch *in16;
@property (strong, nonatomic) IBOutlet UISwitch *in17;
@property (strong, nonatomic) IBOutlet UISwitch *in18;
@property (strong, nonatomic) IBOutlet UISwitch *in19;
@property (strong, nonatomic) IBOutlet UISwitch *in20;
@property (strong, nonatomic) IBOutlet UISwitch *in21;
@property (strong, nonatomic) IBOutlet UISwitch *in22;
@property (strong, nonatomic) IBOutlet UISwitch *in23;
@property (strong, nonatomic) IBOutlet UISwitch *in24;
@property (strong, nonatomic) IBOutlet UISwitch *out01;
@property (strong, nonatomic) IBOutlet UISwitch *out02;
@property (strong, nonatomic) IBOutlet UISwitch *out03;
@property (strong, nonatomic) IBOutlet UISwitch *out04;
@property (strong, nonatomic) IBOutlet UISwitch *out05;
@property (strong, nonatomic) IBOutlet UISwitch *out06;
@property (strong, nonatomic) IBOutlet UISwitch *out07;
@property (strong, nonatomic) IBOutlet UISwitch *out08;
@property (strong, nonatomic) IBOutlet UISwitch *out09;
@property (strong, nonatomic) IBOutlet UISwitch *out10;
@property (strong, nonatomic) IBOutlet UISwitch *out11;
@property (strong, nonatomic) IBOutlet UISwitch *out12;

- (void)changeState:(UISwitch *)sender :(BOOL)value;
- (IBAction)AplicarCambiosEvent:(id)sender;

@end

