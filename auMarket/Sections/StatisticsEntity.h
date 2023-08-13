//
//  GoodsCartEntity.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/19.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseEntity.h"

@interface DeliveryStateEntity : SPBaseEntity
@property(nonatomic,retain)NSString *total_num;
@property(nonatomic,retain)NSString *picked_num;
@property(nonatomic,retain)NSString *predict_num;
@end
