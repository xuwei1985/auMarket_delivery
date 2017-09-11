//
//  TBCBaseItem.m
//  TBClient
//
//  Created by douj on 13-3-26.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import "SPBaseEntity.h"
#import "SPClassHelper.h"
#import <objc/runtime.h>


@interface SPBaseEntity()
@property (nonatomic,strong) NSMutableDictionary* jsonArrayClassMap;
@property (nonatomic,strong) NSMutableSet* disableCacheField;
@property (nonatomic,strong) NSMutableDictionary* replaceMappingFieldDict;
@end

@implementation SPBaseEntity

+ (id)itemWithData:(id)data {
    return [[SPBaseEntity alloc] initWithData:data];
}

- (id)init {
    if (self = [super init]) {
        _jsonArrayClassMap = [[NSMutableDictionary alloc] init];
        _disableCacheField = [[NSMutableSet alloc] init];
        _replaceMappingFieldDict = [NSMutableDictionary dictionary];
    }
    return self;
}


- (id)initWithData:(id)data {
    if (self = [self init]) {
        [self setData:data];
    }
    return self;
}

// 反序列化自身包括子类
- (id)initWithCoder:(NSCoder *)aDecoder {
//    NSLog(@"decodeWithCoder_class:%@",self.class);
    if (self = [super init]) {
        unsigned int propertyCount = 0;
        objc_property_t *propertyList = class_copyPropertyList(self.class, &propertyCount);
        for (unsigned i = 0; i < propertyCount; i++) {
            objc_property_t property = propertyList[i];
            NSString * propertyName= [NSString stringWithUTF8String:property_getName(property)];
            if ([self.disableCacheField containsObject:propertyName]) {
                continue;
            }
            @try {
                id value = [aDecoder decodeObjectForKey:propertyName];
                if (value) {
                    [self setValue:value forKey:propertyName];
                }
            }@catch (NSException *exception) {
                IDPLogWarning(0, @"proprty is not KVC compliant: %@", propertyName);
            }
        }
        free(propertyList);
    }
    return self;
}

// 序列化自身包括子类
- (void)encodeWithCoder:(NSCoder *)aCoder {
//    NSLog(@"encodeWithCoder_class:%@",self.class);
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList(self.class, &propertyCount);
    for (unsigned i = 0; i < propertyCount; i++) {
        objc_property_t property = propertyList[i];
        NSString * propertyName= [NSString stringWithUTF8String:property_getName(property)];
        if ([self.disableCacheField containsObject:propertyName]) {
            continue;
        }
        @try {
            id value = [self valueForKey:propertyName];
            [aCoder encodeObject:value forKey:propertyName];
        }@catch (NSException *exception) {
            IDPLogWarning(0, @"proprty is not KVC compliant: %@", propertyName);
        }
    }
    free(propertyList);
}

- (void)setData:(id)data {
    if (nil == data)
    {
        return;
    }
    [self parseData:data];
}

- (void)addMappingRuleArrayProperty:(NSString*)propertyName class:(Class)cls
{
    [_jsonArrayClassMap setObject:NSStringFromClass(cls) forKey:propertyName];
}
- (void)addReplaceMappingProperty:(NSString *)propertyName withReplcePropertyName:(NSString *)replcePropertyName{
    if (propertyName && replcePropertyName) {
        [self.replaceMappingFieldDict setObject:propertyName forKey:replcePropertyName];
    }
}
-(void)addDisableCacheField:(NSString*)fieldName
{
    [self.disableCacheField addObject:fieldName];
}

- (BOOL)parseData:(NSDictionary *)data
{
    if(![data isKindOfClass:[NSDictionary class]])
    {
        return NO;
    }
    
    Class cls = [self class];
    while (cls != [SPBaseEntity class])
    {
        NSDictionary *propertyList = [[SPClassHelper sharedInstance] propertyList:cls];
        for (NSString *key in [propertyList allKeys])
        {
            NSString *typeString = [propertyList objectForKey:key];
            NSString* path = [self.replaceMappingFieldDict objectForKey:key];
            if (path == nil) {
                path = key;
            }else{
                DebugLog(@"-----%@ has been replaced to %@!----",key,path);
            }
            id value = [data objectAtPath:path];
            [self setFieldName:key fieldClassName:typeString value:value];
        }

        cls = class_getSuperclass(cls);
    }
    //更多处理
    [self handleDataAfterParse];
    return YES;
}

