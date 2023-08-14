//
//  SPBaseViewController.m
//  Youpin
//
//  Created by DouJ on 15/3/7.
//  Copyright (c) 2015年 youpin. All rights reserved.
//


#import "SPBaseViewController.h"
#import "UserLoginViewController.h"

@interface SPBaseViewController ()

@end

@implementation SPBaseViewController

+ (void)load{
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        
        
              
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[MobClick beginLogPageView:NSStringFromClass([self class])];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController setNavigationBarHidden:[self prefersNaviagtionBarHidden] animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setBarTintColor:COLOR_BG_NAVIGATION];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_WHITE,NSFontAttributeName:FONT_SIZE_NAVIGATION}];
    
    //ios 15系统
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];
        //添加背景色
        appperance.backgroundColor = COLOR_BG_NAVIGATION;
        appperance.shadowImage = [[UIImage alloc]init];
        appperance.shadowColor = nil;
        //设置字体颜色大小
        [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_WHITE,NSFontAttributeName:FONT_SIZE_NAVIGATION}];
 
        self.navigationController.navigationBar.standardAppearance = appperance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appperance;
 
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[MobClick endLogPageView:NSStringFromClass([self class])];
}


#pragma mark - init

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self != [self.navigationController.viewControllers objectAtIndex:0] ) {
        [self layoutNavigationBackButtonWithTarget:nil action:nil];
    }
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.view.backgroundColor = COLOR_BG_TABLEVIEW;
    
    int now=[[Common getNowTimeTimestamp] intValue];
    if(!APP_DELEGATE.isLocationAuthorized && (now-lastLocationTipTime)>3*60){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showLocationTip];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - UI
- (BOOL)prefersNaviagtionBarHidden{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)interfaceOrientation{
    return UIInterfaceOrientationPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate{
    return YES;
}

-(void)setTableView:(SPBaseTableView *)tableView
{
    if (tableView == nil) {
        _tableView = nil;
    }
    else if (_tableView != tableView)
    {
        _tableView = nil;
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
}

-(void)layoutNavigationBackButtonWithTarget:(id)target action:(SEL)action
{
    UIBarButtonItem *item = nil;
    if(target == nil || action == nil)
    {
        item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back_black"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
        
    }
    else
    {
        item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back_black"] style:UIBarButtonItemStylePlain target:target action:action];
        
    }
    item.imageInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    item.tintColor = COLOR_BG_TABLEVIEW;
    self.navigationItem.leftBarButtonItem = item;
}


- (void)showMaskView {
    if(_maskLayer!=nil){
        [self hideMaskView];
    }
    
    _maskLayer = [CALayer layer];
    [_maskLayer setFrame:[UIScreen mainScreen].bounds];
    [_maskLayer setBackgroundColor:[[UIColor grayColor] CGColor]];
    _maskLayer.opacity=0.4;
    [APP_DELEGATE.window.layer addSublayer:_maskLayer];
}

- (void)hideMaskView {
    if(_maskLayer!=nil){
        [_maskLayer removeFromSuperlayer];
        _maskLayer=nil;
    }
}

-(void)startLoadingActivityIndicator
{
    [self startLoadingActivityIndicatorWithText:@"加载中..."];
}

-(void)startLoadingActivityIndicatorWithText:(NSString*)title
{
    if (!self.loadingView) {
        self.loadingView = [[UIView alloc] init];
        [self.loadingView setBackgroundColor:[UIColor whiteColor]];
        [self.loadingView.layer setMasksToBounds:YES];
        [self.loadingView.layer setCornerRadius:15];
        [self.loadingView.layer setBorderColor:[COLOR_BG_TABLESEPARATE CGColor]];
        [self.loadingView.layer setBorderWidth:1];
        [self.view addSubview:self.loadingView];
        [self.loadingView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo (self.view.mas_centerX);
            make.centerY.equalTo (self.view.mas_centerY);
            make.width.equalTo(@100);
            make.height.equalTo(@100);
        }];
        
        self.loadingIndicator = [[KMActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, 60, 60) color: COLOR_MAIN];
        [self.loadingView addSubview:self.loadingIndicator];
        [self.loadingIndicator mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY).offset(-20);
            make.width.equalTo(@60);
            make.height.equalTo(@60);
            
        }];
        
        UILabel* loading = [[UILabel alloc] init];
        loading.textAlignment = NSTextAlignmentCenter;
        loading.font = DEFAULT_FONT(12);
        loading.textColor = COLOR_FONT_GRAY;
        loading.numberOfLines = 0;
        loading.tag = 100;
        [self.loadingView addSubview:loading];
        
        [loading mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo (self.loadingIndicator.mas_bottom).offset(5);
            make.centerX.equalTo(self.loadingView.mas_centerX);
            make.height.greaterThanOrEqualTo(@20);
            make.width.equalTo(@90);
        }];
        
    }
    
    UILabel* loading = (UILabel*)[self.loadingView viewWithTag:100];
    loading.text = title;
    self.loadingView.hidden = NO;
    [self.loadingIndicator startAnimating];
    [self.view bringSubviewToFront:self.loadingIndicator];
    
    [self hideNoContentView];
    [self hideNetWorkError];
}

