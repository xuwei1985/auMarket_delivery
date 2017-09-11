//
//  AppDelegate.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/7.
//  Copyright © 2016年 daao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Booter.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) BOOL isWorking;
@property (strong,nonatomic) Booter* booter;

+ (UINavigationController *)getNavigationController;
+ (UITabBarController *)getTabbarController;
-(void)bootMainVc;
@end

