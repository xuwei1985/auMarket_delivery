//
//  TaskModel.h
//  auMarket
//
//  Created by 吴绪伟 on 2017/9/13.
//  Copyright © 2017年 daao. All rights reserved.
//

#import "SPBaseModel.h"
#import "TaskEntity.h"
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

-(void)loadTaskList;
-(void)loadGoodsListForOrder:(NSString *)order_id;
//根据配送状态抽取配送列表
-(NSArray<TaskItemEntity *> *)getTasksByStatus:(Delivery_Status)status;
@end