-(void)stopLoadingActivityIndicator
{
    if(self.loadingView != nil)
    {
        [self.loadingIndicator stopAnimating];
        self.loadingView.hidden = YES;
    }
}

- (void)showSuccesWithText:(NSString *)text{
    [SVProgressHUD showSuccessWithStatus:text];
}

- (void)showFailWithText:(NSString *)text{
    [SVProgressHUD showErrorWithStatus:text];
}

-(void)showNoContentViewWithTitle:(NSString*)title subTitle:(NSString*)subTitle icon:(NSString*)imageName button:(UIButton*)button
{
    if (imageName == nil) {
        imageName = @"noContent";
    }
    
    if (self.noContentView == nil) {
        CGFloat top = [self prefersNaviagtionBarHidden]?64:0+48;
        self.noContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, top, WIDTH_SCREEN, CGRectGetHeight(self.view.bounds)-top)];
        self.noContentView.backgroundColor = [UIColor clearColor];
        self.noContentView.showsVerticalScrollIndicator = NO;
        if(self.tableView!=nil){
            [self.tableView addSubview:self.noContentView];
        }
        else{
            [self.view addSubview:self.noContentView];
        }
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 667)];
        container.tag = 100;
        container.backgroundColor = [UIColor clearColor];
        [self.noContentView addSubview:container];
        [self.noContentView setContentSize:container.bounds.size];
        
        UIImageView* noContentImageView = [[UIImageView alloc] init];
        noContentImageView.tag = 101;
        [container addSubview:noContentImageView];
        
        [noContentImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@173);
            make.centerX.equalTo(container.mas_centerX);
        }];
        
        UILabel* noContentLabel = [[UILabel alloc] init];
        noContentLabel.textAlignment = NSTextAlignmentCenter;
        noContentLabel.font = [UIFont systemFontOfSize:13];
        noContentLabel.textColor = COLOR_FONT_GRAY;
        noContentLabel.numberOfLines = 0;
        noContentLabel.tag = 102;
        [container addSubview:noContentLabel];
        
        [noContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo (noContentImageView.mas_bottom).offset(15);
            make.left.equalTo(@20);
            make.right.equalTo(@(-20));
        }];
        
        if (subTitle) {
            UILabel* subTitleLabel = [[UILabel alloc] init];
            subTitleLabel.textAlignment = NSTextAlignmentCenter;
            subTitleLabel.font = DEFAULT_FONT(12);
            subTitleLabel.textColor =  [UIColor colorWithRed:133./255. green:133./255. blue:133./255. alpha:1];
            subTitleLabel.numberOfLines = 0;
            subTitleLabel.tag = 103;
            [container addSubview:subTitleLabel];
            [subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(noContentLabel.mas_bottom).offset(12);
                make.left.equalTo(@20);
                make.right.equalTo(@(-20));
            }];

        }
        
    }
    self.noContentView.hidden = NO;
    UIView *container = [self.noContentView viewWithTag:100];
    UILabel* noContentLabel = (UILabel* )[container viewWithTag:102];
    noContentLabel.text = title;
    UILabel* subLabel = (UILabel* )[container viewWithTag:103];
    subLabel.text = subTitle;
    
    UIImageView* noContentImageView = (UIImageView*)[container viewWithTag:101];
    noContentImageView.contentMode = UIViewContentModeScaleAspectFit;
    noContentImageView.image =[UIImage imageNamed:imageName];

    
    if (button != nil)
    {
        [[container viewWithTag:104] removeFromSuperview];
        button.tag = 104;
        [container addSubview:button];
        if (subLabel) {
            CGFloat padding = subTitle?10:0;
            [button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(subLabel.mas_bottom).offset(padding);
                make.centerX.equalTo(container.mas_centerX);
                make.height.equalTo([NSNumber numberWithInteger:button.frame.size.height]);
                make.width.equalTo([NSNumber numberWithInteger:button.frame.size.width]);
            }];
        }else{
            [button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(noContentLabel.mas_bottom).offset(12);
                make.centerX.equalTo(container.mas_centerX);
                make.height.equalTo([NSNumber numberWithInteger:button.frame.size.height]);
                make.width.equalTo([NSNumber numberWithInteger:button.frame.size.width]);
            }];
        }

    }
    else {
        [[container viewWithTag:104] removeFromSuperview];
    }

    
    [self.view bringSubviewToFront:self.noContentView];

    
}
-(void)showNoContentViewWithTitle:(NSString *)title subTitle:(NSString*)subTitle icon:(NSString*)imageName
{
    [self showNoContentViewWithTitle:title subTitle:subTitle icon:imageName button:nil];
}

