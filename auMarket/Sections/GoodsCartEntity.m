//
//  GoodsCartEntity.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/19.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "GoodsCartEntity.h"

@implementation GoodsCartEntity
-(id)init{
    self = [super init];
    if (self) {
        [self addMappingRuleArrayProperty:@"cartlist" class:[GoodsCartItemEntity class]];
    }
    return self;
}
@end


@implementation GoodsCartItemEntity

@end

