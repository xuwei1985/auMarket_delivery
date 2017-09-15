//
//  YPUIBooter.m
//  Youpin
//
//  Created by douj on 15/4/15.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import "Booter.h"
#import "HomeViewController.h"
#import "UserCenterViewController.h"
#import "AdPageViewController.h"
#import "TaskListViewController.h"

@interface Booter() 
{
    HomeViewController* homeViewController;
    TaskListViewController* taskListViewController;
    UserCenterViewController* userCenterViewController;
}
@end

@implementation Booter

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self checkIfLoginAccountIsValid];
        APP_DELEGATE.isWorking=[USER_DEFAULT boolForKey:@"isWorking"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAccountUpdate:) name:ACCOUNT_UPDATE_NOTIFICATION object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//引导页
-(UIViewController*)getIntroViewController
{
    return [[IntroViewController alloc] init];
}

//主视图控制器
-(UIViewController*)bootUIViewController
{
    homeViewController = [[HomeViewController alloc] init];
    homeViewController.hidesBottomBarWhenPushed = NO;
    homeViewController.tabBarItem = [[SPTabBarItem alloc] initWithTitle:@"地图模式" image:[UIImage imageNamed:@"1_53"] selectedImage:[UIImage imageNamed:@"1_72"]];
    
    taskListViewController = [[TaskListViewController alloc] init];
    taskListViewController.hidesBottomBarWhenPushed = NO;
    taskListViewController.tabBarItem = [[SPTabBarItem alloc] initWithTitle:@"列表模式" image:[UIImage imageNamed:@"1_56"] selectedImage:[UIImage imageNamed:@"1_65"]];
    
    userCenterViewController = [[UserCenterViewController alloc] init];
    userCenterViewController.hidesBottomBarWhenPushed = NO;
    userCenterViewController.tabBarItem = [[SPTabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"1_69"] selectedImage:[UIImage imageNamed:@"1_59"]];
    
    SPNavigationController *navHomeViewController = [[SPNavigationController alloc] initWithRootViewController:homeViewController];
    SPNavigationController *navTaskListViewController = [[SPNavigationController alloc] initWithRootViewController:taskListViewController];
    SPNavigationController *navUserCenterViewController = [[SPNavigationController alloc] initWithRootViewController:userCenterViewController];

  
    self.tabBarController = [[SPTabBarController alloc] init];
    self.tabBarController.tabBar.translucent = NO;
    self.tabBarController.tabBar.tintColor = COLOR_FONT_MAIN;
    [self.tabBarController setViewControllers:@[navHomeViewController,navTaskListViewController,navUserCenterViewController]];
    self.tabBarController.selectedIndex = 0;
    self.tabBarController.delegate = self;
    
    //设置tabBarItem的文字属性
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_FONT_GRAY,NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_FONT_MAIN,NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateSelected];
    
    for (UINavigationController* navVc in self.tabBarController.viewControllers) {
        navVc.navigationBar.barTintColor = [UIColor whiteColor];
        navVc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:COLOR_FONT_BLACK,NSFontAttributeName:[UIFont systemFontOfSize:18]};
    }
    
    
    [BadgeManager sharedInstance].barItems = self.tabBarController.tabBar.items;
    return self.tabBarController;
}

//主视图控制器的代理事件
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    NSString *index = [NSString stringWithFormat:@"%d",(int)tabBarController.selectedIndex];
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeCurrentTabNotification object:index];
    //[MobClick event:@"tab" attributes:@{@"category":index}];
}

- (void)pullMessageManagerDidReceiveMessage:(NSNotification*)aNotification{

    NSString *badgeValue = 0;//[SPPullMessageManager sharedInstance].messageCount;
    if ([badgeValue isEqualToString:@"0"]) {
        badgeValue = nil;
    }
    [[BadgeManager sharedInstance] setBadgeValue:badgeValue forIndex:3];
}

- (void)onAccountUpdate:(NSNotification*)aNotification{

    //[[SPPullMessageManager sharedInstance] resetPullMessager];
    
}

- (UIViewController *)bootStartPage {
    NSDictionary *startPages = [[YPSyncManager sharedInstance] getData:@"start_page"];
    NSArray *pages = [startPages objectForKey:@"pages"];
    if (![pages isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    AdPageViewController *startPageVC = nil;
    for (NSDictionary *startPage in pages) {
        long long startTime = [[startPage numberAtPath:@"start_time"] longLongValue];
        long long endTime = [[startPage numberAtPath:@"end_time"] longLongValue];
        long long currentTime = [[NSDate date] timeIntervalSince1970];
        NSString *imageUrl = [startPage stringAtPath:@"image_url"];
        NSURL *url = [NSURL URLWithString:imageUrl];
        BOOL isInCache = [[SDWebImageManager sharedManager] cachedImageExistsForURL:url];
        if (currentTime >= startTime && currentTime < endTime && isInCache) {
            UIImage *image = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:url]];
            startPageVC = [[AdPageViewController alloc] init];
            [startPageVC setImage:image];
        }
        if (!isInCache) {
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
            }];
        }
    }
    return nil;
}


