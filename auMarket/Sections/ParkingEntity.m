//
//  GoodsCartEntity.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/19.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "ParkingEntity.h"

@implementation ParkingEntity
-(id)init{
    self = [super init];
    if (self) {
        [self addMappingRuleArrayProperty:@"list" class:[ParkingItemEntity class]];
    }
    return self;
}
@end


@implementation ParkingItemEntity

@end

