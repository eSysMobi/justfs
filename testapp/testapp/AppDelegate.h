//
//  AppDelegate.h
//  testapp
//
//  Created by Georgiy on 17.04.14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "sendViewController.h"
@class sendViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong,nonatomic) sendViewController *SendViewController;
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic) int flag;
@property(nonatomic) int flagLeng;
@property(nonatomic) int flagmass;
@property (strong, nonatomic) FBSession *session;
- (FBRequest*)requestWithGraphPath:(NSString *)graphPath
                         andParams:(NSMutableDictionary *)params
                     andHttpMethod:(NSString *)httpMethod
                       andDelegate:(id <FBRequestDelegate>)delegate;
@end
