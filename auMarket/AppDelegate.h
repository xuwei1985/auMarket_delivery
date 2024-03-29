//
//  AppDelegate.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/7.
//  Copyright © 2016年 daao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Booter.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
    NSTimer *tokenTimer;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) Booter* booter;
@property (strong, nonatomic) NSString *token;
@property (nonatomic,assign) BOOL isTokenRequestFaild;//定时请求token失败后标识这个标记，在请求成功前加快请求频率
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *hotLine;//当前选择的数据线路
@property (nonatomic,assign) BOOL isLocationAuthorized; //是否开启定位授权
@property (nonatomic,assign) int lastLocationTipTime;

+ (UINavigationController *)getNavigationController;
+ (UITabBarController *)getTabbarController;
-(void)bootMainVc;
-(void)initTokenTimer:(int)type;
@end