-(void)showNoContentViewWithTitle:(NSString*)title icon:(NSString*)imageName button:(UIButton*)button
{
    [self showNoContentViewWithTitle:title subTitle:nil  icon:imageName button:button];
}

-(void)showNoContentView
{
    [self showNoContentViewWithTitle:@"当前没有任何内容" icon:nil button:nil];
}

-(void)hideNoContentView
{
    self.noContentView.hidden = YES;
}

-(void)showNetWorkErrorWithTitle:(NSString*)title
{
    if (self.netWorkErrorView == nil) {
        CGFloat top = [self prefersNaviagtionBarHidden]?64:0;
        self.netWorkErrorView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, top, WIDTH_SCREEN, CGRectGetHeight(self.view.bounds)-top)];
        self.netWorkErrorView.backgroundColor = [UIColor clearColor];
        self.netWorkErrorView.showsVerticalScrollIndicator = NO;
        
        [self.view addSubview:self.netWorkErrorView];
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 667)];
        container.tag = 100;
        container.backgroundColor = [UIColor clearColor];
        [self.netWorkErrorView addSubview:container];
        [self.netWorkErrorView setContentSize:container.bounds.size];
        
        UIImageView *tipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wifi"]];
        [container addSubview:tipImageView];
        [tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(container);
            make.top.equalTo(@173);
            make.size.mas_equalTo(CGSizeMake(100, 80));
        }];

        UILabel* netErrorLabel = [[UILabel alloc] init];
        netErrorLabel.textAlignment = NSTextAlignmentCenter;
        netErrorLabel.font = DEFAULT_FONT(14);
        netErrorLabel.textColor = COLOR_FONT_GRAY;
        netErrorLabel.numberOfLines = 0;
        netErrorLabel.tag = 101;
        [container addSubview:netErrorLabel];
        
        [netErrorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo (tipImageView.mas_bottom).offset(16);
            make.left.equalTo(@20);
            make.right.equalTo(@(-20));
        }];

        UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reloadBtn.titleLabel.font =DEFAULT_FONT(12);
        [reloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [reloadBtn addTarget:self action:@selector(onReloadBtnTap) forControlEvents:UIControlEventTouchUpInside];
        reloadBtn.layer.cornerRadius = 14;
        reloadBtn.clipsToBounds = YES;
        reloadBtn.backgroundColor = COLOR_BTN_MAIN;
        [container addSubview:reloadBtn];
        
        [reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(container);
            make.size.mas_equalTo(CGSizeMake(120, 30));
            make.top.equalTo(netErrorLabel.mas_bottom).with.offset(16);
        }];
        
        UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        settingBtn.titleLabel.font = DEFAULT_FONT(12);
        [settingBtn setTitleColor:COLOR_FONT_BLACK forState:UIControlStateNormal];
        [settingBtn setTitle:@"立即设置" forState:UIControlStateNormal];
        [settingBtn addTarget:self action:@selector(onNetworkSetting) forControlEvents:UIControlEventTouchUpInside];
        settingBtn.layer.cornerRadius = 14;
        settingBtn.clipsToBounds = YES;
        settingBtn.backgroundColor = COLOR_BTN_LIGHTGRAY;
        [container addSubview:settingBtn];
        
        [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(container);
            make.size.mas_equalTo(CGSizeMake(120, 30));
            make.top.equalTo(reloadBtn.mas_bottom).with.offset(16);
        }];
    }
    UILabel* errorLabel = (UILabel* )[[self.netWorkErrorView viewWithTag:100] viewWithTag:101];
    errorLabel.text = title;
    self.netWorkErrorView.hidden = NO;
    [self.view bringSubviewToFront:self.netWorkErrorView];
}

