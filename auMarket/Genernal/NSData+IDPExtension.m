//
//
//  NSData+IDPExtension.m
//  IDP
//
//  Created by douj on 13-3-6.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "NSData+IDPExtension.h"
#import "b64.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (IDPExtension)

- (NSData *)MD5
{
	unsigned char md5Result[CC_MD5_DIGEST_LENGTH + 1];
	CC_MD5( [self bytes], (unsigned int)[self length], md5Result );
	
	NSMutableData * retData = [[NSMutableData alloc] init];
	if ( nil == retData )
		return nil;
	
	[retData appendBytes:md5Result length:CC_MD5_DIGEST_LENGTH];
	return retData;
}

- (NSString *)MD5String
{
	NSData * value = [self MD5];
	if ( value )
	{
		char			tmp[16];
		unsigned char *	hex = (unsigned char *)malloc( 2048 + 1 );
		unsigned char *	bytes = (unsigned char *)[value bytes];
		unsigned long	length = [value length];
		
		hex[0] = '\0';
		
		for ( unsigned long i = 0; i < length; ++i )
		{
			sprintf( tmp, "%02X", bytes[i] );
			strcat( (char *)hex, tmp );
		}
		
		NSString * result = [NSString stringWithUTF8String:(const char *)hex];
		free( hex );
		return result;
	}
	else
	{
		return nil;
	}
}

- (NSString *)UTF8String
{
    NSString *string = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    return string;
}


-(NSArray*)array
{
    NSArray* arr= [NSKeyedUnarchiver unarchiveObjectWithData:self];
    return arr;
}
-(NSDictionary*)dictionary
{
    NSDictionary* dictionary= [NSKeyedUnarchiver unarchiveObjectWithData:self];
    return dictionary;
}
@end
