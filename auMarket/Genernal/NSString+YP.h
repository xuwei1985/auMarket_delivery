//
//  NSString+YP.h
//  Youpin
//
//  Created by douj on 15/4/27.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(YP)
+(NSString*)getNoNilString:(NSString*)str;
-(BOOL)isEmpty;
//是否为有效提交内容
- (BOOL)isValidateContent;
- (BOOL)isPureInt;
- (NSString *)URLEncoding;
//url编码成utf-8 str
- (NSString *)UTF8Encoding;
//url解码成unicode str
- (NSString *)URLDecoding;
- (NSString *)MD5String;

- (CGFloat)widthWithSystemFontSize:(NSInteger)size;
- (CGFloat)widthWithBoldSystemFontSize:(NSInteger)size;
- (CGFloat)heightWidthSystemFontSize:(NSInteger)size width:(CGFloat)width;
- (CGFloat)heightWidthBoldSystemFontSize:(NSInteger)size width:(CGFloat)width;
+(NSString*)getFileMD5WithPath:(NSString*)path;

@end
