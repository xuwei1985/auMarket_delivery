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
@property (assign, nonatomic) BOOL isWorking;
@property (strong,nonatomic) Booter* booter;
@property (strong, nonatomic) NSString *token;
@property (nonatomic,assign) BOOL isTokenRequestFaild;//定时请求token失败后标识这个标记，在请求成功前加快请求频率
@property (strong, nonatomic) CLLocationManager *locationManager;

+ (UINavigationController *)getNavigationController;
+ (UITabBarController *)getTabbarController;
-(void)bootMainVc;
-(void)initTokenTimer:(int)type;
@end

