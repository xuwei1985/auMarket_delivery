//
//  NSString+YP.m
//  Youpin
//
//  Created by douj on 15/4/27.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import "NSString+YP.h"
#import <CommonCrypto/CommonDigest.h>

#define FileHashDefaultChunkSizeForReadingData 1024*8

@implementation NSString(YP)

+(NSString*)getNoNilString:(NSString*)str
{
    return str? str :@"";
}
-(BOOL)isEmpty
{
    if (self.length == 0) {
        return YES;
    }
    return NO;
}
- (BOOL)isValidateContent{
    if ([self isEmpty]) {
        return NO;
    }
 
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \n"]];
    if ([str isEmpty] || str == nil) {
        return NO;
    }
    
    return YES;
}
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (NSString *)URLEncoding
{
    NSString * result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault,
                                                                            (CFStringRef)self,
                                                                            NULL,
                                                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                            kCFStringEncodingUTF8 ));
    return result;
}

- (NSString *)UTF8Encoding
{
    NSString * result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault,
                                                                            (CFStringRef)self,
                                                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                            NULL,
                                                                            kCFStringEncodingUTF8 ));
    return result;
}

- (NSString *)URLDecoding
{
    NSString * result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8));
    return result;
}

- (CGFloat)widthWithSystemFontSize:(NSInteger)size {
   return [self sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]}].width;
}

- (CGFloat)widthWithBoldSystemFontSize:(NSInteger)size {
    return [self sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:size]}].width;
}

- (CGFloat)heightWidthSystemFontSize:(NSInteger)size width:(CGFloat)width {
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, 99999) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size],NSParagraphStyleAttributeName : [NSParagraphStyle defaultParagraphStyle]} context:nil];
    return ceilf(rect.size.height);
}

- (CGFloat)heightWidthBoldSystemFontSize:(NSInteger)size width:(CGFloat)width {
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, 99999) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:size],NSParagraphStyleAttributeName : [NSParagraphStyle defaultParagraphStyle]} context:nil];
    return ceilf(rect.size.height);
}

- (BOOL)containsString:(NSString *)aString
{
    if (!aString) {
        return NO;
    }
    NSRange range = [self rangeOfString:aString];
    if (range.location == NSNotFound) {
        return NO;
    }
    return YES;
}
- (NSString *)MD5String
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(NSString*)getFileMD5WithPath:(NSString*)path
{
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);
    
}
CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
    
    // Declare needed variables
    
    CFStringRef result = NULL;
    
    CFReadStreamRef readStream = NULL;
    
    // Get the file URL
    
    CFURLRef fileURL =
    
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  
                                  (CFStringRef)filePath,
                                  
                                  kCFURLPOSIXPathStyle,
                                  
                                  (Boolean)false);
    
    if (!fileURL) goto done;
    
    // Create and open the read stream
    
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            
                                            (CFURLRef)fileURL);
    
    if (!readStream) goto done;
    
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    
    if (!didSucceed) goto done;
    
    // Initialize the hash object
    
    CC_MD5_CTX hashObject;
    
    CC_MD5_Init(&hashObject);
    
    // Make sure chunkSizeForReadingData is valid
    
    if (!chunkSizeForReadingData) {
        
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
        
    }
    
    // Feed the data to the hash object
    
    bool hasMoreData = true;
    
    while (hasMoreData) {
        
        uint8_t buffer[chunkSizeForReadingData];
        
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        
        if (readBytesCount == -1) break;
        
        if (readBytesCount == 0) {
            
            hasMoreData = false;
            
            continue;
            
        }
        
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
        
    }
    
    // Check if the read operation succeeded
    
    didSucceed = !hasMoreData;
    
    // Compute the hash digest
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5_Final(digest, &hashObject);
    
    // Abort if the read operation failed
    
    if (!didSucceed) goto done;
    
    // Compute the string result
    
    char hash[2 * sizeof(digest) + 1];
    
    for (size_t i = 0; i < sizeof(digest); ++i) {
        
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
        
    }
    
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
    
    
    
done:
    
    if (readStream) {
        
        CFReadStreamClose(readStream);
        
        CFRelease(readStream);
        
    }
    
    if (fileURL) {
        
        CFRelease(fileURL);
        
    }
    
    return result;
    
}

@end
