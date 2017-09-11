//
//  UserLoginViewController.m
//  zssq
//
//  Created by XuWei on 14-6-19.
//  Copyright (c) 2014年 zssq. All rights reserved.
//
#import "UserRegistViewController.h"

@interface UserRegistViewController ()
{
    NSArray *_permissions;
    UIButton *checkCode_btn;
    NSTimer *timer;
    BOOL timeStart;
    int fg;
}
@end

@implementation UserRegistViewController
@synthesize accountText,passwordText,checkCodeText,nicknameText,connection,getUrlString,receivedData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)init:(int)n
{
    self = [super init];
    if (self) {
        fg=n;
        receivedData= [[NSMutableData alloc] initWithData:nil];
        [self createLoginUI];
        self.view.backgroundColor=COLOR_BG_VIEW;
    }
    return self;
}


-(void)createLoginUI{
    [self createNavigation];
    int offset=0;
    
    UIImageView *lineView;
    
    UIImageView *inputView1=[[UIImageView alloc] initWithFrame:CGRectMake(20, (IOS7?40:20)+offset, WIDTH_SCREEN-40, 33)];
    inputView1.backgroundColor=[UIColor clearColor];
    inputView1.userInteractionEnabled=YES;
    [self.view addSubview:inputView1];
    
    lineView=[[UIImageView alloc] initWithFrame:CGRectMake(0, inputView1.frame.size.height, inputView1.frame.size.width, 1)];
    lineView.image=[UIImage imageNamed:@"grayline"];
    lineView.opaque=YES;
    [inputView1 addSubview:lineView];
    
    UIImageView *inputView2=[[UIImageView alloc] initWithFrame:CGRectMake(20, (IOS7?85:65)+offset, WIDTH_SCREEN-40, 33)];
    inputView2.backgroundColor=[UIColor clearColor];
    inputView2.userInteractionEnabled=YES;
    [self.view addSubview:inputView2];
    
    lineView=[[UIImageView alloc] initWithFrame:CGRectMake(0, inputView2.frame.size.height, inputView2.frame.size.width, 1)];
    lineView.image=[UIImage imageNamed:@"grayline"];
    lineView.opaque=YES;
    [inputView2 addSubview:lineView];
    
    UIImageView *inputView3=[[UIImageView alloc] initWithFrame:CGRectMake(20, (IOS7?130:110)+offset, WIDTH_SCREEN-40, 33)];
    inputView3.backgroundColor=[UIColor clearColor];
    inputView3.userInteractionEnabled=YES;
    [self.view addSubview:inputView3];
    
    lineView=[[UIImageView alloc] initWithFrame:CGRectMake(0, inputView3.frame.size.height, inputView3.frame.size.width, 1)];
    lineView.image=[UIImage imageNamed:@"grayline"];
    lineView.opaque=YES;
    [inputView3 addSubview:lineView];
    
    UIImageView *accountIcon=[[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 17, 17)];
    accountIcon.image=[UIImage imageNamed:@"account_icon_black.png"];
    [inputView1 addSubview:accountIcon];
    
    UIImageView *pwdIcon=[[UIImageView alloc] initWithFrame:CGRectMake(5, 6, 21, 21)];
    pwdIcon.image=[UIImage imageNamed:@"mark.png"];
    [inputView2 addSubview:pwdIcon];
    
    pwdIcon=[[UIImageView alloc] initWithFrame:CGRectMake(6, 8, 19, 19)];
    pwdIcon.image=[UIImage imageNamed:@"pwd_icon_black.png"];
    [inputView3 addSubview:pwdIcon];

    
    //创建输入框
    accountText = [[CustomTextField alloc]initWithFrame:CGRectMake(40, (IOS7?4:0), WIDTH_SCREEN-90, 30)];
    accountText.delegate=self;
    accountText.font=DEFAULT_FONT(16.0);
    accountText.clearButtonMode = UITextFieldViewModeWhileEditing;
    accountText.placeholder = @"请在此输入账号";
    accountText.textColor=RGBCOLOR(55, 55, 55);
    accountText.backgroundColor=[UIColor clearColor];
    accountText.returnKeyType =UIReturnKeyDone;
    accountText.keyboardType= UIKeyboardTypeEmailAddress;
    accountText.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
    accountText.autocapitalizationType=UITextAutocapitalizationTypeNone;
    [inputView1 addSubview:accountText];
    
    //创建昵称
    nicknameText = [[CustomTextField alloc]initWithFrame:CGRectMake(40, (IOS7?3:0), WIDTH_SCREEN-90, 30)];
    nicknameText.delegate=self;
    nicknameText.font=DEFAULT_FONT(14.0);
    nicknameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    nicknameText.placeholder = @"请在此输入昵称";
    nicknameText.textColor=RGBCOLOR(55, 55, 55);
    nicknameText.backgroundColor=[UIColor clearColor];
    nicknameText.returnKeyType =UIReturnKeyDone;
    nicknameText.keyboardType= UIKeyboardTypeDefault;
    nicknameText.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
    nicknameText.autocapitalizationType=UITextAutocapitalizationTypeNone;
    [inputView2 addSubview:nicknameText];

    passwordText = [[CustomTextField alloc]initWithFrame:CGRectMake(40, (IOS7?3:0), WIDTH_SCREEN-90, 30)];
    passwordText.delegate=self;
    passwordText.font=DEFAULT_FONT(12.0);
    passwordText.placeholder = @"请在此输入密码";
    passwordText.textColor=RGBCOLOR(55, 55, 55);
    passwordText.backgroundColor=[UIColor clearColor];
    passwordText.returnKeyType =UIReturnKeyDone;
    passwordText.keyboardType= UIKeyboardTypeDefault;
    passwordText.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
    passwordText.autocapitalizationType=UITextAutocapitalizationTypeNone;
    passwordText.secureTextEntry=YES;
    [inputView3 addSubview:passwordText];
    
    
    UIButton *login_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    login_btn.frame = CGRectMake(20, (IOS7?270:250)+offset, WIDTH_SCREEN-40, 36);
    login_btn.titleLabel.font=DEFAULT_FONT(16.0f);
    [login_btn setTitle:@"注  册" forState:UIControlStateNormal];
    login_btn.backgroundColor=COLOR_MAIN;
    login_btn.layer.cornerRadius=6;
    login_btn.clipsToBounds=YES;
    [login_btn setTitleColor:RGBCOLOR(250, 250, 250) forState:UIControlStateNormal];
    [login_btn addTarget:self action:@selector(postPersonRegist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: login_btn];
    
    UIButton *registButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH_SCREEN-90)/2, HEIGHT_SCREEN-60, 90, 35)];
    [registButton setAutoresizingMask: UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    [registButton setTitle:NSLocalizedString(@"我已经有账号", nil) forState:UIControlStateNormal];
    [registButton addTarget:self action:@selector(gotoLogin) forControlEvents:UIControlEventTouchUpInside];
    [registButton setTitleColor:RGBCOLOR(100, 100, 100) forState:UIControlStateNormal];
    registButton.titleLabel.font=DEFAULT_FONT(14.0f);
    [self.view addSubview:registButton];
}

