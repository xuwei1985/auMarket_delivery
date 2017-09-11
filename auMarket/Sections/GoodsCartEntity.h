//
//  GoodsCartEntity.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/19.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseEntity.h"
@class GoodsCartItemEntity;

@interface GoodsCartEntity : SPBaseEntity
@property(nonatomic,retain)NSMutableArray <GoodsCartItemEntity*> *cartlist;
@property(nonatomic,retain)NSString *number;
@property(nonatomic,retain)NSString *amount;
@end

@interface GoodsCartItemEntity : SPBaseEntity
@property(nonatomic,retain)NSString *rec_id;
@property(nonatomic,retain)NSString *goods_id;
@property(nonatomic,retain)NSString *goods_name;
@property(nonatomic,retain)NSString *market_price;
@property(nonatomic,retain)NSString *shop_price;
@property(nonatomic,retain)NSString *goods_number;
@property(nonatomic,retain)NSString *goods_thumb;
@property(nonatomic,retain)NSString *is_on_sale;
@property(nonatomic,retain)NSString *goods_weight;
@property(nonatomic,retain)NSString *is_alone_sale;
@property(nonatomic,retain)NSString *buy_number;
@end
