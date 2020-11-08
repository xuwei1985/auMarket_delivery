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
        [self initUI];
        [self initData];
    }
    return self;
}

-(void)initUI{
    [self setNavigation];
    [self createLoginUI];
}

-(void)initData{
    canGetCode=YES;
    
    Boolean isLogin=[[AccountManager sharedInstance] isLogin];
    if(!isLogin){
        [self startLoadingActivityIndicator];
        [self.model getVerifyMobiles];
    }
}


-(void)setNavigation{
    self.title=@"账号登录";
}

-(void)createLoginUI{
    int offset=30;
    
    UIImageView *lineView;
    
    UIView *loginView=[[UIView alloc] initWithFrame:CGRectMake(0, 20+offset, WIDTH_SCREEN, 196)];
    loginView.backgroundColor=COLOR_BG_WHITE;
    [self.view addSubview:loginView];
    
    //第一输入区View
    UIImageView *inputView1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 48)];
    inputView1.backgroundColor=COLOR_BG_WHITE;
    inputView1.userInteractionEnabled=YES;
    inputView1.opaque=YES;
    [loginView addSubview:inputView1];
    
    lineView=[[UIImageView alloc] initWithFrame:CGRectMake(0, inputView1.frame.size.height, inputView1.frame.size.width, 1)];
    lineView.image=[UIImage imageNamed:@"grayline"];
    lineView.opaque=YES;
    [inputView1 addSubview:lineView];
    
    //第二输入区View
    UIImageView *inputView2=[[UIImageView alloc] initWithFrame:CGRectMake(0, 49, WIDTH_SCREEN, 48)];
    inputView2.backgroundColor=COLOR_BG_WHITE;
    inputView2.userInteractionEnabled=YES;
    inputView2.opaque=YES;
    [loginView addSubview:inputView2];
    
    lineView=[[UIImageView alloc] initWithFrame:CGRectMake(0, inputView2.frame.size.height, inputView2.frame.size.width, 1)];
    lineView.image=[UIImage imageNamed:@"grayline"];
    lineView.opaque=YES;
    [inputView2 addSubview:lineView];
    
    //第三输入区View
    UIImageView *inputView3=[[UIImageView alloc] initWithFrame:CGRectMake(0, 98, WIDTH_SCREEN, 48)];
    inputView3.backgroundColor=COLOR_BG_WHITE;
    inputView3.userInteractionEnabled=YES;
    inputView3.opaque=YES;
    [loginView addSubview:inputView3];
    
    lineView=[[UIImageView alloc] initWithFrame:CGRectMake(0, inputView3.frame.size.height, inputView3.frame.size.width, 1)];
    lineView.image=[UIImage imageNamed:@"grayline"];
    lineView.opaque=YES;
    [inputView3 addSubview:lineView];
    
    //第四输入区View
    UIImageView *inputView4=[[UIImageView alloc] initWithFrame:CGRectMake(0, 147, WIDTH_SCREEN, 48)];
    inputView4.backgroundColor=COLOR_BG_WHITE;
    inputView4.userInteractionEnabled=YES;
    inputView4.opaque=YES;
    [loginView addSubview:inputView4];
    
    lineView=[[UIImageView alloc] initWithFrame:CGRectMake(0, inputView4.frame.size.height, inputView4.frame.size.width, 1)];
    lineView.image=[UIImage imageNamed:@"grayline"];
    lineView.opaque=YES;
    [inputView4 addSubview:lineView];
    
    UIImageView *accountIcon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 24, 22)];
    accountIcon.image=[UIImage imageNamed:@"account_icon_black"];
    [inputView1 addSubview:accountIcon];
    
    UIImageView *pwdIcon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 25, 25)];
    pwdIcon.image=[UIImage imageNamed:@"pwd_icon_black"];
    [inputView2 addSubview:pwdIcon];
    
    UIImageView *verIcon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 25, 25)];
    verIcon.image=[UIImage imageNamed:@"pwd_icon_black"];
    [inputView3 addSubview:verIcon];
    
    UIImageView *codeIcon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 25, 25)];
    codeIcon.image=[UIImage imageNamed:@"pwd_icon_black"];
    [inputView4 addSubview:codeIcon];
    
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
    
    _lbl_verify_mobile=[[UILabel alloc] init];
    _lbl_verify_mobile.frame=CGRectMake(40, 6, WIDTH_SCREEN-60, 39);
    _lbl_verify_mobile.text=@"选择验证手机号";
    _lbl_verify_mobile.font=DEFAULT_FONT(15);
    _lbl_verify_mobile.textColor=RGBCOLOR(185, 185, 185);
    _lbl_verify_mobile.userInteractionEnabled=YES;
    _lbl_verify_mobile.textAlignment=NSTextAlignmentLeft;
    [inputView3 addSubview:_lbl_verify_mobile];
    [inputView3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickVerifyMobile:)]];
    
    _verifyText = [[UITextField alloc] initWithFrame:CGRectMake(40, 6, 0, 0)];
    _verifyText.delegate=self;
    _verifyText.text=@"";
    _verifyText.font=DEFAULT_FONT(15);
    _verifyText.placeholder = @"选择验证手机号";
    _verifyText.textColor=RGBCOLOR(45, 45, 45);
    _verifyText.backgroundColor=[UIColor clearColor];
    _verifyText.returnKeyType = UIReturnKeyDone;
    _verifyText.keyboardType= UIKeyboardTypeDefault;
    _verifyText.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
    _verifyText.autocapitalizationType=UITextAutocapitalizationTypeNone;
    [inputView3 addSubview:_verifyText];
    
    reSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reSendBtn.frame = CGRectMake(WIDTH_SCREEN-60-24, 0, 84, 48);
    reSendBtn.backgroundColor = COLOR_MAIN;
    reSendBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    reSendBtn.titleLabel.font = FONT_SIZE_SMALL;
    [reSendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [reSendBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    reSendBtn.userInteractionEnabled=YES;
    [reSendBtn addTarget:self action:@selector(requestSmsCode) forControlEvents:UIControlEventTouchUpInside];
    [inputView3 addSubview:reSendBtn];
    
    _picker_mobile=[[UIPickerView alloc] init];
    _picker_mobile.frame = CGRectMake(0, self.view.frame.size.height-180, WIDTH_SCREEN, 180);
    _picker_mobile.showsSelectionIndicator = YES;
    _picker_mobile.backgroundColor=COLOR_BG_VIEW;
    _picker_mobile.delegate=self;
    _picker_mobile.dataSource=self;
    _picker_mobile.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _verifyText.inputView=_picker_mobile;
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlackTranslucent;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.barTintColor=COLOR_BTN_LIGHTGRAY;
    keyboardDoneButtonView.tintColor = COLOR_BLACK;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace  target: nil action: nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(regionPickerDone:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:fixedButton,doneButton, nil]];
    _verifyText.inputAccessoryView = keyboardDoneButtonView;
    
    _codeText = [[UITextField alloc] initWithFrame:CGRectMake(40, 6, WIDTH_SCREEN-60, 39)];
    _codeText.delegate=self;
    _codeText.text=@"";
    _codeText.font=DEFAULT_FONT(15);
    _codeText.placeholder = @"输入验证码";
    _codeText.textColor=RGBCOLOR(45, 45, 45);
    _codeText.backgroundColor=[UIColor clearColor];
    _codeText.returnKeyType =UIReturnKeyDone;
    _codeText.keyboardType= UIKeyboardTypeDefault;
    _codeText.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
    _codeText.autocapitalizationType=UITextAutocapitalizationTypeNone;
    [inputView4 addSubview:_codeText];
    

    UIButton *login_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    login_btn.frame = CGRectMake(20, (IOS7?250:230)+offset, (WIDTH_SCREEN-40), 44);
    login_btn.titleLabel.font=DEFAULT_FONT(16);;
    [login_btn setTitle:@"立即登录" forState:UIControlStateNormal];
    login_btn.backgroundColor=COLOR_MAIN;
    login_btn.layer.cornerRadius=21;
    login_btn.clipsToBounds=YES;
    login_btn.titleEdgeInsets=UIEdgeInsetsMake(2, 5, 0, 0);
    [login_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [login_btn addTarget:self action:@selector(postPersonLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: login_btn];

    self.view.backgroundColor=COLOR_BG_VIEW;
}

-(void)pickVerifyMobile:(id)sender{
    if(_mobileArray!=nil&&_mobileArray.count>0){
        [_verifyText becomeFirstResponder];
    }else{
        [self showToastWithText:@"无验证手机数据"];
    }
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
//    else if ([_codeText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length<=0) {
//        [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
//        return NO;
//    }
    return YES;
}

//发送登录请求
-(void)postPersonLogin{
    NSString *_account=[_accountText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *_password=[_passwordText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *_code=[_codeText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [self resignAllTextField];
    
    if ([self checkForm]) {
        [self startLoadingActivityIndicatorWithText:@"正在请求登录..."];
        [self.model loginWithUsername:_account andPassword:_password andMobile:verify_mobile andCode:_code];
    }
}

//请求验证短信验证码
-(void)requestSmsCode{
    if(!isRequesting&&canGetCode){
        isRequesting=YES;
        if([[verify_mobile stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0){
            [self handleBackgroundTap:nil];
            [self startLoadingActivityIndicatorWithText:@"正在请求数据..."];
            [self.model getSmsCode:[[verify_mobile stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString]];
        }
        else{
            isRequesting=NO;
            [self showToastWithText:@"请选择验证手机号"];
        }
    }
}

-(void)onResponse:(SPBaseModel *)model isSuccess:(BOOL)isSuccess{
    [self stopLoadingActivityIndicator];
    
    if(self.model.entity!=nil&&self.model.requestTag==1001){//普通登录
        if(isSuccess){
           [self showSuccesWithText:@"登录成功"];
           self.model.entity.userinfo.account=[_accountText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
           self.model.entity.userinfo.password=[_passwordText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
           SPAccount *_account =[self.model convertToSpAccount:self.model.entity.userinfo];
           [[AccountManager sharedInstance] registerLoginUser:_account];
           _accountText.text=@"";
           _passwordText.text=@"";
           _verifyText.text=@"";
           _codeText.text=@"";
            verify_mobile=@"";
           [self gotoHomeView];
        }
        
    }else if(model.requestTag==1004){
        _mobileArray=[NSMutableArray arrayWithArray:self.model.verify_entity.verify_account_list];
    }
    else if(model.requestTag==1005){
        if([self.model.sEntity.status intValue]==0){//短信验证码发送成功
            [timer invalidate];
            timer = nil;
            [self initTimer:[self.model.sEntity.keeptime intValue]];
            [self showToastWithText:@"验证码已发送"];
        }else{
            [self showToastWithText:@"验证码发送失败"];
        }
        isRequesting=NO;
    }
   
}


- (void)initTimer:(int)keeptime
{
    timeCount = (keeptime>0)?keeptime:60;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCountDown) userInfo:nil repeats:YES];
}

- (void)timeCountDown
{
    if (timeCount <= 0) {
        [timer invalidate];
        timer = nil;
        canGetCode = YES;
        [reSendBtn setTitle:[NSString stringWithFormat:@"重发验证码"] forState:UIControlStateNormal];
    }
    else
    {
        canGetCode = NO;
        timeCount--;
        [reSendBtn setTitle:[NSString stringWithFormat:@"%ld秒后刷新",(long)timeCount] forState:UIControlStateNormal];
    }
}


-(void)regionPickerDone:(id)sender{
    NSInteger row=[_picker_mobile selectedRowInComponent:0];

    verify_mobile=((VerifyMobileEntity *)[_mobileArray objectAtIndex:row]).mobile;
    NSString *numberString = [((VerifyMobileEntity *)[_mobileArray objectAtIndex:row]).mobile stringByReplacingCharactersInRange:NSMakeRange(4, 4) withString:@"****"];
    _lbl_verify_mobile.text=numberString;
    _lbl_verify_mobile.textColor=RGBCOLOR(48, 48, 48);

    [_verifyText resignFirstResponder];
}


#pragma mark - picker view delegate

/* return column of pickerview*/
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

/*return row number*/
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView==_picker_mobile){
        return _mobileArray.count;
    }
    return 0;
}

/*return component row str*/
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView==_picker_mobile){
        NSString *numberString = [((VerifyMobileEntity *)[_mobileArray objectAtIndex:row]).mobile stringByReplacingCharactersInRange:NSMakeRange(4, 4) withString:@"****"];
        NSString *valueStr=[NSString stringWithFormat:@"%@ %@",((VerifyMobileEntity *)[_mobileArray objectAtIndex:row]).nickname,numberString];
        return valueStr;
    }
    return @"";
}

-(void)pickerDoneClicked:(id)sender{
    [self regionPickerDone:sender];
    [self putDownTextField];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor=16.0;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:FONT_SIZE_BIG];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

//返回指定列的宽度
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return WIDTH_SCREEN;
}

-(CGFloat) pickerView:(UIPickerView*)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

/*choose com is component,row's function*/
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView==_picker_mobile){
        NSString *numberString = [((VerifyMobileEntity *)[_mobileArray objectAtIndex:row]).mobile stringByReplacingCharactersInRange:NSMakeRange(4, 4) withString:@"****"];
        _lbl_verify_mobile.text=numberString;
        verify_mobile=((VerifyMobileEntity *)[_mobileArray objectAtIndex:row]).mobile;
        _lbl_verify_mobile.textColor=RGBCOLOR(48, 48, 48);
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


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField==_verifyText){
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        keyboardDoneButtonView.barStyle = UIBarStyleDefault;
        keyboardDoneButtonView.translucent = YES;
        keyboardDoneButtonView.tintColor = RGBCOLOR(165, 165, 165);
        [keyboardDoneButtonView sizeToFit];
        
        UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                                      target: nil
                                                                                      action: nil];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                       style:UIBarButtonItemStyleBordered target:self
                                                                      action:@selector(pickerDoneClicked:)];
        doneButton.tintColor=[Common hexColor:@"#49B554"];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:fixedButton,doneButton, nil]];
        textField.inputAccessoryView = keyboardDoneButtonView;
    }
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

