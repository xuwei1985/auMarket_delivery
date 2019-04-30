//
//  Common.m
//  HuiYuEr
//
//  Created by 吴 绪伟 on 13-3-25.
//  Copyright (c) 2013年 wuxuwei. All rights reserved.
//

#import "Common.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation Common

//字数统计 中英文和空格区分
+ (int)countWord:(NSString *)s
{
    int i,n=(int)[s length],l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[s characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{//中文
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return l+(int)ceilf((float)(a+b)/2.0);
}

+(int)getStingToInt:(NSString*)strtemp

{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [strtemp dataUsingEncoding:enc];
    return (int)[da length];
}


+(NSString *)getCurrentTime{
    
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *locationDateString=[dateformatter stringFromDate:senddate];
    return  locationDateString;
}

+(NSString *)getCurrentTimeStr{
    
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HHmmss"];
    NSString *locationDateString=[dateformatter stringFromDate:senddate];
    return  locationDateString;
}

+(NSString *)getCurrentDate{
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationDateString=[dateformatter stringFromDate:senddate];
    return  locationDateString;
}

+(NSString *)getCNCurrentDate{
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM月dd日"];
    NSString *locationDateString=[dateformatter stringFromDate:senddate];
    return  locationDateString;
}

+(NSString *)getShortDate:(NSDate *)senddate{
    //NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM-dd"];
    NSString *locationDateString=[dateformatter stringFromDate:senddate];
    return  locationDateString;
}

+(NSString *)getShortDateAndTime:(NSDate *)senddate{
    //NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM-dd HH:mm"];
    NSString *locationDateString=[dateformatter stringFromDate:senddate];
    return  locationDateString;
}

+(NSString *)getShortTime:(NSDate *)senddate{
    //NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSTimeZone* destinationTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0000"];
    dateformatter.timeZone=destinationTimeZone;
    NSString *locationDateString=[dateformatter stringFromDate:senddate];
    return  locationDateString;
}

+(NSString *)getDate:(NSDate *)date{
    //NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationDateString=[dateformatter stringFromDate:date];
    return  locationDateString;
}

+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}

+(NSString *)getNowTimeTimestampForAustralia{
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss.SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
//
//    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
//    [formatter setTimeZone:timeZone];
//
//    NSString *nowString = [formatter stringFromDate:[NSDate date]];//0区的时间
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *nowString = [dateFormatter stringFromDate:[NSDate date]];
    NSTimeZone* timeZone2 = [NSTimeZone timeZoneWithName:@"Australia/Melbourne"];//
    BOOL isDST = [timeZone2 isDaylightSavingTime];//是否是夏令时
    [dateFormatter setTimeZone:timeZone2];
    NSDate *now = [dateFormatter dateFromString:nowString];
    
    //NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([now timeIntervalSince1970]*1000)];//毫秒级
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[now timeIntervalSince1970]];//秒级
    
    return timeSp;
    
}


+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//整型判断
+ (BOOL)validateInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//浮点形判断：
+ (BOOL)validateFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

+ (BOOL) validateEmail: (NSString *) email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0-9]|7[8])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(76[0-9]|34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSData *)createThumbImage:(UIImage *)image size:(CGSize )thumbSize percent:(float)percent{
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat scaleFactor = 0.0;
    CGPoint thumbPoint = CGPointMake(0.0,0.0);
    CGFloat widthFactor = thumbSize.width / width;
    CGFloat heightFactor = thumbSize.height / height;
    if (widthFactor > heightFactor)  {
        scaleFactor = widthFactor;
    }
    else {
        scaleFactor = heightFactor;
    }
    CGFloat scaledWidth  = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    if (widthFactor > heightFactor)
    {
        thumbPoint.y = (thumbSize.height - scaledHeight) * 0.6;
    }
    else if (widthFactor < heightFactor)
    {
        thumbPoint.x = (thumbSize.width - scaledWidth) * 0.6;
    }
    UIGraphicsBeginImageContext(thumbSize);
    CGRect thumbRect = CGRectZero;
    thumbRect.origin = thumbPoint;
    thumbRect.size.width  = scaledWidth;
    thumbRect.size.height = scaledHeight;
    [image drawInRect:thumbRect];
    
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *thumbImageData = UIImageJPEGRepresentation(thumbImage, percent);
    return thumbImageData;
    //[thumbImageData writeToFile:thumbPath atomically:NO];
}


