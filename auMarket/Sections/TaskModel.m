//
//  TaskModel.m
//  auMarket
//
//  Created by 吴绪伟 on 2017/9/13.
//  Copyright © 2017年 daao. All rights reserved.
//

#import "TaskModel.h"

@implementation TaskModel
-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)loadTaskList{
    SPAccount *user=[[AccountManager sharedInstance] getCurrentUser];
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=delivery_list&delivery_id=%@",user.user_id];
    self.parseDataClassType = [TaskEntity class];
    self.params = @{};
    self.requestTag=3001;
    [self loadInner];
}

-(void)loadGoodsListForOrder:(NSString *)order_id{
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=order_goods_list&order_id=%@",order_id];
    self.parseDataClassType = [OrderGoodsEntity class];
    self.params = @{};
    self.requestTag=3002;
    [self loadInner];
}


-(void)handleParsedData:(SPBaseEntity*)parsedData{
    if ([parsedData isKindOfClass:[TaskEntity class]]) {
        self.entity = (TaskEntity*)parsedData;
    }
    else if ([parsedData isKindOfClass:[OrderGoodsEntity class]]) {
        self.goods_entity = (OrderGoodsEntity*)parsedData;
    }

}

//根据配送状态抽取配送列表
-(NSArray<TaskItemEntity *> *)getTasksByStatus:(Delivery_Status)status{
    NSArray<TaskItemEntity *> *mArr=[[NSMutableArray alloc] init];
    if(self.entity.list){
        if(status==Delivery_Status_Unknow){
            NSString *filterStr=[NSString stringWithFormat:@"longitude=='' or latitude==''"];
            NSPredicate *predicate=[NSPredicate predicateWithFormat:filterStr];
            mArr=[self.entity.list filteredArrayUsingPredicate:predicate];
        }
        else{
            NSString *filterStr=[NSString stringWithFormat:@"status=='%d'",status];
            NSPredicate *predicate=[NSPredicate predicateWithFormat:filterStr];
            mArr=[self.entity.list filteredArrayUsingPredicate:predicate];
        }
    }
    return mArr;
}

-(TaskEntity *)entity{
    if(!_entity){
        _entity=[[TaskEntity alloc] init];
    }
    
    return _entity;
}
@end
