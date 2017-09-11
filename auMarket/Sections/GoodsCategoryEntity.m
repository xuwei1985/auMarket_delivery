//
//  GoodsCategoryEntity.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/12.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "GoodsCategoryEntity.h"

@implementation GoodsCategoryListEntity

-(id)init{
    self = [super init];
    if (self) {
        [self addMappingRuleArrayProperty:@"categorylist" class:[GoodsCategoryEntity class]];
    }
    return self;
}
@end


@implementation GoodsCategoryEntity

@end
