//
//  SeqIDGenerator.h
//  pgy
//
//  Created by zhanghe on 15/6/10.
//  Copyright (c) 2015年 com.xuwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeqIDGenerator : NSObject

DEC_SINGLETON(SeqIDGenerator)

- (NSString *)seqId;

@end
