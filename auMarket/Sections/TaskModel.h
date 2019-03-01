//
//  TaskModel.h
//  auMarket
//
//  Created by 吴绪伟 on 2017/9/13.
//  Copyright © 2017年 daao. All rights reserved.
//

#import "SPBaseModel.h"
#import "TaskEntity.h"
#import "TimeSectionEntity.h"
#import "OrderGoodsEntity.h"

typedef enum {
    Delivery_Status_Delivering = 0,
    Delivery_Status_Finished = 1,
    Delivery_Status_Failed = 2,
    Delivery_Status_Unknow = 3,
    Delivery_Status_Multi = 4//用于首页地图多订单去列表展示的数据模式
} Delivery_Status;

@interface TaskModel : SPBaseModel
@property (nonatomic,retain) TaskEntity *entity;
@property (nonatomic,retain) OrderGoodsEntity *goods_entity;
@property (nonatomic,retain) TimeSectionEntity *time_entity;

-(void)loadTaskList;
-(void)loadDeliveryTimeSection;
-(void)loadGoodsListForOrder:(NSString *)order_id;
-(void)order_delivery_done:(NSString *)delivery_id andStatus:(NSString *)status andPayType:(NSString *)pay_type andImgPath:(NSString *)img_path andOrderSn:(NSString *)order_sn;
//根据配送状态抽取配送列表
-(NSArray<TaskItemEntity *> *)getTasksByStatus:(Delivery_Status)status;
-(void)savePredictTime:(NSString *)ids andPredictTime:(NSString *)predict_time;
@end
