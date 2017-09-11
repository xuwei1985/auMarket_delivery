//
//  GoodsCartEntity.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/19.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseEntity.h"
@class TaskItemEntity;

@interface TaskEntity : SPBaseEntity
@property(nonatomic,retain)NSMutableArray <TaskItemEntity*> *tasklist;
@end

@interface TaskItemEntity : SPBaseEntity
@property(nonatomic,retain)NSString *task_id;
@property(nonatomic,retain)NSString *task_address;
@end
