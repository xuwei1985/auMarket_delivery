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
#import "StatisticsEntity.h"

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
@property (nonatomic,retain) OrderFlowEntity *flow_entity;
@property (nonatomic,retain) PredictOrderDataEntity *predict_order_entity;
@property (nonatomic,retain) DeliveryStateEntity *deliver_state_entity;

-(void)loadTaskList;
-(void)loadDeliveryTimeSection;
-(void)loadGoodsListForOrder:(NSString *)order_id;
-(void)order_delivery_done:(NSString *)delivery_id andStatus:(NSString *)status andPayType:(int)pay_type andImgPath:(NSString *)img_path andOrderSn:(NSString *)order_sn andMsg:(NSString *)msg andBank:(NSString *)bank_id;
//根据配送状态抽取配送列表
-(NSArray<TaskItemEntity *> *)getTasksByStatus:(Delivery_Status)status;
-(NSArray *)getSectionTimes;
-(void)savePredictTime:(NSString *)ids;
-(void)saveOrderReturnInfo:(NSString *)order_id andReturnPrice:(int)price andProof:(NSString *)proof_path andMsg:(NSString *)msg;
-(void)saveOrderChangePrice:(NSString *)order_id andChagePrice:(float)price andProof:(NSString *)proof_path andMsg:(NSString *)msg;
-(void)loadOrderFlowInfo:(NSString *)order_id;
-(void)loadPredictOrderData:(int)shipping_date_id;
-(void)predictOrderSet:(NSString *)shipping_date_id andSize:(NSString *)size_num andList:(NSString *)list;
-(void)getDeliveryStates;
@end
