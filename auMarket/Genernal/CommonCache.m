//
//  CommonCache.m
//  Youpin
//
//  Created by zhanghe on 15/5/8.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import "CommonCache.h"
#import "AccountManager.h"

@implementation CommonCache

DEF_SINGLETON(CommonCache)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cacheList = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (TMCache *)getCache:(NSString*)strNameSpace {
    NSString *path = [[AccountManager sharedInstance] getCurrentUser].user_id;
    if (!path) {
        path = @"public";
    }
    path = [NSString stringWithFormat:@"%@/%@",path,strNameSpace];
    if ([self.cacheList objectForKey:path]) {
        return [self.cacheList objectForKey:path];
    } else {
        TMCache *cache = [[TMCache alloc] initWithName:path];
        [self.cacheList setObject:cache forKey:path];
        return cache;
    }
}

@end
