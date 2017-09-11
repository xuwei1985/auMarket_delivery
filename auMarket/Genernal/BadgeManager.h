//
//  BadgeManager.h
//  YP
//
//  Created by douj on 15/5/23.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BadgeManager : NSObject

@property (nonatomic,strong) NSArray* barItems;
@property (nonatomic,strong) NSString * currentTab;

DEC_SINGLETON(BadgeManager)
-(void)setBadgeValue:(NSString*)value forIndex:(NSInteger)index;
-(NSString*)getBadgeValueForIndex:(NSInteger)index;

@end
