//
//  vkLoginViewController.m
//  motivateme2
//
//  Created by Valeriy on 20.11.13.
//  Copyright (c) 2013 esys.mobi. All rights reserved.
//

#import "vkLoginViewController.h"
#define appID2 "4008058"
#import "AppDelegate.h"
@interface vkLoginViewController ()

@end

@implementation vkLoginViewController

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
    NSString *authLink = [NSString stringWithFormat:@"http://api.vk.com/oauth/authorize?client_id=%s&scope=wall,photos&redirect_uri=http://api.vk.com/blank.html&display=touch&response_type=token", appID2];
    NSURL *url = [NSURL URLWithString:authLink];
    //vkWebView.delegate=self;
    [vkWebView loadRequest:[NSURLRequest requestWithURL:url]];
    NSLog(@"%@",url);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
    // Если есть токен сохраняем его
    if ([vkWebView.request.URL.absoluteString rangeOfString:@"access_token"].location != NSNotFound) {
        NSString *accessToken = [self stringBetweenString:@"access_token="
                                                andString:@"&"
                                              innerString:[[[webView request] URL] absoluteString]];
        
        // Получаем id пользователя, пригодится нам позднее
        NSArray *userAr = [[[[webView request] URL] absoluteString] componentsSeparatedByString:@"&user_id="];
        NSString *user_id = [userAr lastObject];
        NSLog(@"User id: %@", user_id);
        if(user_id){
            [[NSUserDefaults standardUserDefaults] setObject:user_id forKey:@"VKAccessUserId"];
        }
        
        if(accessToken){
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"VKAccessToken"];
            // Сохраняем дату получения токена. Параметр expires_in=86400 в ответе ВКонтакта, говорит сколько будет действовать токен.
            // В данном случае, это для примера, мы можем проверять позднее истек ли токен или нет
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"VKAccessTokenDate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        NSLog(@"vkWebView response: %@",[[[webView request] URL] absoluteString]);
  
    } else if ([vkWebView.request.URL.absoluteString rangeOfString:@"error"].location != NSNotFound) {
        NSLog(@"Error: %@", vkWebView.request.URL.absoluteString);
 
    }
    [self sendImageAction];
    //[self sendText];
}

- (void)sendImageAction{
    NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"VKAccessUserId"];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"VKAccessToken"];
    
    // Этап 1
    if ([accessToken length]>7){
    NSString *getWallUploadServer = [NSString stringWithFormat:@"https://api.vk.com/method/photos.getWallUploadServer?owner_id=%@&access_token=%@", user_id, accessToken];
    
    NSDictionary *uploadServer = [self sendRequest:getWallUploadServer withCaptcha:NO];
   // NSLog(@"uploadserver=%@",uploadServer);
    // Получаем ссылку для загрузки изображения
    NSString *upload_url = [[uploadServer objectForKey:@"response"] objectForKey:@"upload_url"];
    // Этап 2
    // Преобразуем изображение в NSData
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *file = [NSString stringWithFormat:@"%i.%@", appDelegate.flag, @"png"];
   // NSLog(@"file=%@",file);
    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectoryPath, file]];
   // NSLog(@"%@",[NSString stringWithFormat:@"%@/%@", documentsDirectoryPath, file]);
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    NSDictionary *postDictionary = [self sendPOSTRequest:upload_url withImageData:imageData];
    
    // Из полученного ответа берем hash, photo, server
    NSString *hash = [postDictionary objectForKey:@"hash"];
    NSString *photo = [postDictionary objectForKey:@"photo"];
    NSString *server = [postDictionary objectForKey:@"server"];
    // Этап 3
    // Создаем запрос на сохранение фото на сервере вконтакте, в ответ получим id фото
    NSString *saveWallPhoto = [NSString stringWithFormat:@"https://api.vk.com/method/photos.saveWallPhoto?owner_id=%@&access_token=%@&server=%@&photo=%@&hash=%@", user_id, accessToken,server,photo,hash];
    NSLog(@"accesToken=%@",accessToken);
    saveWallPhoto = [saveWallPhoto stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSData *jsondata=[NSData dataWithContentsOfURL:[NSURL URLWithString:saveWallPhoto]];
//    NSLog(@"%@",jsondata);
//    NSLog(@"savewallphoto=%@",saveWallPhoto);
    NSDictionary *saveWallPhotoDict = [self sendRequest:saveWallPhoto withCaptcha:NO];
   // NSLog(@"saveWallPhotoDict=%@",saveWallPhotoDict);
    NSDictionary *photoDict = [[saveWallPhotoDict objectForKey:@"response"] lastObject];
   // NSLog(@"PhotoDict=%@",photoDict);
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:saveWallPhoto]
//                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
//                                                       timeoutInterval:60.0];
//    
//    // Для простоты используется обычный запрос NSURLConnection, ответ сервера сохраняем в NSData
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSLog(@"responsedata=%@",responseData);
//    //NSData *jsondata=[NSData dataWithContentsOfURL:[NSURL URLWithString:saveWallPhoto]];
//    NSDictionary *photoDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
//    NSLog(@"photoDict=%@",photoDict);
//    NSDictionary *photoDict2 = [[photoDict objectForKey:@"response"] lastObject];
    NSString *photoId = [photoDict objectForKey:@"id"];
    NSString *postToWallLink = [NSString stringWithFormat:@"https://api.vk.com/method/wall.post?owner_id=%@&access_token=%@&message=%@&attachment=%@", user_id, accessToken, [self URLEncodedString:@"Motivate Me"], photoId];
   // NSLog(@"posttowalllink=%@",postToWallLink);
    NSDictionary *postToWallDict = [self sendRequest:postToWallLink withCaptcha:NO];
    NSString *errorMsg = [[postToWallDict  objectForKey:@"error"] objectForKey:@"error_msg"];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    label.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:label];
    UIAlertView *aw = [[UIAlertView alloc] initWithTitle:@"" message:@"Картинка успешно размещена" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [aw show];}
}

- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger) buttonIndex
{
    if (buttonIndex == 0)
    {   [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"Cancel Tapped.");
    }
    else if (buttonIndex == 1)
    {
        NSLog(@"OK Tapped. Hello World!");
    }
}

- (NSDictionary *) sendPOSTRequest:(NSString *)reqURl withImageData:(NSData *)imageData {
    NSLog(@"Sending request: %@", reqURl);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqURl]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:60.0];
    // Устанавливаем метод POST
    [request setHTTPMethod:@"POST"];
    
    // Кодировка UTF-8
    [request addValue:@"8bit" forHTTPHeaderField:@"Content-Transfer-Encoding"];
    
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuid));
    CFRelease(uuid);
    NSString *stringBoundary = [NSString stringWithFormat:@"0xKhTmLbOuNdArY-%@",uuidString];
    NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;  boundary=%@", stringBoundary];
    
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[[NSString stringWithFormat:@"%@",endItemBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Добавляем body к NSMutableRequest
    [request setHTTPBody:body];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *dict;
    if(responseData){
        dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        
        // Если есть описание ошибки в ответе
        NSString *errorMsg = [[dict objectForKey:@"error"] objectForKey:@"error_msg"];
        
        NSLog(@"Server response: %@ \nError: %@", dict, errorMsg);
        
        return dict;
    }
    return nil;
}

- (void) sendText {
    NSLog(@"sendText");
    NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"VKAccessUserId"];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"VKAccessToken"];
    
    NSString *text = @"Работать с ВКонтакте API легко!";
    
    // Создаем запрос на размещение текста на стене
    NSString *sendTextMessage = [NSString stringWithFormat:@"https://api.vk.com/method/wall.post?owner_id=%@&access_token=%@&message=%@", user_id, accessToken, [self URLEncodedString:text]];
    NSLog(@"sendTextMessage: %@", sendTextMessage);
    
    // Если запрос более сложный мы можем работать дальше с полученным ответом
    NSDictionary *result = [self sendRequest:sendTextMessage withCaptcha:NO];
    // Если есть описание ошибки в ответе
    NSString *errorMsg = [[result objectForKey:@"error"] objectForKey:@"error_msg"];
    
}

