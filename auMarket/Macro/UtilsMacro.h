//
//  UtilsMacro.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/7.
//  Copyright © 2016年 daao. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h

//一些方便使用的宏定义：
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define DEFAULT_FONT(s) [UIFont systemFontOfSize:s]
#define DEFAULT_BOLD_FONT(s) [UIFont boldSystemFontOfSize:s]

#define NSStringFromInt(intValue) [NSString stringWithFormat:@"%d",intValue]
#define NSStringFromLong(intValue) [NSString stringWithFormat:@"%ld",longValue]
#define SAFE_INTEGER_VALUE(v) ((v) && [(v) respondsToSelector:@selector(integerValue)] ? [(v) integerValue]: 0)
#define SAFE_FLOAT_VALUE(v) ((v) && [(v) respondsToSelector:@selector(floatValue)] ? [(v) floatValue]: 0.0)



#if  DEBUG
#define DebugLog(format,...) NSLog(format,##__VA_ARGS__)
#define DebugMethod() NSLog(@"%s",__func__)
#else
#define DebugLog(format,...)
#define DebugMethod()
#endif

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#endif /* UtilsMacro_h */
