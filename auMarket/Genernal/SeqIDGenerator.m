//
//  SeqIDGenerator.m
//  pgy
//
//  Created by zhanghe on 15/6/10.
//  Copyright (c) 2015年 com.xuwei. All rights reserved.
//

#import "SeqIDGenerator.h"

@implementation SeqIDGenerator

DEF_SINGLETON(SeqIDGenerator)

- (NSString *)seqId {
    CFTimeInterval time = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%lld%d", (unsigned long long)(time * 1000), [self getRandomNumber:10000 to:900000]];
}

- (int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

@end
