//
//  YPWebViewController.m
//  Youpin
//
//  Created by douj on 15/4/29.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import "WebViewController.h"
#import "SPRedirect.h"
#import "AccountManager.h"
#import <MJRefresh/UIScrollView+MJRefresh.h>

@interface WebViewController ()<UIWebViewDelegate>

@property (strong,nonatomic) UIWebView* webView;
@property (strong,nonatomic) NSString* rightBtnAction;
@property (copy,nonatomic) NSArray* webImages;

@end

@implementation WebViewController

- (void)dealloc{
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView removeFromSuperview];
    _webView.delegate = nil;
    [_webView stopLoading];
    _webView = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!self.navigationController){
        //加上导航条
        [self createNavigation];
    }
    [self setNavigation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self load];
    
    [self.webView.scrollView setBackgroundColor:COLOR_WHITE];
}

-(void)createNavigation{
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, IOS7?64:44)];
    navBar.barStyle = UIBarStyleDefault;
    _navigationItem=[[UINavigationItem alloc] init];
    
    _titleLbl=[[UILabel alloc] init];
    _titleLbl.frame=CGRectMake(0, 3, 240, 28);
    _titleLbl.text=APP_NAME;
    _titleLbl.backgroundColor=COLOR_CLEAR;
    _titleLbl.font=FONT_SIZE_NAVIGATION;
    _titleLbl.textColor=COLOR_BLACK;
    _titleLbl.textAlignment=NSTextAlignmentCenter;
    _navigationItem.titleView=_titleLbl;
    
    _leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    [_leftButton setFrame:CGRectMake(0, 0, 20, 20)];
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"btn_back_black"] forState:UIControlStateNormal];
    UIBarButtonItem *left_Item=[[UIBarButtonItem alloc]initWithCustomView:_leftButton];
    _navigationItem.leftBarButtonItem=left_Item;
    
    [navBar pushNavigationItem:_navigationItem animated:YES];
    [navBar setBackgroundColor:COLOR_BG_NAVIGATION_WHITE];
    [self.view addSubview:navBar];
}


-(void)setNavigation{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController.navigationBar setBarTintColor:COLOR_BG_NAVIGATION_WHITE];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_BLACK,NSFontAttributeName:FONT_SIZE_NAVIGATION}];
    
    
    
    UIBarButtonItem *item = nil;
    
    item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back_black"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    item.imageInsets = UIEdgeInsetsMake(0, -12, 0, 0);
    item.tintColor = COLOR_BLACK;
    self.navigationItem.leftBarButtonItem = item;
}

- (void)load {
    if (self.url) {
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [self.webView loadRequest:request];
        [self startLoadingActivityIndicator];
    }
}

- (void)reload {

    if (!self.webView.request.URL.absoluteString || [self.webView.request.URL.absoluteString isEmpty]) {
        [self showFailWithText:@"错误的请求"];
    }else{
//        [self hideNoContentView];
        [self.webView setHidden:NO];
    }
    [self.webView reload];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //将url转换为string
    //NSString *requestString = [[request URL] absoluteString];
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self stopLoadingActivityIndicator];
    [self.webView setHidden:NO];
    [self.webView.scrollView.mj_header endRefreshing];
    
    [self setupWebNavigationItems];
    [self setupWebSupportRefresh];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self stopLoadingActivityIndicator];
    [self.webView.scrollView.mj_header endRefreshing];
    
}

#pragma mark - WebView Support
- (void)setupWebNavigationItems{
    
    if ([_webView stringByEvaluatingJavaScriptFromString:@"document.title"]) {
        if(!self.navigationController){
            _titleLbl.text = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        }
        else{
            self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        }
    }
    
}

- (void)setupWebSupportRefresh{
    // 支持下拉刷新
    NSString *supportRefresh = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('supportRefresh')[0].getAttribute('refresh')"];
    if (supportRefresh && supportRefresh.length > 0) {
        __weak WebViewController *mSelf = self;
        [self.webView.scrollView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [mSelf reload];
        }]];
    }
}


- (void)onBack {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back_black"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
        backItem.imageInsets = UIEdgeInsetsMake(0, -12, 0, 0);
        
        UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(onClose)];
        [backItem setTintColor:COLOR_BLACK];
        [closeItem setTintColor:COLOR_BLACK];
        
        if(!self.navigationController){
            [_navigationItem setLeftBarButtonItems:@[backItem, closeItem]];
        }
        else{
            [self.navigationItem setLeftBarButtonItems:@[backItem, closeItem]];
        }
    } else if(self.navigationController.viewControllers.count == 1){
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else if(self.navigationController){
        [self.navigationController popViewControllerAnimated:YES];
    } else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)onClose {
    if(self.navigationController.viewControllers.count == 1){
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else if(self.navigationController){
        [self.navigationController popViewControllerAnimated:YES];
    } else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(UIWebView *)webView{
    if(!_webView){
        _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, (!self.navigationController?64:0), WIDTH_SCREEN, HEIGHT_SCREEN-64)];
        _webView.scrollView.showsVerticalScrollIndicator=YES;
        _webView.scrollView.showsHorizontalScrollIndicator=NO;
        _webView.scrollView.bounces=YES;
        _webView.opaque = NO;
        _webView.delegate=self;
        _webView.backgroundColor=[UIColor clearColor];
        _webView.scalesPageToFit= YES;//自动对页面进行缩放以适应屏幕

        [self.view addSubview:_webView];
        
        // remove shadow view when drag web view
        for (UIView *subView in [_webView subviews]) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                for (UIView *shadowView in [subView subviews]) {
                    if ([shadowView isKindOfClass:[UIImageView class]]) {
                        shadowView.hidden = YES;
                    }
                }
            }
        }
    }
    return _webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
