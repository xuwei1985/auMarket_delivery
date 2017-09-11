//
//  YPEntityResponseSerialization.m
//  Youpin
//
//  Created by DouJ on 15/3/8.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import "SPEntityResponseSerialization.h"
#import "SPBaseEntity.h"
@implementation SPEntityResponseSerialization

+ (instancetype)serializer {
    return [self serializerWithReadingOptions:(NSJSONReadingOptions)0];
}

+ (instancetype)serializerWithReadingOptions:(NSJSONReadingOptions)readingOptions {
    SPEntityResponseSerialization *serializer = [[self alloc] init];
    serializer.readingOptions = readingOptions;
    NSMutableSet* mutableSet = [[NSMutableSet alloc] initWithSet:serializer.acceptableContentTypes];
    [mutableSet addObject:@"application/x-javascript"];
    [mutableSet addObject:@"text/html"];
    serializer.acceptableContentTypes = mutableSet;
    
    return serializer;
}



#pragma mark - AFURLResponseSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
   
    id responseObject = [super responseObjectForResponse:response data:data error:error];
    
    if (![self.parseDataClassType isSubclassOfClass:[SPBaseEntity class]])
    {
        IDPLogWarning(0, @"parseDataType is not TBCBaseItem class");
        return responseObject;
    }
    if (![responseObject isKindOfClass:[NSDictionary class]]) {
        return responseObject;
    }
    NSDictionary* responseData = responseObject;
   
    SPBaseEntity* item = [(SPBaseEntity*)[self.parseDataClassType alloc] initWithData: [responseData dictAtPath:@"data"]] ;
    [item setCode:[responseData stringAtPath:@"code"]];
    [item setErr_msg:[responseData stringAtPath:@"msg"]];
    
    return item;
}

@end
