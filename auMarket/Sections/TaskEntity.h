//
//  GoodsCartEntity.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/19.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseEntity.h"
#import "PredictTimeEntity.h"

@class TaskItemEntity,pGoodsEntity;

@interface TaskEntity : SPBaseEntity
@property(nonatomic,retain)NSMutableArray <TaskItemEntity*> *list;
@end

@interface TaskItemEntity : SPBaseEntity
@property (nonatomic,retain) NSString *sid;//配送id
@property (nonatomic,retain) NSString *order_sn;
@property (nonatomic,retain) NSString *order_id;
@property(nonatomic,retain)NSString *pay_name;
@property(nonatomic,retain)NSString *pay_type;
@property(nonatomic,retain)NSString *address_replenish;
@property(nonatomic,retain)NSString *delivery_id;
@property(nonatomic,retain)NSString *package_note;
@property(nonatomic,retain)NSString *add_time;
@property(nonatomic,retain)NSString *longitude;
@property(nonatomic,retain)NSString *latitude;
@property (nonatomic,retain)NSString *return_price;
@property(nonatomic,assign)CLLocationCoordinate2D coordinate;
@property(nonatomic,retain)NSString *status;
@property(nonatomic,retain)NSString *predict_sms_send;
@property(nonatomic,assign)Boolean selected;
@property(nonatomic,retain)NSString *is_ready;//是否打包完成
@property(nonatomic,retain)NSString *option_title;//送货方式选项标题（送货上楼、下楼自取）
@property(nonatomic,retain)NSString *upstairs_mark;//送货方式标记（上楼up,下楼down）
@property(nonatomic,retain)NSString *put_type;//签收方式 1：放门口 0：面签
@property (nonatomic,retain) NSMutableArray<pGoodsEntity*> *box_goods;
@property (nonatomic,retain) NSString *predict_time;//预计配送时间
@property (nonatomic,retain) NSString *block_name;
@property (nonatomic,retain) NSString *consignee;
@property (nonatomic,retain) NSString *address;
@property (nonatomic,retain) NSString *mobile;
@property (nonatomic,retain) NSString *order_amount;
@property (nonatomic,retain) NSString *delivery_time;
@property (nonatomic,retain) NSString *shelf_code;
@property (nonatomic,retain) NSString *default_package;
@property (nonatomic,retain) NSString *box_package;
@property (nonatomic,retain) NSString *freeze_package;
@property (nonatomic,retain) NSString *refrigerate_package;
@property (nonatomic,retain) NSString *meat_package;
@property (nonatomic,retain) NSString *default_number;
@property (nonatomic,retain) NSString *freeze_number;
@property (nonatomic,retain) NSString *refrigerate_number;
@property (nonatomic,retain) NSString *meat_number;
@property (nonatomic,retain) NSString *default_package_pick;
@property (nonatomic,retain) NSString *box_package_pick;
@property (nonatomic,retain) NSString *freeze_package_pick;
@property (nonatomic,retain) NSString *refrigerate_package_pick;
@property (nonatomic,retain) NSString *meat_package_pick;

@property (nonatomic,retain) NSString *default_code;
@property (nonatomic,retain) NSArray *package_arr;
@end



@interface pGoodsEntity : SPBaseEntity
@property (nonatomic,retain) NSString *goods_number;
@property (nonatomic,retain) NSString *goods_name;
@property (nonatomic,retain) NSString *goods_image;
@end