-(int)isJPEGValid:(NSData *)jpeg
{
    if ([jpeg length] < 4)
        return 1;
    const unsigned char * bytes = (const unsigned char *)[jpeg bytes];
    
    if (bytes[0] != 0xFF || bytes[1] != 0xD8) return 2;
    
    if (bytes[[jpeg length] - 2] != 0xFF ||
        
        bytes[[jpeg length] - 1] != 0xD9) return 3;
    
    return 0;
}


//返回时间差
+(NSString *) compareCurrentTime:(NSDate*) compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

+ (NSDate *)dateFromString:(NSString *)dateString{
    dateString=[dateString stringByReplacingOccurrencesOfString :@"/" withString:@"-"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

+(NSDate *)getLocalDateFromatAnyDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

//时间差（秒）
+(long)sumCurrentTimeDiffer:(NSDate*)compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    return  timeInterval;
}

+(NSString*)week:(NSInteger)week
{
    NSString*weekStr=nil;
    if(week==1)
    {
        weekStr=@"周日";
    }else if(week==2){
        weekStr=@"周一";
        
    }else if(week==3){
        weekStr=@"周二";
        
    }else if(week==4){
        weekStr=@"周三";
        
    }else if(week==5){
        weekStr=@"周四";
        
    }else if(week==6){
        weekStr=@"周五";
        
    }else if(week==7){
        weekStr=@"周六";
        
    }
    return weekStr;
}


+ (NSString*)getDeviceVersion
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

+ (NSString *) platformString{
    NSString *platform = [self getDeviceVersion];
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"])   return@"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])   return@"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])   return@"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])   return@"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])   return@"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])   return@"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])   return @"iPhone 4s";
    if ([platform isEqualToString:@"iPhone5,1"])   return @"iPhone 5 (GSM/WCDMA)";
    if ([platform isEqualToString:@"iPhone4,2"])   return @"iPhone 5 (CDMA)";
    
    //iPot Touch
    if ([platform isEqualToString:@"iPod1,1"])     return@"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])     return@"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])     return@"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])     return@"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])     return@"iPod Touch 5G";
    //iPad
    if ([platform isEqualToString:@"iPad1,1"])     return@"iPad";
    if ([platform isEqualToString:@"iPad2,1"])     return@"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])     return@"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])     return@"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])     return@"iPad 2 New";
    if ([platform isEqualToString:@"iPad2,5"])     return@"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad3,1"])     return@"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])     return@"iPad 3 (CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])     return@"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])     return@"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"])        return@"Simulator";
    
    return platform;
}


+(NSString*)encodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+(NSString*)decodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeString:input];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+(UIImage *)getImageFromView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(void)copyToPastboard:(NSString *)str{
    UIPasteboard *pb=[UIPasteboard generalPasteboard];
    pb.string=str;
}

+(int)getRandomInt:(int)x{
    int value =arc4random_uniform(x+1);
    return value;
}

+(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    // optional - add more buttons:
    //[alert addButtonWithTitle:@"Yes"];
    [alert show];
}

+ (CGFloat)widthOfLabel:(NSString *)strText ForFont:(UIFont *)font
{
    CGSize size;
    NSDictionary *attributes = @{NSFontAttributeName:font};
    size = [strText sizeWithAttributes:attributes];
    return size.width;
}

