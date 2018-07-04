//
//  BannerEntity.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/28.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "PickEntity.h"

@implementation PickEntity
-(id)init{
    self = [super init];
    if (self) {
        [self addMappingRuleArrayProperty:@"list" class:[PickItemEntity class]];
    }
    return self;
}
@end


@implementation PickItemEntity : SPBaseEntity
-(id)init{
    self = [super init];
    if (self) {
        [self addMappingRuleArrayProperty:@"box_goods" class:[PackageGoodsEntity class]];
    }
    return self;
}
@end

@implementation PackageGoodsEntity : SPBaseEntity

@end

