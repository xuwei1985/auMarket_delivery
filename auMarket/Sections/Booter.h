//
//  YPUIBooter.h
//  Youpin
//
//  Created by douj on 15/4/15.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"
#import "Common.h"
#import "AlertBlockView.h"
#import "SyncManager.h"
#import "BadgeManager.h"
#import "AccountManager.h"
#import "SPNavigationController.h"
#import "SPBaseModel.h"
#import "SPRedirect.h"
#import "SPTabBarItem.h"
#import <AdSupport/AdSupport.h>
#import "SPTabBarController.h"
#import "IntroViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "TaskModel.h"
#import "BooterModel.h"
#import "MemberLoginModel.h"

@interface Booter : NSObject<UIGestureRecognizerDelegate,UITabBarControllerDelegate,SPBaseModelProtocol>{
    int last_location_update;
}

@property (nonatomic,strong) UINavigationController* navigationController;
@property (nonatomic,strong) UITabBarController* tabBarController;
@property (nonatomic,strong) TaskModel *taskModel;
@property (nonatomic,strong) BooterModel *model;
@property (nonatomic,strong) MemberLoginModel *loginModel;
@property (nonatomic,strong) NSArray<TaskItemEntity *> *tasklist_delivering;//配送中的订单
@property (nonatomic,strong) NSArray<TaskItemEntity *> *tasklist_finished;//配送完成的订单
@property (nonatomic,strong) NSArray<TaskItemEntity *> *tasklist_failed;//配送失败的订单
@property (nonatomic,strong) NSArray<TaskItemEntity *> *tasklist_unknown;//没有配送坐标的订单
@property (nonatomic,strong) NSArray *sectionArr;//配送时间段数组
@property (nonatomic,strong) NSArray<ParkingItemEntity *> *parkinglist;

// 获取引导页
-(UIViewController*)getIntroViewController;
// 初始化UI
-(UIViewController*)bootUIViewController;
// 初始化启动广告页
-(UIViewController*)bootStartPage;
-(void)registRemoteNotification;
//初始化UMeng统计
-(void)bootUMeng;
//初始化极光推送
-(void)bootJPush:(NSDictionary *)launchOptions;
//处理工作状态
-(void)handlerWorkingState:(BOOL)isWorking;
//sync接口
-(void)sync;
//外部回调
-(BOOL)onHandleOpenURL:(NSURL *)url;
//网络检测
- (void)bootReachability;
-(void)bootGoogleMap;
-(void)loadTaskList;
-(void)loadParkingList;
-(void)postLocation;
@end
