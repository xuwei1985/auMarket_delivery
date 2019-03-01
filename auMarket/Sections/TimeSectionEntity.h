//
//  BannerEntity.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/28.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseEntity.h"
@class TimeItemEntity;

@interface TimeSectionEntity : SPBaseEntity
@property (nonatomic,retain) NSMutableArray<TimeItemEntity*> *list;
@end

@interface TimeItemEntity : SPBaseEntity
@property (nonatomic,retain) NSString *receiving_time;
@property (nonatomic,retain) NSString *receiving_begin;
@property (nonatomic,retain) NSString *receiving_end;
@property (nonatomic,retain) NSString *shipping_date_id;
@end
