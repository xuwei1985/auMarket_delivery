//
//  TBCClassHelper.h
//  TBClient
//
//  Created by zhanghe on 14-9-18.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPClassHelper : NSObject

DEC_SINGLETON(SPClassHelper)

@property (nonatomic, retain) NSMutableDictionary *propertyListCache;

- (NSDictionary *)propertyList:(Class)cls;

@end
