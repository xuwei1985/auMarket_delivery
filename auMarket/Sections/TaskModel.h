//
//  TaskModel.h
//  auMarket
//
//  Created by 吴绪伟 on 2017/9/13.
//  Copyright © 2017年 daao. All rights reserved.
//

#import "SPBaseModel.h"
#import "TaskEntity.h"

typedef enum {
    Delivery_Status_Delivering = 0,
    Delivery_Status_Finished = 1,
    Delivery_Status_Failed = 2
} Delivery_Status;

@interface TaskModel : SPBaseModel
@property (nonatomic,retain) TaskEntity *entity;

-(void)loadTaskList;
//根据配送状态抽取配送列表
-(NSArray<TaskItemEntity *> *)getTasksByStatus:(Delivery_Status)status;
@end
