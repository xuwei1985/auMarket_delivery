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
    int offset=30;
    
    UIImageView *lineView;
    
    UIView *loginView=[[UIView alloc] initWithFrame:CGRectMake(0, 20+offset, WIDTH_SCREEN, 102)];
    loginView.backgroundColor=COLOR_BG_WHITE;
    [self.view addSubview:loginView];
    
    //第一输入区View
    UIImageView *inputView1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 50)];
    inputView1.backgroundColor=COLOR_BG_WHITE;
    inputView1.userInteractionEnabled=YES;
    inputView1.opaque=YES;
    [loginView addSubview:inputView1];
    
    lineView=[[UIImageView alloc] initWithFrame:CGRectMake(0, inputView1.frame.size.height, inputView1.frame.size.width, 1)];
    lineView.image=[UIImage imageNamed:@"grayline"];
    lineView.opaque=YES;
    [inputView1 addSubview:lineView];
    
    //第二输入区View
    UIImageView *inputView2=[[UIImageView alloc] initWithFrame:CGRectMake(0, 52, WIDTH_SCREEN, 50)];
    inputView2.backgroundColor=COLOR_BG_WHITE;
    inputView2.userInteractionEnabled=YES;
    inputView2.opaque=YES;
    [loginView addSubview:inputView2];
    
    lineView=[[UIImageView alloc] initWithFrame:CGRectMake(0, inputView2.frame.size.height, inputView2.frame.size.width, 1)];
    lineView.image=[UIImage imageNamed:@"grayline"];
    lineView.opaque=YES;
    [inputView2 addSubview:lineView];
    
    UIImageView *accountIcon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 24, 22)];
    accountIcon.image=[UIImage imageNamed:@"account_icon_black"];
    [inputView1 addSubview:accountIcon];
    
    UIImageView *pwdIcon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 25, 25)];
    pwdIcon.image=[UIImage imageNamed:@"pwd_icon_black"];
    [inputView2 addSubview:pwdIcon];
    
    //创建输入框
    _accountText = [[UITextField alloc] initWithFrame:CGRectMake(40, 6, WIDTH_SCREEN-60, 39)];
    _accountText.delegate=self;
    _accountText.font=DEFAULT_FONT(15);;
    //_accountText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _accountText.placeholder = @"请输入账号";
    _accountText.text=@"";
    _accountText.textColor=RGBCOLOR(45, 45, 45);
    _accountText.backgroundColor=[UIColor clearColor];
    _accountText.returnKeyType =UIReturnKeyDone;
    _accountText.keyboardType= UIKeyboardTypeDefault;
    _accountText.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
    _accountText.autocapitalizationType=UITextAutocapitalizationTypeNone;
    [inputView1 addSubview:_accountText];
    
    _passwordText = [[UITextField alloc] initWithFrame:CGRectMake(40, 6, WIDTH_SCREEN-60, 39)];
    _passwordText.delegate=self;
    _passwordText.text=@"";
    _passwordText.font=DEFAULT_FONT(15);
    _passwordText.placeholder = @"输入密码";
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
    [login_btn setTitle:@"立即登录" forState:UIControlStateNormal];
    login_btn.backgroundColor=COLOR_MAIN;
    login_btn.layer.cornerRadius=4;
    login_btn.clipsToBounds=YES;
    login_btn.titleEdgeInsets=UIEdgeInsetsMake(2, 5, 0, 0);
    [login_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [login_btn addTarget:self action:@selector(postPersonLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: login_btn];

    self.view.backgroundColor=COLOR_BG_VIEW;
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
            self.model.entity.userinfo.account=[_accountText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.model.entity.userinfo.password=[_passwordText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            SPAccount *_account =[self.model convertToSpAccount:self.model.entity.userinfo];
            [[AccountManager sharedInstance] registerLoginUser:_account];
            _accountText.text=@"";
            _passwordText.text=@"";

            [self gotoHomeView];
        }
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
//    self.view.frame = rect;
//    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    CGRect frame = textField.superview.frame;
//    int offset = frame.origin.y + 70 - (self.view.frame.size.height - 216.0);//键盘高度216
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    float width = self.view.frame.size.width;
//    float height = self.view.frame.size.height;
//    if(offset > 0)
//    {
//        CGRect rect = CGRectMake(0.0f, -offset,width,height);
//        self.view.frame = rect;
//    }
//    [UIView commitAnimations];
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


-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
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


-(void)gotoHomeView{
    [APP_DELEGATE.window setRootViewController:[APP_DELEGATE.booter bootUIViewController]];
}

-(void)checkLoginState{
    Boolean isLogin=[[AccountManager sharedInstance] isLogin];
    if(isLogin){
        SPAccount *user=[[AccountManager sharedInstance] getCurrentUser];
        _accountText.text=user.user_account;
        _passwordText.text=user.user_pwd;
        
        [self performSelector:@selector(postPersonLogin) withObject:nil afterDelay:0.1];
    }
}


-(MemberLoginModel *)model{
    if(!_model){
        _model=[[MemberLoginModel alloc] init];
        _model.delegate=self;
    }
    return _model;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkLoginState];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [self stopLoadingActivityIndicator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