-(void)bootGoogleMap{
    [GMSServices provideAPIKey:GOOGLE_APPKEY];
}
//启动友盟
-(void)bootUMeng
{
    #ifdef DEBUG
    [UMAnalyticsConfig sharedInstance].ePolicy=REALTIME;
    #else
    [UMAnalyticsConfig sharedInstance].ePolicy=BATCH;
    //加密
    [UMAnalyticsConfig sharedInstance] setEncryptEnabled:YES];
    #endif
    
    [MobClick setCrashReportEnabled:YES];
    UMConfigInstance.appKey = UMENG_KEY;
    UMConfigInstance.channelId = UMENG_CHANNEL_ID;
    [MobClick setAppVersion:SYSTEM_VERSION_STRING];
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！

}

//启动极光推送
-(void)bootJPush:(NSDictionary *)launchOptions{
    // Required
    #if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    #else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    #endif
    // Required
    [JPUSHService setupWithOption:launchOptions appKey:JPUSH_KEY channel:JPUSH_CHANNEL apsForProduction:0];//0:开发1:线上
}



//启动网络监测
- (void)bootReachability{
    //创建网络监听管理者对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //设置监听
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未识别的网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"不可达的网络(未连接)");
                [SVProgressHUD showInfoWithStatus:@"当前网络不可用,请检查你的网络连接。"];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"2G,3G,4G...的网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi的网络");
                break;
            default:
                break;
        }
    }];
    //开始监听
    [manager startMonitoring];
}

- (void)checkIfLoginAccountIsValid{
    SPAccount *acount = [[AccountManager sharedInstance] getCurrentUser];
    if (!acount.user_id || [acount.user_id isEmpty]) {
        [[AccountManager sharedInstance] unRegisterLoginUser];//注销用户
    }else{
        [[AccountManager sharedInstance] updateUserStatusIfNeeded];
    }
}

//处理工作状态
-(void)handlerWorkingState:(BOOL)isWorking{
    [self.loginModel setDeliverStatus:(isWorking?@"1":@"0")];
    APP_DELEGATE.isWorking=isWorking;
    [USER_DEFAULT setBool:isWorking forKey:@"isWorking"];
    [USER_DEFAULT synchronize];
    
}

//远程消息的注册
-(void)registRemoteNotification{
    if (SYSTEM_VERSION_GREATER_THAN(@"8.0"))
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

-(void)sync
{
    //同步sync接口
    [[YPSyncManager sharedInstance] load];
    //检查更新
    //[YPUpdateChecker sharedInstance];
}

-(void)loadTaskList
{
    [self.taskModel loadTaskList];
}

- (BOOL)onHandleOpenURL:(NSURL *)url {
    return YES;
}

-(UINavigationController*)navigationController
{
    UINavigationController *nav = (UINavigationController*)self.tabBarController.selectedViewController;
    if ([nav.presentedViewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController*)nav.presentedViewController;
    }
   return nav;
}

-(void)onResponse:(SPBaseModel*)model isSuccess:(BOOL)isSuccess{
    if(model==self.taskModel){
        if(isSuccess){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                self.tasklist_delivering= [self.taskModel getTasksByStatus:Delivery_Status_Delivering];
                self.tasklist_finished= [self.taskModel getTasksByStatus:Delivery_Status_Finished];
                self.tasklist_failed= [self.taskModel getTasksByStatus:Delivery_Status_Failed];
                self.tasklist_unknown= [self.taskModel getTasksByStatus:Delivery_Status_Unknow];
            });
        }
        else{
            self.tasklist_delivering= [[NSArray alloc] init];
            self.tasklist_finished= [[NSArray alloc] init];
            self.tasklist_failed= [[NSArray alloc] init];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:TASK_UPDATE_NOTIFICATION object:nil];
    }
}

-(TaskModel *)taskModel{
    if(!_taskModel){
        _taskModel=[[TaskModel alloc] init];
        _taskModel.delegate=self;
    }
    return _taskModel;
}

-(MemberLoginModel *)loginModel{
    if(!_loginModel){
        _loginModel=[[MemberLoginModel alloc] init];
        _loginModel.delegate=self;
    }
    return _loginModel;
}


@end