-(void)putUpTextField:(int)kHeight{
    if (kHeight==0) {
        kHeight=216;//默认键盘高度
    }
    CGRect rect =CGRectMake(0, HEIGHT_SCREEN-68-kHeight, WIDTH_SCREEN, 68);
    NSTimeInterval animationDuration = 0.3f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame = rect;
    [UIView commitAnimations];
}

-(void)putDownTextField{
    [self resignAllTextField];
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, HEIGHT_STATUS_AND_NAVIGATION_BAR, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
}


/* 点击背景时关闭键盘 **/
-(void)handleBackgroundTap:(UITapGestureRecognizer *)sender{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, HEIGHT_STATUS_AND_NAVIGATION_BAR, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    
    [self resignAllTextField];
}

-(void)resignAllTextField{
    [_accountText resignFirstResponder];
    [_passwordText resignFirstResponder];
    [_verifyText resignFirstResponder];
    [_codeText resignFirstResponder];
}


-(void)gotoHomeView{
    [APP_DELEGATE.window setRootViewController:[APP_DELEGATE.booter bootUIViewController]];
}

-(void)checkLoginState{
    Boolean isLogin=[[AccountManager sharedInstance] isLogin];
    if(isLogin){
        SPAccount *user=[[AccountManager sharedInstance] getCurrentUser];
        self.model.entity.userinfo=[MemberEntity new];
        self.model.entity.userinfo.nickname=user.user_nickname;
        self.model.entity.userinfo.account=user.user_account;
        self.model.entity.userinfo.password=user.user_pwd;
        self.model.entity.userinfo.userid=user.user_id;
        self.model.entity.userinfo.token=user.user_token;
        SPAccount *_account =[self.model convertToSpAccount:self.model.entity.userinfo];
        [[AccountManager sharedInstance] registerLoginUser:_account];
        [self gotoHomeView];
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
