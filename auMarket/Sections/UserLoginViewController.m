//
//  UserLoginViewController.m
//  zssq
//
//  Created by XuWei on 14-6-19.
//  Copyright (c) 2014年 zssq. All rights reserved.
//
#import "UserLoginViewController.h"

@interface UserLoginViewController ()

@end

@implementation UserLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initData];
        [self initUI];
    }
    return self;
}

-(void)initUI{
    [self setNavigation];
    [self createLoginUI];
}

-(void)initData{
}


-(void)setNavigation{
    self.title=@"账号登录";
}

-(void)createLoginUI{
    int offset=10;
    
    UIImageView *lineView;
    
    //第一输入区View
    UIImageView *inputView1=[[UIImageView alloc] initWithFrame:CGRectMake(20, (IOS7?37:17)+offset, WIDTH_SCREEN-40, 35)];
    inputView1.backgroundColor=[UIColor clearColor];
    inputView1.userInteractionEnabled=YES;
    inputView1.opaque=YES;
    [self.view addSubview:inputView1];
    
    lineView=[[UIImageView alloc] initWithFrame:CGRectMake(0, inputView1.frame.size.height, inputView1.frame.size.width, 1)];
    lineView.image=[UIImage imageNamed:@"grayline"];
    lineView.opaque=YES;
    [inputView1 addSubview:lineView];
    
    //第二输入区View
    UIImageView *inputView2=[[UIImageView alloc] initWithFrame:CGRectMake(20, (IOS7?85:65)+offset, WIDTH_SCREEN-40, 35)];
    inputView2.backgroundColor=[UIColor clearColor];
    inputView2.userInteractionEnabled=YES;
    inputView2.opaque=YES;
    [self.view addSubview:inputView2];
    
    lineView=[[UIImageView alloc] initWithFrame:CGRectMake(0, inputView2.frame.size.height, inputView2.frame.size.width, 1)];
    lineView.image=[UIImage imageNamed:@"grayline"];
    lineView.opaque=YES;
    [inputView2 addSubview:lineView];
    
    UIImageView *accountIcon=[[UIImageView alloc] initWithFrame:CGRectMake(4, 5, 21, 21)];
    accountIcon.image=[UIImage imageNamed:@"account_icon_black"];
    [inputView1 addSubview:accountIcon];
    
    UIImageView *pwdIcon=[[UIImageView alloc] initWithFrame:CGRectMake(4, 5, 22, 22)];
    pwdIcon.image=[UIImage imageNamed:@"pwd_icon_black"];
    [inputView2 addSubview:pwdIcon];
    
    //创建输入框
    _accountText = [[CustomTextField alloc]initWithFrame:CGRectMake(33, (IOS7?0:-5), WIDTH_SCREEN-70, 30)];
    _accountText.delegate=self;
    _accountText.font=DEFAULT_FONT(14);;
    //_accountText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _accountText.placeholder = @"请在此输入账号";
    _accountText.text=@"";
    _accountText.textColor=RGBCOLOR(45, 45, 45);
    _accountText.backgroundColor=[UIColor clearColor];
    _accountText.returnKeyType =UIReturnKeyDone;
    _accountText.keyboardType= UIKeyboardTypeEmailAddress;
    _accountText.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
    _accountText.autocapitalizationType=UITextAutocapitalizationTypeNone;
    [inputView1 addSubview:_accountText];
    
    _passwordText = [[CustomTextField alloc]initWithFrame:CGRectMake(33, (IOS7?0:-5), WIDTH_SCREEN-70, 30)];
    _passwordText.delegate=self;
    _passwordText.text=@"";
    _passwordText.font=DEFAULT_FONT(16);
    _passwordText.placeholder = @"请在此输入密码";
    _passwordText.textColor=RGBCOLOR(45, 45, 45);
    _passwordText.backgroundColor=[UIColor clearColor];
    _passwordText.returnKeyType =UIReturnKeyDone;
    _passwordText.keyboardType= UIKeyboardTypeDefault;
    _passwordText.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
    _passwordText.autocapitalizationType=UITextAutocapitalizationTypeNone;
    _passwordText.secureTextEntry=YES;
    [inputView2 addSubview:_passwordText];
    
    UIButton *login_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    login_btn.frame = CGRectMake(20, (IOS7?160:140)+offset, (WIDTH_SCREEN-40), 38);
    login_btn.titleLabel.font=DEFAULT_FONT(14);;
    [login_btn setTitle:@"登  录" forState:UIControlStateNormal];
    login_btn.backgroundColor=COLOR_MAIN;
    login_btn.layer.cornerRadius=4;
    login_btn.clipsToBounds=YES;
    login_btn.titleEdgeInsets=UIEdgeInsetsMake(2, 5, 0, 0);
    [login_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [login_btn addTarget:self action:@selector(postPersonLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: login_btn];
    
//    UIButton *regist_btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    regist_btn.frame = CGRectMake(20, (IOS7?160:140)+offset, (WIDTH_SCREEN-40-15)/2, 38);
//    regist_btn.titleLabel.font=DEFAULT_FONT(14);;
//    [regist_btn setTitle:@"注  册" forState:UIControlStateNormal];
//    regist_btn.backgroundColor=RGBCOLOR(230, 230, 230);
//    regist_btn.layer.cornerRadius=4;
//    regist_btn.clipsToBounds=YES;
//    regist_btn.titleEdgeInsets=UIEdgeInsetsMake(2,5, 0, 0);
//    [regist_btn setTitleColor:RGBCOLOR(99, 99, 99) forState:UIControlStateNormal];
//    [regist_btn addTarget:self action:@selector(gotoRegist) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview: regist_btn];

    
    int loginButtonOffsetY=100;
    int loginButtonWidth=WIDTH_SCREEN-100;
    
   
    
    self.view.backgroundColor=COLOR_BG_VIEW;
}

//保存用户信息到内存
-(void)loadUserInfo{
//    [UserDefault setValue:[[personInfoDic objectForKey:@"data"] objectForKey:@"id"] forKey:@"signid"];
//    [UserDefault synchronize];
//    MyAPP._userDataCenter.userInfo.isLogin=YES;
//    MyAPP._userDataCenter.userInfo.userid=[[personInfoDic objectForKey:@"data"] objectForKey:@"id"];
//    MyAPP._userDataCenter.userInfo.nickname=[[personInfoDic objectForKey:@"data"]  objectForKey:@"nickname"];
//    MyAPP._userDataCenter.userInfo.cityid=[UserDefault valueForKey:@"cityid"];
//    MyAPP._userDataCenter.userInfo.city=[UserDefault valueForKey:@"cityname"];
//    
//    NSMutableSet *tags = [NSMutableSet set];
//    [tags addObject:@"ios"];
//    [tags addObject:[NSString stringWithFormat:@"i_%@",[AppVersion stringByReplacingOccurrencesOfString:@"." withString:@"_"]]];
//    [tags addObject:[NSString stringWithFormat:@"%@",[UserDefault valueForKey:@"cityid"]]];
//    [tags addObject:[NSString stringWithFormat:@"%@",[UserDefault valueForKey:@"countryid"]]];
//    [JPUSHService setTags:tags alias:[NSString stringWithFormat:@"%@",[[personInfoDic objectForKey:@"data"] objectForKey:@"id"]] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
//    
//    
//    if([currentState isEqualToString:@"bindLoginForAccount"]){
//        MyAPP._userDataCenter.userInfo.account=[self._accountText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//        MyAPP._userDataCenter.userInfo.password=[Common md5:self._passwordText.text];
//        MyAPP._userDataCenter.userInfo.head=[NSString stringWithFormat:@"%@upload/avatar/%@/big@2x.jpg",appUrl,[[personInfoDic objectForKey:@"data"] objectForKey:@"id"]];
//        MyAPP._userDataCenter.userInfo.smallhead=[NSString stringWithFormat:@"%@upload/avatar/%@/small@2x.jpg",appUrl,[[personInfoDic objectForKey:@"data"]  objectForKey:@"id"]];
//    }
//    else if([currentState isEqualToString:@"bindLoginForWB"]){
//        MyAPP._userDataCenter.userInfo.account=[user_info uid];
//        MyAPP._userDataCenter.userInfo.password=@"";
//        MyAPP._userDataCenter.userInfo.head=[[user_info rawData] objectForKey:@"avatar_large"];
//        MyAPP._userDataCenter.userInfo.smallhead=[[user_info rawData] objectForKey:@"profile_image_url"];
//    }
//    else if([currentState isEqualToString:@"bindLoginForQQ"]){
//        MyAPP._userDataCenter.userInfo.account=[user_info uid];
//        MyAPP._userDataCenter.userInfo.password=@"";
//        MyAPP._userDataCenter.userInfo.head=[[user_info rawData] objectForKey:@"figureurl_qq_2"];
//        MyAPP._userDataCenter.userInfo.smallhead=[[user_info rawData] objectForKey:@"figureurl_qq_1"];
//    }
//    else if([currentState isEqualToString:@"bindLoginForWX"]){
//        NSString *largeheadStr=[[user_info rawData] objectForKey:@"headimgurl"];
//        NSString *smallheadStr=[[user_info rawData] objectForKey:@"headimgurl"];
//        if (smallheadStr!=nil&&smallheadStr.length>0) {
//            smallheadStr=[NSString stringWithFormat:@"%@%@",[smallheadStr substringToIndex:smallheadStr.length-1],@"132"];
//        }
//        
//        MyAPP._userDataCenter.userInfo.account=[[user_info rawData] objectForKey:@"unionid"];
//        MyAPP._userDataCenter.userInfo.password=@"";
//        MyAPP._userDataCenter.userInfo.head=largeheadStr;
//        MyAPP._userDataCenter.userInfo.smallhead=smallheadStr;
//    }
//    
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

//检查表单
-(Boolean)checkForm{
    if ([_accountText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length<=0) {
        [SVProgressHUD showInfoWithStatus:@"请输入账号"];
        return NO;
    }
    else if ([_passwordText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length<=0) {
        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
        return NO;
    }
    return YES;
}

//发送登录请求
-(void)postPersonLogin{
    NSString *_account=[_accountText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *_password=[_passwordText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [self resignAllTextField];
    
    if ([self checkForm]) {
        [self startLoadingActivityIndicatorWithText:@"正在请求登录..."];
        [self.model loginWithUsername:_account andPassword:_password];
    }
}

-(void)onResponse:(SPBaseModel *)model isSuccess:(BOOL)isSuccess{
    [self stopLoadingActivityIndicator];
    
    if(isSuccess){
        if(self.model.entity!=nil&&self.model.requestTag==1001){//普通登录
            [self showSuccesWithText:@"登录成功"];
            SPAccount *_account =[self.model convertToSpAccount:self.model.entity.userinfo];
            [[AccountManager sharedInstance] registerLoginUser:_account];
        }
        else if(self.model.entity!=nil&&self.model.requestTag==1002){//微信登录
            [self showSuccesWithText:@"微信登录成功"];
            SPAccount *_account =[self.model convertToSpAccount:self.model.entity.userinfo];
            [[AccountManager sharedInstance] registerLoginUser:_account];
        }
        
        //注册极光推送用户信息
        [self dismissLoginController:nil];
    }
    else{
        [self showFailWithText:@"登录发生错误"];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
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
    if (_accountText == textField)
    {
        if ([toBeString length] > 25) {
            textField.text = [toBeString substringToIndex:25];
            return NO;
        }
    }
    else if (_passwordText == textField)
    {
        if ([toBeString length] > 20) {
            textField.text = [toBeString substringToIndex:20];
            return NO;
        }
    }
    return YES;
}


//-(void)bindLoginForWX:(SSDKUser *)obj{
//    currentState=@"bindLoginForWX";
//    
//    NSString *largeheadStr=[[obj rawData] objectForKey:@"headimgurl"];
//    NSString *smallheadStr=[[obj rawData] objectForKey:@"headimgurl"];
//    if (smallheadStr!=nil&&smallheadStr.length>0) {
//        smallheadStr=[NSString stringWithFormat:@"%@%@",[smallheadStr substringToIndex:smallheadStr.length-1],@"132"];
//    }
//    NSString *urlStr = [NSString stringWithFormat:@"%@?c=member&a=login&loginid=%@&pwd=%@&loginname=%@&from=4&catid=%@&large_avatar=%@&small_avatar=%@",[MyAPP._userDataCenter.interfaceDic objectForKey:@"interface"],[[obj rawData] objectForKey:@"unionid"],@"",[obj nickname],[UserDefault valueForKey:@"cityid"],largeheadStr,smallheadStr];//from=1,代表账号登录,2:代表微博登录，3:QQ登陆，4:微信登录
//    
//    urlStr =[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"urlStr:%@",urlStr);
//    NSURL *url = [[NSURL alloc] initWithString:urlStr];
//    ASIHTTPRequest *aRequest = [[ASIHTTPRequest alloc] initWithURL:url];
//    [aRequest setDelegate:self];//代理
//    [aRequest setTimeOutSeconds:12];
//    [aRequest setDidFinishSelector:@selector(urlRequestSucessed:)];
//    [aRequest setDidFailSelector:@selector(urlRequestFailed:)];
//    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
//    [aRequest setShouldContinueWhenAppEntersBackground:YES];
//    //如果您的IOS版本大于4.0需要这段代码，否则会出现异常。
//    #endif
//    [aRequest startAsynchronous];//开始。异步
//}

//-(void)urlRequestSucessed:(ASIHTTPRequest*)request
//{
//    if ([currentState isEqualToString:@"bindLoginForWX"]) {
//        NSData *responseData = [request responseData];
//        NSError *error;
//        personInfoDic=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
//        
//        if (error)
//        {
//            [SVProgressHUD ShowBorder];
//            [SVProgressHUD showErrorWithStatus:@"对不起，微信帐号绑定返回错误。"];
//            NSLog(@"error: %@", [error localizedDescription]);
//        }
//        else{
//            if ([[personInfoDic objectForKey:@"state"] isEqualToString:@"success"]) {
//                if (![[personInfoDic objectForKey:@"data"] isKindOfClass:[NSString class]] &&[[personInfoDic objectForKey:@"data"] count]>=5){
//                    [self loadUserInfo];
//                    [MyAPP._userDataCenter savePersonIdentity];
//                    
//                    [SVProgressHUD ShowBorder];
//                    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
//                    
//                    [self goBack];
//                }
//                else if ([[personInfoDic objectForKey:@"data"] isEqualToString:@"1"]) {
//                    [SVProgressHUD showInfoWithStatus:@"登录失败，账号错误。"];
//                }
//                else if ([[personInfoDic objectForKey:@"data"] isEqualToString:@"2"]) {
//                    [SVProgressHUD showInfoWithStatus:@"登录失败，密码错误。"];
//                }
//                else if ([[personInfoDic objectForKey:@"data"] isEqualToString:@"3"]) {
//                    [SVProgressHUD showInfoWithStatus:@"登录失败，用户名已存在。"];
//                }
//                else if ([[personInfoDic objectForKey:@"data"] isEqualToString:@"4"]) {
//                    [SVProgressHUD showInfoWithStatus:@"登录失败，用户被锁定。"];
//                }
//                else{
//                    [SVProgressHUD showInfoWithStatus:@"登录失败，请检查用户名或密码是否正确。"];
//                }
//            }
//            else{
//                [SVProgressHUD ShowBorder];
//                [SVProgressHUD showErrorWithStatus:@"对不起，帐号绑定返回错误。"];
//            }
//        }
//    }
//}
//
//
//-(void)urlRequestFailed:(ASIHTTPRequest *)request
//{
//    if ([currentState isEqualToString:@"bindLoginForWX"]) {
//        //NSError *error = [request error];
//        //NSLog(@"Weibo LOGIN ERROR:%@",error.description);
//        [SVProgressHUD ShowBorder];
//        [SVProgressHUD showErrorWithStatus:@"对不起，QQ帐号绑定失败。"];
//    }
//}


-(void)gotoRegist{
    UserRegistViewController *rvc=[[UserRegistViewController alloc] init:0];
    [self.navigationController pushViewController:rvc animated:YES];
}


-(void)gotoMainView{
//    Launch *ln=[[Launch alloc] init];
//    tvc=[[UITabBarController alloc] init];
//    tvc.delegate=self;
//    //[tvc.tabBar setTintColor:[UIColor whiteColor]];
//    tvc.viewControllers=[ln getTabbarViewControllers];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{ UITextAttributeTextColor : RGBCOLOR(130, 130, 130) }
//                                             forState:UIControlStateNormal];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{ UITextAttributeTextColor : MainColor }
//                                             forState:UIControlStateSelected];
//    
//    //MainViewController *mvc=[[MainViewController alloc] init];
//    
//    [self.navigationController pushViewController:tvc animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}



-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onBack
{
    if(self.isModalState){
        [self dismissLoginController:nil];
    }
    else{
        [self goBack];
    }
}

- (void)dismissLoginController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/* 点击背景时关闭键盘 **/
-(void)handleBackgroundTap:(UITapGestureRecognizer *)sender{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    
    [self resignAllTextField];
}

-(void)resignAllTextField{
    [_accountText resignFirstResponder];
    [_passwordText resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleBackgroundTap:)];
//    tapRecognizer.cancelsTouchesInView = NO;
//    [self.view addGestureRecognizer:tapRecognizer];
}

-(MemberLoginModel *)model{
    if(!_model){
        _model=[[MemberLoginModel alloc] init];
        _model.delegate=self;
    }
    return _model;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar  setTranslucent:NO];
}


-(void)viewWillDisappear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
