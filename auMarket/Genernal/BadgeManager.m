//
//  BadgeManager.m
//  YP
//
//  Created by douj on 15/5/23.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import "BadgeManager.h"
//#import "YPMomentsMessagePullManager.h"

@implementation BadgeManager
DEF_SINGLETON(BadgeManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewMessage) name:YPMOMENTS_PULL_MESSAGE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangeCurrentTab:) name:ChangeCurrentTabNotification object:nil];
        self.currentTab = @"0";
    }
    return self;
}
- (NSString *)getBadgeValueForIndex:(NSInteger)index{
    UITabBarItem* item = [self.barItems objectAtIndex:index];
    return item.badgeValue;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onChangeCurrentTab : (NSNotification*) notification {
    self.currentTab = (NSString *) [notification object];
}

-(void)onNewMessage {
    
}

- (void)setBadgeValue:(NSString *)value forIndex:(NSInteger)index{
    
    UITabBarItem* item = [self.barItems objectAtIndex:index];
    if ([value isEqualToString:@"0"]) {
        item.badgeValue = nil;
    }else{
        item.badgeValue = value;
    }
    [self resetApplicationBadgeNumber];

}
- (void)resetApplicationBadgeNumber{
    NSInteger badgeNum = 0;
    for (UITabBarItem *item in self.barItems) {
        NSInteger value = SAFE_INTEGER_VALUE(item.badgeValue);
        badgeNum += value;
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = badgeNum;
}
@end
