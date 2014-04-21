//
//  startViewController.h
//  testapp
//
//  Created by Georgiy on 17.04.14.
//  Copyright (c) 2014 Georgiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "vkLoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
@class vkLoginViewController;

@interface startViewController : UIViewController
- (IBAction)vkButtonAct:(id)sender;
- (IBAction)fbButtonAct:(id)sender;
@property(strong,nonatomic)vkLoginViewController *VkLoginViewController;
@end
