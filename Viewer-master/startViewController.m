//
//  startViewController.m
//  testapp
//
//  Created by Georgiy on 17.04.14.
//  Copyright (c) 2014 Georgiy. All rights reserved.
//

#import "startViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LibraryViewController.h"
#import "ReaderConstants.h"
#import "LibraryViewController.h"
#import "LibraryDirectoryView.h"
#import "LibraryDocumentsView.h"
#import "ReaderViewController.h"
#import "ReaderThumbCache.h"
#import "CoreDataManager.h"
#import "DocumentsUpdate.h"
#import "DocumentFolder.h"
#import "ReaderDocument.h"
#import "CGPDFDocument.h"

@interface startViewController () <FBLoginViewDelegate>

@end

@implementation startViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 285);
    loginView.delegate=self ;
    [self.view addSubview:loginView];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)vkButtonAct:(id)sender {
    self.VkLoginViewController = [[vkLoginViewController alloc] initWithNibName:@"vkLoginViewController" bundle:Nil];
    [self.navigationController pushViewController:self.VkLoginViewController animated:YES];
}

- (IBAction)fbButtonAct:(id)sender{
//FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"basic_info", @"email", @"user_likes"]];
//    
//    [self.view addSubview:loginView];
}

- (IBAction)CountButtonAct:(id)sender {
    self.SendViewController =[[sendViewController alloc] initWithNibName:@"sendViewController" bundle:nil];
    [self.navigationController pushViewController:self.SendViewController animated:YES];
}

- (IBAction)libButtonAct:(id)sender {
    self.libraryViewController =[[LibraryViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:self.libraryViewController animated:YES];}


//- (IBAction)LibButtonAct:(UIButton *)sender {
//    self.libraryViewController =[[LibraryViewController alloc] initWithNibName:@"LibraryViewController" bundle:nil];
//    [self.navigationController pushViewController:self.libraryViewController animated:YES];}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
