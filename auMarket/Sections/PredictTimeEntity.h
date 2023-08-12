//
//  BannerEntity.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/28.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseEntity.h"

@interface PredictTimeEntity : SPBaseEntity
@property (nonatomic,retain) NSString *start_time;
@property (nonatomic,retain) NSString *end_time;
@property (nonatomic,retain) NSString *time_range;
@property (nonatomic,retain) NSString *section_range; //所属订单分段区间
@end
