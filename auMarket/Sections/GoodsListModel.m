//
//  GoodsCategoryModel.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/12.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "GoodsListModel.h"


@implementation GoodsListModel

-(instancetype)init{
    self = [super init];
    if (self) {
        self.shortRequestAddress=@"apiv1.php?act=goods_list";
        self.parseDataClassType = [GoodsListEntity class];
        self.entity.err_msg=@"未获取到有效的商品数据";
    }
    return self;
}

-(void)loadGoodsList{
    self.params = @{
        @"tid":(self.tid==nil?@"0":self.tid),
        @"catid":(self.catid==nil?@"0":self.catid),
        @"sort":(self.sort==nil?@"0":self.sort),
        @"key":(self.keyword==nil?@"":self.keyword)
    };
    [self loadInner];
}

-(void)handleParsedData:(SPBaseEntity*)parsedData{
    if ([parsedData isKindOfClass:[GoodsListEntity class]]) {
        self.entity = (GoodsListEntity*)parsedData;
    }
}


-(GoodsListEntity *)entity{
    if(!_entity){
        _entity=[[GoodsListEntity alloc] init];
    }
    
    return _entity;
}
@end
