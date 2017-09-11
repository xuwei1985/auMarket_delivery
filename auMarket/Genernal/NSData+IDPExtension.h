//
//
//  NSData+IDPExtension.h
//  IDP
//
//  Created by douj on 13-3-6.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (IDPExtension)

- (NSData *)MD5;
- (NSString *)MD5String;
- (NSString *)UTF8String;

-(NSArray*)array;
-(NSDictionary*)dictionary;
@end
