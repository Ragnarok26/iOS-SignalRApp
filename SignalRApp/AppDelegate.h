//
//  AppDelegate.h
//  SignalRApp
//
//  Created by DESAROLLO on 03/02/16.
//  Copyright © 2016 GTM-DESAROLLO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Synchronization.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, atomic) Synchronization *sync;

@end

