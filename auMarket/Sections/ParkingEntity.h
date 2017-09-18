//
//  GoodsCartEntity.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/19.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseEntity.h"
@class ParkingItemEntity;

@interface ParkingEntity : SPBaseEntity
@property(nonatomic,retain)NSMutableArray <ParkingItemEntity*> *list;
@end

@interface ParkingItemEntity : SPBaseEntity
@property(nonatomic,retain)NSString *parking_name;
@property(nonatomic,retain)NSString *parking_address;
@property(nonatomic,retain)NSString *latitude;
@property(nonatomic,retain)NSString *longitude;
@end