//创建导航栏
-(void)createNavigation{
    self.title=@"注册账号";
}

-(void)loadUserInfo{
//    [UserDefault setValue:[[personInfoDic objectForKey:@"data"] objectForKey:@"id"] forKey:@"signid"];
//    [UserDefault synchronize];
//    MyAPP._userDataCenter.userInfo.isLogin=YES;
//    MyAPP._userDataCenter.userInfo.userid=[[personInfoDic objectForKey:@"data"] objectForKey:@"id"];
//    MyAPP._userDataCenter.userInfo.nickname=[self.nicknameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    MyAPP._userDataCenter.userInfo.account=[self.accountText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    MyAPP._userDataCenter.userInfo.password=[Common md5:self.passwordText.text];
//    MyAPP._userDataCenter.userInfo.head=@"";
//    MyAPP._userDataCenter.userInfo.sex=@"";
//    MyAPP._userDataCenter.userInfo.city=[UserDefault valueForKey:@"cityname"];
//    MyAPP._userDataCenter.userInfo.cityid=[UserDefault valueForKey:@"cityid"];
//    
//    NSMutableSet *tags = [NSMutableSet set];
//    [tags addObject:@"ios"];
//    [tags addObject:[NSString stringWithFormat:@"i_%@",[AppVersion stringByReplacingOccurrencesOfString:@"." withString:@"_"]]];
//    [tags addObject:[NSString stringWithFormat:@"%@",[UserDefault valueForKey:@"cityid"]]];
//    [tags addObject:[NSString stringWithFormat:@"%@",[UserDefault valueForKey:@"countryid"]]];
//    [JPUSHService setTags:tags alias:[NSString stringWithFormat:@"%@",[[personInfoDic objectForKey:@"data"] objectForKey:@"id"]] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias {
    NSString *callbackString =[NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
                               [self logSet:tags], alias];
    NSLog(@"TagsAlias回调:%@", callbackString);
}

