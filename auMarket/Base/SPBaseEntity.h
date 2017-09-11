//
//  TBCBaseItem.h
//  TBClient
//
//  Created by douj on 13-3-26.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*
 列表项，子类需要：
 1、定义自己的特定属性，如tid
 2、重载setData，也可不实现，交由外层类处理
 3、通常不需要重载其他方法，除非您知道自己在干什么
 4、不需要实现NSCoding方法，父类自动处理，除非您知道自己在干什么
 */
@interface SPBaseEntity : NSObject <NSCoding>

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *err_msg;

- (id)initWithData:(id)data;
+ (id)itemWithData:(id)data;
- (void)setData:(id)data;

//子类继承在解析完json以后的一些数据逻辑处理
-(void)handleDataAfterParse;


// property中如有包含TBCBaseListItem对象的数组，需要设定此规则
- (void)addMappingRuleArrayProperty:(NSString*)propertyName class:(Class)cls;
//第一个是需要替换的propertyName 第二个是实际使用的propertyName
- (void)addReplaceMappingProperty:(NSString*)propertyName withReplcePropertyName:(NSString*)replcePropertyName;
// 添加不需要持久化缓存的字段
-(void)addDisableCacheField:(NSString*)fieldName;

@end

