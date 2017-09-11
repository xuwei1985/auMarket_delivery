//
//  NSDateFormatter+IDPExtension.h
//  IDP
//
//  Created by xjz on 13-10-23.
//
//

#import <Foundation/Foundation.h>

typedef void (^IDPDateFormmaterConfigBlock)(NSDateFormatter *dateFormmater);

@interface NSDateFormatter (IDPExtension)

//由于我们项目中大部分只有使用format
//format 时间格式:eg. yyyy-mm-hh
//这个只用返回设置时间格式 其他的没有设置
+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format;

//key 唯一标识
//block 配置formmater的格式
+ (NSDateFormatter *)dateFormatterWithKey:(NSString *)key configBlock:(IDPDateFormmaterConfigBlock)block;

@end