- (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

-(Boolean)checkForm{
    if ([self.accountText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length<=0) {
        [SVProgressHUD showInfoWithStatus:@"请输入账号名称"];
        return NO;
    }
    else if([self.accountText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length<3){
        [SVProgressHUD showInfoWithStatus:@"您输入的账号太短"];
        return NO;
    }
    else if ([self.nicknameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length<=0) {
        [SVProgressHUD showInfoWithStatus:@"请输入昵称"];
        return NO;
    }
    else if ([self.passwordText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length<=0) {
        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
        return NO;
    }
    return YES;
}


-(void)postPersonRegist{
    if ([self checkForm]) {
//        APP_WINDOW.networkActivityIndicatorVisible = YES;
//        [SVProgressHUD showWithStatus:@"正在提交注册..." maskType:SVProgressHUDMaskTypeClear];
//        self.getUrlString = [NSString stringWithFormat:@"%@?c=Member&a=register&loginid=%@&pwd=%@&loginname=%@&catid=%@",[MyAPP._userDataCenter.interfaceDic objectForKey:@"interface"],[self.accountText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],[Common md5:self.passwordText.text],[self.nicknameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],[UserDefault valueForKey:@"cityid"]];
//        self.getUrlString =[self.getUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSLog(@"regist url->%@",self.getUrlString);
//        NSURL *url = [[NSURL alloc] initWithString:self.getUrlString];//stringByAddingPercentEscapesUsingEncoding
////        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
////                                        initWithURL:url
////                                        cachePolicy:NSURLRequestReloadIgnoringCacheData
////                                        timeoutInterval:15];
////        if([Common checkNetwork]){
////            connection = [[NSURLConnection alloc] initWithRequest:request  delegate:self];
////            if (connection == nil) {
////                //连接失败
////                [SVProgressHUD showErrorWithStatus:@"与服务器建立连接失败"];
////                NSLog(@"建立获取异步连接失败");
////            }
////        }
////        else{
////            [SVProgressHUD showErrorWithStatus:@"当前没有网络"];
////        }
//        
//        if([Common checkNetwork]){
//            ASIHTTPRequest *aRequest = [ASIHTTPRequest requestWithURL:url];
//            __weak typeof(ASIHTTPRequest) *weakRequest=aRequest;
//            
//            [aRequest setRequestMethod:@"POST"];
//            [aRequest setTimeOutSeconds:15];
//            [aRequest setCompletionBlock:^{
//                NSString *responseString = [weakRequest responseString];
//                NSData *_jsonData = [responseString dataUsingEncoding: NSUTF8StringEncoding];
//                NSError *error;
//                personInfoDic=[NSJSONSerialization JSONObjectWithData:_jsonData options:kNilOptions error:&error];
//                if (error)
//                {
//                    [SVProgressHUD ShowBorder];
//                    [SVProgressHUD showErrorWithStatus:@"对不起，注册发生错误。"];
//                }
//                else{
//                    if ([[personInfoDic objectForKey:@"state"] isEqualToString:@"success"]) {
//                        if(![[personInfoDic objectForKey:@"data"] isKindOfClass:[NSNumber class]]){
//                            [self loadUserInfo];
//                            [self gotoMainView];
//                            
//                            [MyAPP._userDataCenter savePersonIdentity];
//                        }
//                        else if ([[personInfoDic objectForKey:@"data"] intValue]==3) {
//                            [self showTopMessage:@"此账号已经被注册。"];
//                        }
//                        else {
//                            [self showTopMessage:@"对不起，注册发生错误。"];
//                        }
//                        //if (![[personInfoDic objectForKey:@"data"] isKindOfClass:[NSString class]] &&[[personInfoDic objectForKey:@"data"] count]>=5) {
//                    }
//                    else if ([[personInfoDic objectForKey:@"state"] isEqualToString:@"repeat"]) {
//                        [self showTopMessage:@"昵称已经存在"];
//                    }
//                    else if ([[personInfoDic objectForKey:@"state"] isEqualToString:@"illegal"]) {
//                        [self showTopMessage:@"注册信息含有不妥当的关键词"];
//                    }
//                    else if ([[personInfoDic objectForKey:@"state"] isEqualToString:@"close"]) {
//                        [self showTopMessage:@"此注册方式暂时关闭，请使用第三方登录"];
//                    }
//                    else{
//                        [self showTopMessage:@"注册失败"];
//                    }
//                }
//            }];
//            
//            [aRequest setShouldContinueWhenAppEntersBackground:YES];
//            [aRequest startAsynchronous];//开始。异步
//        }
//        else{
//            [SVProgressHUD showErrorWithStatus:@"当前没有网络"];
//        }
    }
}

/////////connection delegate
//// 收到回应
//- (void)connection:(NSURLConnection *)theconnection didReceiveResponse:(NSURLResponse *)response
//{
//    if ([theconnection.currentRequest.URL.absoluteString isEqualToString:self.getUrlString]) {
//        [receivedData setLength:0];
//    }
//}
//
//
//// 接收数据
//- (void)connection:(NSURLConnection *)theconnection didReceiveData:(NSData *)data
//{
//    if ([theconnection.currentRequest.URL.absoluteString isEqualToString:self.getUrlString]) {
//        [self.receivedData appendData:data];
//    }
//}
//
//// 数据接收完毕
//- (void)connectionDidFinishLoading:(NSURLConnection *)theconnection
//{
//    if ([theconnection.currentRequest.URL.absoluteString isEqualToString:self.getUrlString]) {
//        MyWindow.networkActivityIndicatorVisible = NO;
//        [SVProgressHUD dismiss];
//        NSString *results = [[NSString alloc] initWithBytes:[self.receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
//        results=[results stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSLog(@"login results->%@",results);
//        NSData *_jsonData = [results dataUsingEncoding: NSUTF8StringEncoding];
//        NSError *error;
//        personInfoDic=[NSJSONSerialization JSONObjectWithData:_jsonData options:kNilOptions error:&error];
//        
//        if (error)
//        {
//            [self showTopMessage:@"注册失败"];
//            NSLog(@"error: %@", [error localizedDescription]);
//        }
//        else{
//            
//            if ([[personInfoDic objectForKey:@"state"] isEqualToString:@"success"]) {
//                if(![[personInfoDic objectForKey:@"data"] isKindOfClass:[NSNumber class]]){
//                    [self loadUserInfo];
//                    [self gotoMainView];
//                    
//                    [MyAPP._userDataCenter savePersonIdentity];
//                }
//                else if ([[personInfoDic objectForKey:@"data"] intValue]==3) {
//                    [self showTopMessage:@"此账号已经被注册。"];
//                }
//                else {
//                    [self showTopMessage:@"对不起，注册发生错误。"];
//                }
//                //if (![[personInfoDic objectForKey:@"data"] isKindOfClass:[NSString class]] &&[[personInfoDic objectForKey:@"data"] count]>=5) {
//            }
//            else if ([[personInfoDic objectForKey:@"state"] isEqualToString:@"repeat"]) {
//                [self showTopMessage:@"昵称已经存在"];
//            }
//            else if ([[personInfoDic objectForKey:@"state"] isEqualToString:@"illegal"]) {
//                [self showTopMessage:@"注册信息含有不妥当的关键词"];
//            }
//            else if ([[personInfoDic objectForKey:@"state"] isEqualToString:@"close"]) {
//                [self showTopMessage:@"此注册方式暂时关闭，请使用第三方登录"];
//            }
//            else{
//                [self showTopMessage:@"注册失败"];
//            }
//            
//        }
//    }
//}
//
//// 返回错误
//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    MyWindow.networkActivityIndicatorVisible = NO;
//    [SVProgressHUD dismiss];
//    if(error.code==-1001)
//    {
//        [SVProgressHUD showErrorWithStatus:@"请求超时，请重试"];
//    }
//    else if(error.code==-1009)
//    {
//        [SVProgressHUD showErrorWithStatus:@"加载失败，请检查是否正确连接网络"];
//    }
//    else if(error.code==-1008)
//    {
//        [SVProgressHUD showErrorWithStatus:@"加载失败，请求的资源无效"];
//    }
//    else if(error.code==-1011)
//    {
//        [SVProgressHUD showErrorWithStatus:@"加载失败，服务无响应"];
//    }
//    else if(error.code==-1100)
//    {
//        [SVProgressHUD showErrorWithStatus:@"加载失败，请求的资源不存在"];
//    }
//    else if(error.code==-1007)
//    {
//        [SVProgressHUD showErrorWithStatus:@"加载失败，服务繁忙"];
//    }
//    else{
//        [SVProgressHUD showErrorWithStatus:@"加载发生错误"];
//    }
//    NSLog(@"Connection failed: %@", error);
//}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect frame = textField.superview.frame;
    int offset = frame.origin.y + 70 - (self.view.frame.size.height - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (self.accountText == textField)
    {
        if ([toBeString length] > 25) {
            textField.text = [toBeString substringToIndex:25];
            return NO;
        }
    }
    else if (self.passwordText == textField)
    {
        if ([toBeString length] > 20) {
            textField.text = [toBeString substringToIndex:20];
            return NO;
        }
    }
    else if (self.checkCodeText == textField)
    {
        if ([textField.text length] >6)
        {
            textField.text = [textField.text substringToIndex:6];
            return NO;
        }
    }
    return YES;
}



-(void)gotoLogin{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)gotoMainView{
//    Launch *ln=[[Launch alloc] init];
//    UITabBarController *tvc=[[UITabBarController alloc] init];
//    tvc.delegate=self;
//    tvc.viewControllers=[ln getTabbarViewControllers];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{ UITextAttributeTextColor : RGBCOLOR(130, 130, 130) }
//                                             forState:UIControlStateNormal];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{ UITextAttributeTextColor : RGBCOLOR(236, 56, 104) }
//                                             forState:UIControlStateSelected];
//    [self.navigationController pushViewController:tvc animated:YES];
}

/* 点击背景时关闭键盘 **/
-(void)handleBackgroundTap:(UITapGestureRecognizer *)sender{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    
    [self.accountText resignFirstResponder];
    [self.nicknameText resignFirstResponder];
    [self.accountText resignFirstResponder];
    [self.passwordText resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
}


-(void)viewWillDisappear:(BOOL)animated{
    if (connection!=nil) {
        [connection cancel];
        [SVProgressHUD dismiss];
        APP_WINDOW.networkActivityIndicatorVisible=NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleBackgroundTap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
