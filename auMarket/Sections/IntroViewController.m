//
//  YPIntroViewController.m
//  pgy
//
//  Created by douj on 15/5/31.
//  Copyright (c) 2015年 com.xuwei. All rights reserved.
//

#import "IntroViewController.h"
#import "PunchScrollView.h"
#import "UIDevice-Hardware.h"
#import "AppDelegate.h"
#import "AccountManager.h"
#import "HomeViewController.h"

static NSInteger const YPIntroPageCount = 2;

@interface IntroViewController () <PunchScrollViewDataSource,PunchScrollViewDelegate>

@property (nonatomic,strong) PunchScrollView* scrollView;
@property (nonatomic,strong) UIButton *passButton;

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

-(void)initUI{
    [self createScrollView];
    [self createSkipView];
    
    self.scrollView.dataSource = self;
    self.scrollView.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)createScrollView{
    [self.view addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN, HEIGHT_SCREEN));
    }];
    
    
}

-(void)createSkipView{
    //skip button
    [self.view addSubview:self.passButton];
    [self.passButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(25);
    }];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)onPass{
    [APP_DELEGATE bootMainVc];
}

- (void)punchScrollView:(PunchScrollView*)scrollView didTapOnPage:(UIView*)view atIndexPath:(NSIndexPath*)indexPath
{
    if(indexPath.row == YPIntroPageCount-1)
    {
        [APP_DELEGATE bootMainVc];
        UIViewController *vc = [AppDelegate getNavigationController].viewControllers.lastObject;
        if ([vc isKindOfClass:[SPBaseViewController class]]) {
            if (![[AccountManager sharedInstance] isLogin]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [(SPBaseViewController*)vc onUserNotLogin];
                });
            }
        }
    }
}

- (NSInteger)punchscrollView:(PunchScrollView *)scrollView numberOfPagesInSection:(NSInteger)section
{
    return YPIntroPageCount;
}

- (void)punchScrollView:(PunchScrollView *)scrollView pageChanged:(NSIndexPath *)indexPath {
    
}


- (UIView*)punchScrollView:(PunchScrollView*)scrollView viewForPageAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView* page = (UIImageView*)[scrollView dequeueRecycledPage];
    
    if (page == nil)
    {
        page = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
        
    }
    
    NSUInteger platform = [[UIDevice currentDevice] tbcPlatformType];
    page.frame = scrollView.bounds;
    
    NSString* imageName = [NSString stringWithFormat:@"app_guide_%ld",(long)indexPath.row + 1];
    if (platform == UIDevice4SiPhone || platform == UIDevice4iPhone) {
        imageName = [NSString stringWithFormat:@"app_guide_4_%ld",(long)indexPath.row + 1];
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    page.image = image;
//    NSLog(@"app guide w:%lf  h: %lf",image.size.width,image.size.height);
    return page;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView.contentOffset.x > (SCREEN_WIDTH * 2 + 10)) {
//        [[AppDelegate getAppDelegate] bootMainVc];
//    }
}

- (UIButton *)passButton{
    if (!_passButton) {
        _passButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"app_guide_pass"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onPass) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _passButton;
}

-(PunchScrollView *)scrollView{
    if(_scrollView==nil){
        _scrollView=[[PunchScrollView alloc] initWithFrame:CGRectZero];
    }
    return _scrollView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
