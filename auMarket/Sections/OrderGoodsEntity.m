//
//  GoodsCartEntity.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/19.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "OrderGoodsEntity.h"

@implementation OrderGoodsEntity
-(id)init{
    self = [super init];
    if (self) {
        [self addMappingRuleArrayProperty:@"goods_list_normal" class:[OrderGoodsItemEntity class]];
        [self addMappingRuleArrayProperty:@"goods_list_alone" class:[OrderGoodsItemEntity class]];
    }
    return self;
}
@end


@implementation OrderGoodsItemEntity

@end

