//
//  NSDateFormatter+IDPExtension.m
//  IDP
//
//  Created by xjz on 13-10-23.
//
//

#import "NSDateFormatter+IDPExtension.h"
#import "NSDictionary+IDPExtension.h"

static NSMutableDictionary *formatters = nil;

@implementation NSDateFormatter (IDPExtension)

+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)formmat
{
    return [self dateFormatterWithKey:[NSString stringWithFormat:@"<%@>",formmat] configBlock:^(NSDateFormatter *formatter)
    {
        if (formatter)
        {
            [formatter setDateFormat:formmat];
        }
    }];
}

+ (NSDateFormatter *)dateFormatterWithKey:(NSString *)key configBlock:(IDPDateFormmaterConfigBlock)cofigBlock
{ 
    NSString *strKey = nil;
    if (!key)
    {
        strKey = @"defaultFormatter";
    }
    else
    {
        strKey = [key copy];
    }
    
    @synchronized(self)
    {
        NSDateFormatter *dateFormatter = [[self formatters] objectForKey:strKey];
        if (!dateFormatter)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [[self formatters] safeSetObject:dateFormatter forKey:strKey];
            
            if (cofigBlock)
            {
                cofigBlock(dateFormatter); //配置它
            }
            return dateFormatter;
        }
        
        return dateFormatter;
    }
}

+ (NSMutableDictionary *)formatters
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!formatters)
        {
            formatters = [[NSMutableDictionary alloc] init];
        }
    });
    
    return formatters;
}

@end