-(void)showNetWorkError
{
    [self showNetWorkErrorWithTitle:@"当前网络不可用，\n\n请在设置-无线局域网/蜂窝网络中\n检查你的网络连接。"];
}

-(void)hideNetWorkError
{
    self.netWorkErrorView.hidden = YES;
}

- (void)showToastWithText:(NSString *)text{
    
    UIView *view = self.view;
    if (self.navigationController) {
        view = self.navigationController.view;
    }
    [view makeToast:text duration:2 position:CSToastPositionCenter];

}
- (void)showToastTopWithText:(NSString *)text{
    UIView *view = self.view;
    if (self.navigationController) {
        view = self.navigationController.view;
    }
    [view makeToast:text duration:2 position:CSToastPositionTop];
}

- (void)showToastBottomWithText:(NSString *)text{
    UIView *view = self.view;
    if (self.navigationController) {
        view = self.navigationController.view;
    }
    [view makeToast:text duration:2 position:CSToastPositionBottom];
}

-(void)reloadTableViewDataFadeAnimation:(BOOL)animation
{
    self.tableView.hidden = NO;
    if (animation) {
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.alpha  = 1.f;
        }];
    }
    [self.tableView reloadData];
    
}

 - (void)showLocationTip {
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未开启实时配送定位" preferredStyle:UIAlertControllerStyleAlert];
    // 确定按钮监听
     UIAlertAction *okBtn = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
         NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
         if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
             if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                 [[UIApplication sharedApplication] openURL:settingsURL options:@{}  completionHandler:nil];
             }
         }
         lastLocationTipTime=[[Common getNowTimeTimestamp] intValue];
    }];
    
    UIAlertAction *cancelBtn =[UIAlertAction actionWithTitle:@"稍后" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        lastLocationTipTime=[[Common getNowTimeTimestamp] intValue];
    }];
    //添加按钮到弹出上
    [alert addAction:okBtn];
    [alert addAction:cancelBtn];
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - tableView dataSource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark -event
//server 返回
-(void)onResponse:(SPBaseModel*)model isSuccess:(BOOL)success
{
    [self stopLoadingActivityIndicator];
    if (success) {
        [self hideNoContentView];
        [self hideNetWorkError];
    }
}

-(void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onNetError
{
    [self stopLoadingActivityIndicator];
}

- (void)onNetworkSetting{
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        NSURL * url = [NSURL URLWithString:OPEN_WIFI_SETTING_URL];
//        if([[UIApplication sharedApplication] canOpenURL:url]) {
//            [[UIApplication sharedApplication] openURL:url];
//        }
//    }
}

-(void)onReloadBtnTap
{
    
}

#pragma mark 检查登录状态
- (BOOL)checkLoginStatus{
    if (![[AccountManager sharedInstance] isLogin]) {
        [self onUserNotLogin];
        return NO;
    }
    return YES;
}

#pragma mark 前往登录界面
-(void)onUserNotLogin
{
    [APP_DELEGATE.window setRootViewController:[[SPNavigationController alloc] initWithRootViewController:[[UserLoginViewController alloc] init]]];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
