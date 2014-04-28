//
//  sendViewController.m
//  testapp
//
//  Created by Georgiy on 21.04.14.
//  Copyright (c) 2014 Georgiy. All rights reserved.
//

#import "sendViewController.h"

@interface sendViewController ()

@end

@implementation sendViewController

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
    //отсылка файла
    
//    NSString *strUrl=@"http://www.site.com/upload.php";
//    NSLog(@"%@",strUrl);
//    NSURL *url=[NSURL URLWithString:strUrl];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest  requestWithURL:url
//                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                        timeoutInterval:130.0];
//    
//    // file name of user picture
//    // I am sending a image to server
//    NSString *fileName=[[eMailTxtField.text stringByReplacingOccurrencesOfString:@"@" withString:@"-"]  stringByAppendingString:@".jpg"];
//    //image data
//    UIImage *userImage=imgUser.image;
//    NSData *imageData =UIImageJPEGRepresentation(userImage, 90);
//    
//    NSMutableData *myRequestData = [[NSMutableData alloc] init];
//    [myRequestData appendData:[NSData dataWithBytes:[postData UTF8String] length:[postData length]]];
//    
//    
//    NSString *boundary = [NSString stringWithString:@"--"];
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//    [myRequestData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [myRequestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadfile\"; filename=\"%@\"\r\n", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
//    [myRequestData appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [myRequestData appendData:[NSData dataWithData:imageData]];
//    [myRequestData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [ request setHTTPMethod: @"POST" ];
//    
//    [ request setHTTPBody: myRequestData ];
//    NSURLResponse *response;
//    NSError *error;
//    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&error];
//    if (!error && returnData) {
//        NSString *content = [NSString stringWithUTF8String:[returnData bytes]];
//        [self registerWithJsonString:content];
//    }
//    else{
//        [self showServerNotFoundError];
//    }
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
