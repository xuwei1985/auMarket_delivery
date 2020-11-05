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
@property(nonatomic,retain)NSString *is_fixed_point;//是否特价
@property(nonatomic,retain)NSString *shop_price;
@property(nonatomic,retain)NSString *promote_price;//促销价格
@property(nonatomic,retain)NSString *promote_start_date;//促销开始时间
@property(nonatomic,retain)NSString *promote_end_date;//促销结束时间
@property(nonatomic,retain)NSString *is_promote;//是否促销

@end
