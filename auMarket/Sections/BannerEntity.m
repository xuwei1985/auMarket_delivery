//
//  BannerEntity.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/28.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "BannerEntity.h"

@implementation BannerEntity
-(id)init{
    self = [super init];
    if (self) {
        [self addMappingRuleArrayProperty:@"banners" class:[BannerItemEntity class]];
    }
    return self;
}
@end


@implementation BannerItemEntity : SPBaseEntity

@end
