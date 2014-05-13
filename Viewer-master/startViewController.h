//
//  startViewController.h
//  testapp
//
//  Created by Georgiy on 17.04.14.
//  Copyright (c) 2014 Georgiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "vkLoginViewController.h"
#import "sendViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LibraryViewController.h"

@class vkLoginViewController;
@class sendViewController;
@class LibraryViewController;

@interface startViewController : UIViewController
- (IBAction)vkButtonAct:(id)sender;
- (IBAction)fbButtonAct:(id)sender;
- (IBAction)CountButtonAct:(id)sender;
- (IBAction)libButtonAct:(id)sender;

@property(strong,nonatomic)vkLoginViewController *VkLoginViewController;
@property sendViewController * SendViewController;
@property LibraryViewController *libraryViewController;
@end
