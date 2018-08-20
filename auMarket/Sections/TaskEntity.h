//
//  GoodsCartEntity.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/19.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseEntity.h"
#import "PredictTimeEntity.h"
@class TaskItemEntity;

@interface TaskEntity : SPBaseEntity
@property(nonatomic,retain)NSMutableArray <TaskItemEntity*> *list;
@end

@interface TaskItemEntity : SPBaseEntity
@property(nonatomic,retain)NSString *sid;
@property(nonatomic,retain)NSString *order_amount;
@property(nonatomic,retain)NSString *pay_name;
@property(nonatomic,retain)NSString *pay_type;
@property(nonatomic,retain)NSString *address;
@property(nonatomic,retain)NSString *address_replenish;
@property(nonatomic,retain)NSString *order_id;
@property(nonatomic,retain)NSString *order_sn;
@property(nonatomic,retain)NSString *delivery_id;
@property(nonatomic,retain)NSString *delivery_time;
@property(nonatomic,retain)NSString *predict_time;//预计送达时间
@property(nonatomic,retain)NSString *package_note;
@property(nonatomic,retain)NSString *mobile;
@property(nonatomic,retain)NSString *add_time;
@property(nonatomic,retain)NSString *consignee;
@property(nonatomic,retain)NSString *longitude;
@property(nonatomic,retain)NSString *latitude;
@property(nonatomic,assign)CLLocationCoordinate2D coordinate;
@property(nonatomic,retain)NSString *status;
@property(nonatomic,retain)NSString *predict_sms_send;
@property(nonatomic,assign)Boolean selected;
@property(nonatomic,retain)NSString *block_name;
@property(nonatomic,retain)NSString *is_ready;//是否打包完成
@property(nonatomic,retain)NSString *option_title;//送货方式选项（送货上楼、下楼自取）
@end
