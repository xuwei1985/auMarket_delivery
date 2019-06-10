//
//  GoodsCartEntity.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/19.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "TaskEntity.h"


@implementation TaskEntity
-(id)init{
    self = [super init];
    if (self) {
        [self addMappingRuleArrayProperty:@"list" class:[TaskItemEntity class]];
    }
    return self;
}
@end


@implementation TaskItemEntity
-(id)init{
    self = [super init];
    if (self) {
        [self addMappingRuleArrayProperty:@"box_goods" class:[pGoodsEntity class]];
    }
    return self;
}

@end

@implementation pGoodsEntity : SPBaseEntity

@end
