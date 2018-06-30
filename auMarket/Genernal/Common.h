//
//  Common.h
//  HuiYuEr
//
//  Created by 吴 绪伟 on 13-3-25.
//  Copyright (c) 2013年 wuxuwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CommonCrypto/CommonDigest.h> 
#import <CoreImage/CoreImage.h>
#import <AdSupport/AdSupport.h>
#import "GTMBase64.h"
#import "AppMacro.h"

@interface Common : NSObject

+ (int)countWord:(NSString *)s;
+(int)getStingToInt:(NSString*)strtemp;
+(NSString *)getCurrentTime;
+(NSString *)getCurrentDate;
+(NSString *)getCurrentTimeStr;
+(NSString *)getShortDate:(NSDate *)senddate;
+(NSString *)getShortDateAndTime:(NSDate *)senddate;
+(NSString *)getShortTime:(NSDate *)senddate;
+(NSString *)getDate:(NSDate *)date;
+(NSString *)getNowTimeTimestamp;
+(NSString *)getNowTimeTimestampForAustralia;
+(NSString *)getCNCurrentDate;
+(NSString *)md5:(NSString *)str;
+ (BOOL)validateInt:(NSString *)string;
+ (BOOL)validateFloat:(NSString *)string;
+ (BOOL)validateEmail: (NSString *)email;
+(BOOL)validateMobile:(NSString *)mobileNum;
+ (NSData *)createThumbImage:(UIImage *)image size:(CGSize )thumbSize percent:(float)percent;
+(long)sumCurrentTimeDiffer:(NSDate*)compareDate;
+(NSString *) compareCurrentTime:(NSDate*) compareDate;
+(NSString*)week:(NSInteger)week;
+ (NSString *) platformString;
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSDate *)getLocalDateFromatAnyDate:(NSDate *)anyDate;
+(NSString*)encodeBase64String:(NSString * )input;
+(NSString*)decodeBase64String:(NSString * )input;
+(void)copyToPastboard:(NSString *)str;
+(int)getRandomInt:(int)x;
+(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
+ (CGFloat)widthOfLabel:(NSString *)strText ForFont:(UIFont *)font;
+ (CGFloat)HeightOfLabel:(NSString *)strText ForFont:(UIFont *)font;
+ (CGFloat)HeightOfLabel:(NSString *)strText ForFont:(UIFont *)font withWidth:(float)width;
+ (CGFloat)WidthOfLabel:(NSString *)strText ForFont:(UIFont *)font withWidth:(float)height;
+ (NSString *)getPlistPathWithName:(NSString *)plistName;
+ (UIColor*)hexColor:(NSString*)hexColor;
+(NSString *)getUserKey:(NSString *)uid;
+(NSString *)getUserKey;
+(NSString *)getRequestSignature:(NSString *)actStr;
+(NSString *)getOddString:(NSString *)str;
+(NSString *)getEvenString:(NSString *)str;
+(NSString *)getRandomCharacterAndNum;
+(NSString *)getClientId;
+ (NSString *)encodeToPercentEscapeString: (NSString *) input;
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input;
+(BOOL)isMobileForAU:(NSString *)mobile;
@end
