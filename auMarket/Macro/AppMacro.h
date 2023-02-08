//
//  AppMacro.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/7.
//  Copyright © 2016年 daao. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

//单例定义
#undef	DEC_SINGLETON
#define DEC_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}


//接口相关
#ifdef DEBUG//测试
    #define SERVER_ADDRESS        @"http://api_test.bigau.com"
    #define SERVER_HTTP_ADDRESS   @"http://api_test.bigau.com"

#else//正式
    #define SERVER_ADDRESS          @"https://api_test.bigau.com"
    #define SERVER_HTTP_ADDRESS     @"https://api_test.bigau.com"

#endif

//系统相关
#define APP_NAME @"墨尔本超市配送"
#define APP_SCHEME  @"auMarketDelivery://"
#define APP_INTRO_VER @"APP_INTRO_VER"
#define PRIVATE_KEY @"__xiaoyacity@2016"

#define APP_WINDOW [UIApplication sharedApplication]
#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
//#define OPEN_WIFI_SETTING_URL @"prefs:root=WIFI"
#define SYSTEM_VERSION_STRING  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define IPHONE6PLUS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size)||CGSizeEqualToSize(CGSizeMake(1125,2001), [[UIScreen mainScreen] currentMode].size)): NO)
#define IPHONE6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IPHONE4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPAD [[Common platformString] rangeOfString:@"iPad"].length>0
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0?YES:NO)
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0?YES:NO)
#define IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0?YES:NO)
#define IOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0?YES:NO)
#define IOS11 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0?YES:NO)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)



#endif /* AppMacro_h */
