//
//  GoodsCartEntity.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/19.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseEntity.h"
@class OrderGoodsItemEntity;

@interface OrderGoodsEntity:SPBaseEntity
@property(nonatomic,retain)NSMutableArray <OrderGoodsItemEntity*> *goods_list_normal;
@property(nonatomic,retain)NSMutableArray <OrderGoodsItemEntity*> *goods_list_alone;
@end

@interface OrderGoodsItemEntity : SPBaseEntity
@property(nonatomic,retain)NSString *goods_id;
@property(nonatomic,retain)NSString *goods_name;
@property(nonatomic,retain)NSString *goods_sn;
@property(nonatomic,retain)NSString *goods_number;
@property(nonatomic,retain)NSString *package;
@property(nonatomic,retain)NSString *thumb_url;


@end
