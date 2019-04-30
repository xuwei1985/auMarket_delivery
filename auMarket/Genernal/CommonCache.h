//
//  CommonCache.h
//  Youpin
//
//  Created by zhanghe on 15/5/8.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMCache.h"

@interface CommonCache : NSObject

DEC_SINGLETON(CommonCache)

@property (nonatomic, strong) NSMutableDictionary *cacheList;

- (TMCache *)getCache:(NSString*)strNameSpace;
- (TMCache *)getUserCache:(NSString*)strNameSpace;
@end
