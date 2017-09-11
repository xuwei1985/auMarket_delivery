//
//  GoodsListEntity.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/19.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseEntity.h"
@class GoodsListItemEntity;

@interface GoodsListEntity : SPBaseEntity
@property(nonatomic,retain)NSMutableArray <GoodsListItemEntity*> *list;
@property(nonatomic,retain)NSString *tid;
@end

@interface GoodsListItemEntity : SPBaseEntity
@property(nonatomic,retain)NSString *goods_id;
@property(nonatomic,retain)NSString *goods_name;
@property(nonatomic,retain)NSString *market_price;
@property(nonatomic,retain)NSString *shop_price;
@property(nonatomic,retain)NSString *promote_price;
@property(nonatomic,retain)NSString *is_new;
@property(nonatomic,retain)NSString *is_best;
@property(nonatomic,retain)NSString *is_hot;
@property(nonatomic,retain)NSString *goods_type;
@property(nonatomic,retain)NSString *goods_thumb;
@end
