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
#import "GoodsCategoryViewController.h"
#import "CartViewController.h"
#import "AdPageViewController.h"

@interface Booter() 
{
    HomeViewController* homeViewController;
    GoodsCategoryViewController* goodsCategoryViewController;
    CartViewController* cartViewController;
    UserCenterViewController* userCenterViewController;
}
@end

@implementation Booter

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self checkIfLoginAccountIsValid];
        
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
    
    goodsCategoryViewController = [[GoodsCategoryViewController alloc] init];
    goodsCategoryViewController.hidesBottomBarWhenPushed = NO;
    goodsCategoryViewController.tabBarItem = [[SPTabBarItem alloc] initWithTitle:@"列表模式" image:[UIImage imageNamed:@"1_56"] selectedImage:[UIImage imageNamed:@"1_65"]];
    
    userCenterViewController = [[UserCenterViewController alloc] init];
    userCenterViewController.hidesBottomBarWhenPushed = NO;
    userCenterViewController.tabBarItem = [[SPTabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"1_69"] selectedImage:[UIImage imageNamed:@"1_59"]];
    
    SPNavigationController *navHomeViewController = [[SPNavigationController alloc] initWithRootViewController:homeViewController];
    SPNavigationController *navCategoryViewController = [[SPNavigationController alloc] initWithRootViewController:goodsCategoryViewController];
    SPNavigationController *navUserCenterViewController = [[SPNavigationController alloc] initWithRootViewController:userCenterViewController];

  
    self.tabBarController = [[SPTabBarController alloc] init];
    self.tabBarController.tabBar.translucent = NO;
    self.tabBarController.tabBar.tintColor = COLOR_FONT_MAIN;
    [self.tabBarController setViewControllers:@[navHomeViewController,navCategoryViewController,navUserCenterViewController]];
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
    
    NSString *index = [NSString stringWithFormat:@"%ld",tabBarController.selectedIndex];
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

//获取商品分类
-(void)loadGoodsCategory{
    self.categoryModel.requestTag=1111;
    [self.categoryModel loadGoodsCategory];
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


//启动ShareSDK，第三方登录和分享
-(void)bootShareSDK{
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:SHARESDK_APP_KEY
          activePlatforms:@[
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatTimeline)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
            case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:WXAPPID
                                       appSecret:WXAPPSECRET];
                 break;
            
             default:
                 break;
         }
     }];
    
    //(注意：每一个case对应一个break不要忘记填写，不然很可能有不必要的错误，新浪微博的外部库如果不要客户端分享或者不需要加关注微博的功能可以不添加，否则要添加，QQ，微信，google＋这些外部库文件必须要加)
    
    
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


- (void)handleRemoteNotifacation:(NSDictionary *)userInfo
{
    
    
//    if(userInfo!=nil){
//        //处理滑动消息通知过来的情况，如果是评论，则显示图片详情页面
//        if (application.applicationState != UIApplicationStateActive&&![[userInfo objectForKey:@"id"] isEqualToString:@""]) {//
//            self.isPushNews=YES;
//            [self gotoNewsDetail:userInfo];
//        }
//        //praise
//    }
//    //在AppDelegate的didReceiveRemoteNotification中可以通过判断isLaunchedByNotification来通知不同的展示方法。
//    if (application.applicationState == UIApplicationStateActive) {//App处于打开状态的时候，处理方法为打开一个本地消息通知
//        
//        AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, SoundFinished,NULL);
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//        
//        //        // 转换成一个本地通知，显示到通知栏，你也可以直接显示出一个alertView，只是那样稍显aggressive：）
//        //        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//        //        localNotification.userInfo = userInfo;
//        //        //NSLog(@"userInfo:%@",userInfo);
//        //        localNotification.soundName = UILocalNotificationDefaultSoundName;
//        //        localNotification.alertBody =[[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//        //        localNotification.alertAction = @"查看";  //提示框按钮
//        //        //localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
//        //        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"查看", nil];
//        [alert show];
//        
//        [self hank];
//    }
}

-(void)sync
{
    //同步sync接口
    [[YPSyncManager sharedInstance] load];
    //检查更新
    //[YPUpdateChecker sharedInstance];
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


//- (void)onResp:(BaseResp *)resp {
//    if ([resp isKindOfClass:[PayResp class]]) {
//        //支付返回结果，实际支付结果需要去微信服务器端查询
//        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
//        
//        switch (resp.errCode) {
//            case WXSuccess:
////                strMsg = @"支付结果：成功！";
//                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//                 [[NSNotificationCenter defaultCenter] postNotificationName:@"PaymentComplete" object:nil];
//                break;
//                
//            default:
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
//                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//                [ViewCommon showAlertWithTitle:strTitle andMessage:strMsg];
//                break;
//        }
//        
//        
//    }
//}


-(void)hank{
    //AudioServicesPlaySystemSound ( kSystemSoundID_Vibrate) ;
    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL,NULL,NULL);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void)onResponse:(SPBaseModel *)model isSuccess:(BOOL)isSuccess{
    if(model.requestTag==1111){
        if(isSuccess){
            if(self.categoryModel.entity!=nil){
                [self.categoryModel setCategoryCache:self.categoryModel.entity];
            }
            else{
                NSLog(@"未获取到有效分类数据");
            }
        }
    }
    
}

-(GoodsCategoryModel *)categoryModel{
    if(!_categoryModel){
        _categoryModel=[[GoodsCategoryModel alloc] init];
        _categoryModel.delegate=self;
    }
    return _categoryModel;
}


@end
