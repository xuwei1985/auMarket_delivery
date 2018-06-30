//
//  BannerModel.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/28.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "TaskEntity.h"

@interface PredictTaskModel : SPBaseModel
@property (nonatomic,retain) TaskEntity *entity;

-(void)predict_task_list;
@end