- (void)setFieldName:(NSString*)name fieldClassName:(NSString*)className value:(id)value
{
    if (name == nil) {
//        正常情况，屏蔽Log
        IDPLogWarning(0,@"json at %@ is nil field",name);
        return;
    }
    
    if (value == nil) {
        return;
    }
    //如果结构里嵌套了TBCBaseListItem 也解析
    if ([NSClassFromString(className) isSubclassOfClass:[SPBaseEntity class]])
    {
        Class entityClass = NSClassFromString(className);
        if ([value isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)value;
            if (str && str.length == 0) {
                return;
            }
        }
        if ([value isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)value;
            if (arr && [arr count] == 0) {
                return;
            }
        }
        if (entityClass)
        {
            
            SPBaseEntity* entityInstance = [[entityClass alloc] init];
            [entityInstance parseData:value];
            [self setValue:entityInstance forKey:name];
        }
    }
    //如果是array判断array内类型
    else if ([NSClassFromString(className) isSubclassOfClass:[NSArray class]])
    {
        NSString* typeName = [_jsonArrayClassMap objectForKey:name];
        if (typeName)
        {
            //json中不是array 类型错误
            if (![value isKindOfClass:[NSArray class]]) {
                
                IDPLogWarning(0,@"json at %@ is not array field ",name);
                return;
            }
            Class entityClass = NSClassFromString(typeName);
            //entiyClass不存在
            if (!entityClass)
            {
                IDPLogWarning(0,@"json at %@ class %@ is not exist field",typeName,name);
                return;
            }
            //entiyClass不是TBCJsonEntityBase的子类
            if (![entityClass isSubclassOfClass:[SPBaseEntity class]])
            {
                IDPLogWarning(0,@"json at %@ class %@ is not subclass of TBCBaseItem field",typeName,name);
                return;
            }
            NSMutableArray* mutableArr = [[NSMutableArray alloc] initWithCapacity:[(NSArray*)value count]];
            for (NSDictionary*dict in (NSArray*)value )
            {
                //arry中存的不是dict
                if (![dict isKindOfClass:[NSDictionary class]])
                {
                    IDPLogWarning(0,@"json at %@ class dict in Array is dict type field",name);
                    return;
                }
                
                SPBaseEntity* entityInstance =  [[entityClass alloc] init];
                
                [entityInstance parseData:dict];
                if (entityInstance) {
                    [mutableArr addObject:entityInstance];
                }
                
            }
            [self setValue:mutableArr forKey:name];
            
        }
        else
        {
            [self setValue:value forKey:name];
        }
    }
    //如果不是对应的类型
    else if (![value isKindOfClass:NSClassFromString(className)])
    {
        if ([value isKindOfClass:[NSString class]] && NSClassFromString(className) == [NSNumber class]) {
            if ([value rangeOfString:@"."].location == NSNotFound) {
                [self setValue:[NSNumber numberWithInteger:[(NSString *)value integerValue]] forKey:name];
            } else {
                [self setValue:[NSNumber numberWithDouble:[(NSString *)value doubleValue]] forKey:name];
            }
        }else if ([value isKindOfClass:[NSNumber class]] && NSClassFromString(className) == [NSString class]){
            [self setValue:[(NSNumber *)value stringValue] forKey:name];
        }else{
//            正常情况，屏蔽Log
//            IDPLogWarning(0,@"json at %@ is dismatch field ",name);
        }

        return;
    }
    //正常情况
    else
    {
        [self setValue:value forKey:name];
    }
}



-(void)handleDataAfterParse
{
    
}

- (void)dealloc {
    self.jsonArrayClassMap = nil;
}

- (NSString *)description{
    NSDictionary *propertyList = [[SPClassHelper sharedInstance] propertyList:[self class]];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *key in propertyList.allKeys) {
        NSString *value = [self valueForKey:key];
        NSString *string = [NSString stringWithFormat:@"[%@ : %@]",key,value];
        [arr addObject:string];
    }
    return [NSString stringWithFormat:@"\n[%@:\n   %@\n]",NSStringFromClass(self.class),[arr componentsJoinedByString:@",\n   "]];
}
@end