- (NSDictionary *) sendRequest:(NSString *)reqURl withCaptcha:(BOOL)captcha {
    // Если это запрос после ввода капчи, то добавляем в запрос параметры captcha_sid и captcha_key
    if(captcha == YES){
        NSString *captcha_sid = [[NSUserDefaults standardUserDefaults] objectForKey:@"captcha_sid"];
        NSString *captcha_user = [[NSUserDefaults standardUserDefaults] objectForKey:@"captcha_user"];
        // Добавляем к запросу данные для капчи. Не забываем, что введенный пользователем текст нужно обработать.
        reqURl = [reqURl stringByAppendingFormat:@"&captcha_sid=%@&captcha_key=%@", captcha_sid, [self URLEncodedString: captcha_user]];
    }
    NSLog(@"Sending request: %@", reqURl);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqURl]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:60.0];
    
    // Для простоты используется обычный запрос NSURLConnection, ответ сервера сохраняем в NSData
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
   NSLog(@"sendrequestresp%@",responseData);
    // Если ответ получен успешно, можем его посмотреть и заодно с помощью JSONKit получить NSDictionary
    if(responseData){
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        
        // Если есть описание ошибки в ответе
        NSString *errorMsg = [[dict objectForKey:@"error"] objectForKey:@"error_msg"];
        
        NSLog(@"Server response: %@ \nError: %@", dict, errorMsg);
        
        // Если требуется ввод капчи. Тут я проверяю на строку Captcha needed, хотя лучше использовать код ошибки.
        if([errorMsg isEqualToString:@"Captcha needed"]){
            isCaptcha = YES;
            // Сохраняем параметры для капчи
            NSString *captcha_sid = [[dict objectForKey:@"error"] objectForKey:@"captcha_sid"];
            NSString *captcha_img = [[dict objectForKey:@"error"] objectForKey:@"captcha_img"];
            [[NSUserDefaults standardUserDefaults] setObject:captcha_img forKey:@"captcha_img"];
            [[NSUserDefaults standardUserDefaults] setObject:captcha_sid forKey:@"captcha_sid"];
            // Сохраняем url запроса чтобы сделать его повторно после ввода капчи
            [[NSUserDefaults standardUserDefaults] setObject:reqURl forKey:@"request"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self getCaptcha];
        }
        NSLog(@"returndict=%@",dict);
        return dict;
    }
    return nil;
}

- (NSString *)URLEncodedString:(NSString *)str
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)str,
                                                                           NULL,
                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8));
    return result;
}

- (void) getCaptcha {
    
    NSString *captcha_img = [[NSUserDefaults standardUserDefaults] objectForKey:@"captcha_img"];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Введите код:\n\n\n\n\n"
                                                          message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12.0, 45.0, 130.0, 50.0)];
    imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:captcha_img]]];
    [myAlertView addSubview:imageView];
    
    UITextField *myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 110.0, 260.0, 25.0)];
    [myTextField setBackgroundColor:[UIColor whiteColor]];
    
    // Отключаем автокорректировку
    myTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    // Отключаем автокапитализацию
    myTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    myTextField.tag = 33;
    
    [myAlertView addSubview:myTextField];
    [myAlertView show];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(isCaptcha && buttonIndex == 1){
        isCaptcha = NO;
        
        UITextField *myTextField = (UITextField *)[actionSheet viewWithTag:33];
        [[NSUserDefaults standardUserDefaults] setObject:myTextField.text forKey:@"captcha_user"];
        NSLog(@"Captcha entered: %@",myTextField.text);
        
        // Вспоминаем какой был последний запрос и делаем его еще раз
        NSString *request = [[NSUserDefaults standardUserDefaults] objectForKey:@"request"];
        
        NSDictionary *newRequestDict =[self sendRequest:request withCaptcha:YES];
        NSString *errorMsg = [[newRequestDict  objectForKey:@"error"] objectForKey:@"error_msg"];
    }
}


- (NSString*)stringBetweenString:(NSString*)start
                       andString:(NSString*)end
                     innerString:(NSString*)str

{
    NSScanner* scanner = [NSScanner scannerWithString:str];
    [scanner setCharactersToBeSkipped:nil];
    [scanner scanUpToString:start intoString:NULL];
    if ([scanner scanString:start intoString:NULL]) {
        NSString* result = nil;
        if ([scanner scanUpToString:end intoString:&result]) {
            return result;
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