+ (CGFloat)HeightOfLabel:(NSString *)strText ForFont:(UIFont *)font
{
    CGRect rect;
    NSDictionary *attributes = @{NSFontAttributeName:font};
    rect = [strText boundingRectWithSize:CGSizeMake(WIDTH_SCREEN - 20, 4000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
    return rect.size.height;
}

+ (CGFloat)HeightOfLabel:(NSString *)strText ForFont:(UIFont *)font withWidth:(float)width
{
    CGRect rect;
    NSDictionary *attributes = @{NSFontAttributeName:font};
    rect = [strText boundingRectWithSize:CGSizeMake(width, 4000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
    return rect.size.height;
}

+ (CGFloat)WidthOfLabel:(NSString *)strText ForFont:(UIFont *)font withWidth:(float)height
{
    CGRect rect;
    NSDictionary *attributes = @{NSFontAttributeName:font};
    rect = [strText boundingRectWithSize:CGSizeMake(WIDTH_SCREEN, height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
    return rect.size.width;
}

+ (NSString *)getPlistPathWithName:(NSString *)plistName
{
    NSArray *patharray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *path =  [patharray objectAtIndex:0];
    
    NSString *name = [NSString stringWithFormat:@"%@.plist",plistName];
    
    NSString *filepath=[path stringByAppendingPathComponent:name];
    
    //NSLog(@"%@",filepath);
    
    return filepath;
}

//颜色值转换
+ (UIColor*)hexColor:(NSString*)hexColor {
    
    unsigned int red, green, blue, alpha;
    NSRange range;
    range.length = 2;
    @try {
        if ([hexColor hasPrefix:@"#"]) {
            hexColor = [hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
        }
        range.location = 0;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
        range.location = 2;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
        range.location = 4;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
        
        if ([hexColor length] > 6) {
            range.location = 6;
            [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&alpha];
        }
    }
    @catch (NSException * e) {
        //        [MAUIToolkit showMessage:[NSString stringWithFormat:@"颜色取值错误:%@,%@", [e name], [e reason]]];
        //        return [UIColor blackColor];
    }
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:(float)(1.0f)];
}



+(NSString *)getRequestSignature:(NSString *)actStr{
    NSString *privateKey=PRIVATE_KEY;//私钥
    NSString *signatureStr=@"";//最终的签名字符串
    NSArray *key_value_arr;//以=分割的数组的key
    NSString *key_str;//key_value_arr以=分割的数组的key
    NSString *value_str;//key_value_arr以=分割的数组的value
    //NSString *token=(AppDelegate.token==nil?@"":AppDelegate.token);
    
    //actStr，http请求链接？之后的字符串
    if(actStr!=nil&&actStr.length>0){
        if([actStr rangeOfString:@"?"].location!=NSNotFound){
            actStr=[[actStr componentsSeparatedByString:@"?"] objectAtIndex:1];
        }
        //检查请求地址有效性
        if (actStr!=nil&&![actStr isEqualToString:@""]&&actStr.length>0) {
            
            //将请求地址以“&”分割成数组
            NSArray *oArr =[actStr componentsSeparatedByString:@"&"];
            if(oArr!=nil){
                //按照a-z顺序排序
                NSArray *aArr = [oArr sortedArrayUsingSelector:@selector(compare:)];
                
                //键值拼接
                for (int i = 0; i < aArr.count; i++) {
                    //将每个元素以“＝”再分隔
                    key_value_arr=[[aArr objectAtIndex:i] componentsSeparatedByString:@"="];
                    //检测分割有效性
                    if (key_value_arr!=nil&&key_value_arr.count==2) {
                        //key
                        key_str=[key_value_arr objectAtIndex:0];
                        //value
                        value_str=[key_value_arr objectAtIndex:1];
                        
                        //value不为空的才加入签名，键为a或c的不参与签名
                        if (value_str!=nil&&![value_str isEqualToString:@""]&&![value_str isEqualToString:@"0"]&&value_str.length>0) {
                            //将key连接value，一直拼接起来
                            signatureStr=[NSString stringWithFormat:@"%@%@:%@",signatureStr,key_str,value_str];
                        }
                    }
                }
                //位移处理
                
                //混淆私钥+加密act:deliver_loginpassword:123456username:test001__xiaoyacity@201618c3e2e7bf645488ed7bca87d6848e72
                if (signatureStr!=nil&&![signatureStr isEqualToString:@""]&&signatureStr.length>0) {
                    //属性拼接结果__privateKey进行md5
                    signatureStr=[NSString stringWithFormat:@"%@%@%@",signatureStr,privateKey,APP_DELEGATE.token];
                    signatureStr=[self md5:signatureStr];
                }
            }
        }
    }

    return signatureStr;
}


+(NSString *)getUserKey{
    NSString *privateKey=PRIVATE_KEY;
    NSString *signatureStr=@"";
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *userid=[NSString stringWithFormat:@"%@",adId];
    
    //混淆私钥
    if (userid!=nil&&![userid isEqualToString:@""]&&userid.length>0) {
        signatureStr=[NSString stringWithFormat:@"%@_%@",privateKey,userid];
    }
    
    //加密
    if (signatureStr!=nil&&![signatureStr isEqualToString:@""]&&signatureStr.length>0) {
        signatureStr=[self md5:signatureStr];
    }
    
    return signatureStr;
}

+(NSString *)getUserKey:(NSString *)uid{
    NSString *privateKey=PRIVATE_KEY;
    NSString *signatureStr=@"";
    NSString *userid=[NSString stringWithFormat:@"%@",uid];;
    
    //混淆私钥
    if (userid!=nil&&![userid isEqualToString:@""]&&userid.length>0) {
        signatureStr=[NSString stringWithFormat:@"%@_%@",privateKey,userid];
    }
    
    //加密
    if (signatureStr!=nil&&![signatureStr isEqualToString:@""]&&signatureStr.length>0) {
        signatureStr=[self md5:signatureStr];
    }
    
    return signatureStr;
}

+(NSString *)getClientId{
    NSString *clientId=@"";
    NSString *tempStr=@"";
    NSString *adId = [[[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] lowercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *oddString=@"";
    NSString *evenString=@"";
    
    if (adId!=nil&&![adId isEqualToString:@""]&&adId.length>0) {
        adId=[NSString stringWithFormat:@"%@%@",adId,[UIDevice currentDevice].model];
        oddString=[self getOddString:adId];
        evenString=[self getEvenString:adId];
        tempStr=[NSString stringWithFormat:@"%@%@",oddString,evenString];
        
        //在字符串中的每个字母后面都加上一个随机字母
        for (int i=0; i<tempStr.length; i++) {
            clientId=[NSString stringWithFormat:@"%@%@%@",clientId,[tempStr substringWithRange:NSMakeRange(i, 1)],[self getRandomCharacterAndNum]];
        }
        
    }
    
    //混淆
    if (clientId!=nil&&![clientId isEqualToString:@""]&&clientId.length>0) {
        clientId=[self encodeBase64String:[NSString stringWithFormat:@"%@",clientId]];
    }
    
    return clientId;
}

+(NSString *)getRandomCharacterAndNum{
    NSMutableArray * strArr = [NSMutableArray arrayWithArray:@[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]];
    int x =arc4random() % 36;
    if(x>=0&&x<strArr.count){
        return strArr[x];
    }
    NSLog(@"==============随机字母产生了异常================");
    return @"x";
}

+(NSString *)getOddString:(NSString *)str{
    NSString *rltStr=@"";
    if(str!=nil&&str.length>0){
        NSMutableArray<NSString *> *mArr = [[NSMutableArray alloc] init];
        for (int i=0; i<str.length; i++) {
            [mArr addObject:[str substringWithRange:NSMakeRange(i, 1)]];
        }
        
        for (int i=0; i<mArr.count; i++) {
            if(i%2==0){
                rltStr=[NSString stringWithFormat:@"%@%@",rltStr,mArr[i]];
            }
        }
    }
    
    return rltStr;
}

+(NSString *)getEvenString:(NSString *)str{
    NSString *rltStr=@"";
    if(str!=nil&&str.length>0){
        NSMutableArray<NSString *> *mArr = [[NSMutableArray alloc] init];
        for (int i=0; i<str.length; i++) {
            [mArr addObject:[str substringWithRange:NSMakeRange(i, 1)]];
        }
        
        for (int i=0; i<mArr.count; i++) {
            if(i%2==1){
                rltStr=[NSString stringWithFormat:@"%@%@",rltStr,mArr[i]];
            }
        }
    }
    return rltStr;
}

//加密

+ (NSString *)encodeToPercentEscapeString: (NSString *) input

{
    
    NSString *outputStr =
    
    (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                 
                                                                 NULL, /* allocator */
                                                                 
                                                                 (__bridge CFStringRef)input,
                                                                 
                                                                 NULL, /* charactersToLeaveUnescaped */
                                                                 
                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                 
                                                                 kCFStringEncodingUTF8);
    
    return outputStr;
    
}

//解码

+ (NSString *)decodeFromPercentEscapeString: (NSString *) input

{
    
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    
    [outputStr replaceOccurrencesOfString:@"+"
     
                               withString:@""
     
                                  options:NSLiteralSearch
     
                                    range:NSMakeRange(0,[outputStr length])];
    
    return
    
    [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
}

+(BOOL)isMobileForAU:(NSString *)mobile{
    if(mobile.length<9||mobile.length>10){
        return NO;
    }
    else if(mobile.length==9&&[mobile hasPrefix:@"0"]){
        return NO;
    }
    else if(mobile.length==10&&![mobile hasPrefix:@"0"]){
        return NO;
    }
    return YES;
}

@end
