//
//  TBCClassHelper.m
//  TBClient
//
//  Created by zhanghe on 14-9-18.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "SPClassHelper.h"
#import <objc/runtime.h>
@implementation SPClassHelper
{
    NSRecursiveLock *_propertyListCacheLock;
}

+ (void)load
{
    [self sharedInstance];
}

DEF_SINGLETON(SPClassHelper)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.propertyListCache = [NSMutableDictionary dictionary];
        _propertyListCacheLock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

- (NSDictionary *)propertyList:(Class)cls
{
    if (cls == NULL){
        return nil;
    }
    
    [_propertyListCacheLock lock];
    
    NSString *clsName = NSStringFromClass(cls);
    NSDictionary *cachePropertyList = [self.propertyListCache objectForKey:clsName];
    if (cachePropertyList) {
        [_propertyListCacheLock unlock];
        return cachePropertyList;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList(cls, &propertyCount);//获取cls 类成员变量列表
    for (unsigned i = 0; i < propertyCount; i++) {
        objc_property_t property = propertyList[i];
        const char *attr = property_getAttributes(property); //取得这个变量的类型
        NSString *attrString = [NSString stringWithUTF8String:attr];
        NSString *typeAttr = [[attrString componentsSeparatedByString:@","] objectAtIndex:0];
        if(typeAttr.length < 8) continue;
        NSString *typeString = [typeAttr substringWithRange:NSMakeRange(3, typeAttr.length - 4)];
        NSString *key = [NSString stringWithUTF8String:property_getName(property)];//取得这个变量的名称
        [dict setObject:typeString forKey:key];
    }
    free(propertyList);
    [self.propertyListCache setObject:dict forKey:clsName];
    
    [_propertyListCacheLock unlock];
    return dict;
}
@end
