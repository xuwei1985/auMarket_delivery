//
//  BannerEntity.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/28.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "TimeSectionEntity.h"

@implementation TimeSectionEntity
-(id)init{
    self = [super init];
    if (self) {
        [self addMappingRuleArrayProperty:@"list" class:[TimeItemEntity class]];
    }
    return self;
}
@end


@implementation TimeItemEntity : SPBaseEntity

@end
