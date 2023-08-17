//
//  GoodsCartEntity.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/19.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseEntity.h"
#import "PredictTimeEntity.h"

@class TaskItemEntity,pGoodsEntity,DeliveryInfoEntity;

@interface TaskEntity : SPBaseEntity
@property(nonatomic,retain)NSMutableArray <TaskItemEntity*> *list;
@property (nonatomic,retain) NSString *nextpage;
@end

@interface TaskItemEntity : SPBaseEntity
@property (nonatomic,retain) NSString *order_sn;
@property (nonatomic,retain) NSString *order_id;
@property(nonatomic,retain) NSString *pay_name;
@property(nonatomic,retain) NSString *pay_type;
@property(nonatomic,retain) NSString *address_replenish;
@property(nonatomic,retain) NSString *delivery_id;
@property(nonatomic,retain) NSString *service_note;
@property(nonatomic,retain) NSString *package_note;
@property(nonatomic,retain) NSString *package_freeze_note;
@property(nonatomic,retain) NSString *package_food_note;
//@property(nonatomic,retain) NSString *add_time;
@property(nonatomic,retain) NSString *longitude;
@property(nonatomic,retain) NSString *latitude;
@property (nonatomic,retain) NSString *return_price;
@property (nonatomic,retain) NSString *return_price_pre;//系统根据订单金额计算的理论返现金额
@property (nonatomic,retain) NSString *change_price;
@property (nonatomic,retain) NSString *shipping_fee;
@property(nonatomic,assign) CLLocationCoordinate2D coordinate;
@property(nonatomic,retain) NSString *status;
@property(nonatomic,assign) Boolean selected;
@property(nonatomic,retain) NSString *is_ready;//是否打包完成
@property(nonatomic,retain) NSString *option_title;//送货方式选项标题（送货上楼、下楼自取）
@property(nonatomic,retain) NSString *upstairs_mark;//送货方式标记（上楼up,下楼down）
@property(nonatomic,retain) NSString *put_type;//签收方式 1：放门口 0：面签
@property (nonatomic,retain) NSMutableArray<pGoodsEntity*> *box_goods;
@property (nonatomic,retain) NSString *predict_time;//预计配送时间
@property (nonatomic,retain) NSString *predict_add_time;//设置配送顺序的时间（时间大小作为排序）
@property (nonatomic,retain) NSString *block_name;
@property (nonatomic,retain) NSString *consignee;
@property (nonatomic,retain) NSString *address;
@property (nonatomic,retain) NSString *mobile;
@property (nonatomic,retain) NSString *order_amount;
@property (nonatomic,retain) NSString *delivery_time;
@property (nonatomic,retain) NSString *shelf_code;
@property (nonatomic,retain) NSString *default_package;
@property (nonatomic,retain) NSString *box_package;
@property (nonatomic,retain) NSString *food_package;
@property (nonatomic,retain) NSString *freeze_package;
@property (nonatomic,retain) NSString *refrigerate_package;
@property (nonatomic,retain) NSString *meat_package;
@property (nonatomic,retain) NSString *default_number;
@property (nonatomic,retain) NSString *food_number;
@property (nonatomic,retain) NSString *freeze_number;
@property (nonatomic,retain) NSString *refrigerate_number;
@property (nonatomic,retain) NSString *meat_number;
@property (nonatomic,retain) NSString *default_package_pick;
@property (nonatomic,retain) NSString *box_package_pick;
@property (nonatomic,retain) NSString *food_package_pick;
@property (nonatomic,retain) NSString *freeze_package_pick;
@property (nonatomic,retain) NSString *refrigerate_package_pick;
@property (nonatomic,retain) NSString *meat_package_pick;

@property (nonatomic,retain) NSString *default_code;
@property (nonatomic,retain) NSArray *package_arr;
@property (nonatomic,retain) NSArray<DeliveryInfoEntity*> *delivery_info;
@end



@interface pGoodsEntity : SPBaseEntity
@property (nonatomic,retain) NSString *goods_number;
@property (nonatomic,retain) NSString *goods_name;
@property (nonatomic,retain) NSString *goods_image;
@end

@interface OrderFlowEntity : SPBaseEntity
@property (nonatomic,retain) NSString *order_id;
@property (nonatomic,retain) NSString *order_status;
@property (nonatomic,retain) NSString *shipping_status;
@property (nonatomic,retain) NSString *box;
@property (nonatomic,retain) NSString *picker;
@property (nonatomic,retain) NSString *pick_begin_time;
@property (nonatomic,retain) NSString *pick_end_time;
@property (nonatomic,retain) NSString *packer;
@property (nonatomic,retain) NSString *pack_begin_time;
@property (nonatomic,retain) NSString *pack_end_time;

@end



@interface DeliveryInfoEntity : SPBaseEntity
@property (nonatomic,retain) NSString *flow_name;
@property (nonatomic,retain) NSString *add_time;
@property (nonatomic,retain) NSString *staff;
@end


@interface ShippingTimeEntity : SPBaseEntity
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,retain) NSString *begin_time;
@property (nonatomic,retain) NSString *end_time;
@end


@interface PredictOrderDataEntity : SPBaseEntity
@property (nonatomic,retain) NSString *total_count; // 时间段内分配给该配送员的订单数
@property (nonatomic,retain) NSString *error_count; //error_count > 0 未处理predict_time的订单数
@end



