//
//  BannerEntity.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/28.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseEntity.h"
@class PickItemEntity,PackageGoodsEntity,DeliveryInfoEntity;

@interface PickEntity : SPBaseEntity
@property (nonatomic,retain) NSMutableArray<PickItemEntity*> *list;
@property (nonatomic,retain) NSString *next;//下一页
@end

@interface PickItemEntity : SPBaseEntity
@property (nonatomic,retain) NSString *sid;//配送id
@property (nonatomic,retain) NSString *order_sn;
@property (nonatomic,retain) NSString *order_id;
@property (nonatomic,retain) NSString *predict_time;//预计配送时间
@property (nonatomic,retain) NSString *block_name;
@property (nonatomic,retain) NSString *consignee;
@property (nonatomic,retain) NSMutableArray<PackageGoodsEntity*> *box_goods;
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
@property (nonatomic,retain) NSString *is_ready;
@property (nonatomic,retain) NSArray *package_arr;
@property (nonatomic,retain) NSString *package_note;
@property (nonatomic,retain) NSString *service_note;
@property (nonatomic,retain) NSString *package_freeze_note;
@property (nonatomic,retain) NSArray<DeliveryInfoEntity*> *delivery_info;

@end


@interface PackageGoodsEntity : SPBaseEntity
@property (nonatomic,retain) NSString *goods_number;
@property (nonatomic,retain) NSString *goods_name;
@property (nonatomic,retain) NSString *goods_image;
@end

