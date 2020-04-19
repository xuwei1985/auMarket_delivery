//
//  MemberLoginEntity.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/25.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "VerifyMobileEntity.h"

@implementation VerifyMobileListEntity
-(id)init{
    self = [super init];
    if (self) {
        [self addMappingRuleArrayProperty:@"verify_account_list" class:[VerifyMobileEntity class]];
    }
    return self;
}
@end


@implementation VerifyMobileEntity
-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}
@end


@implementation OrderVerifyEntity

@end
