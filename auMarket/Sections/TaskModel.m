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
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=delivery_list&delivery_id=%@",@"999"];//user.user_id
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

-(void)loadDeliveryTimeSection{
    SPAccount *user=[[AccountManager sharedInstance] getCurrentUser];
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=getDeliveryTimeSection&delivery_id=37",user.user_id];
    self.parseDataClassType = [TimeSectionEntity class];
    self.params = @{};
    self.requestTag=3003;
    [self loadInner];
}

-(void)savePredictTime:(NSString *)ids andPredictTime:(NSString *)predict_time{
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=saveOrderPredictTime&ids=%@&predict_time=%@",ids,[Common encodeToPercentEscapeString:predict_time]];
    self.parseDataClassType = [SPBaseEntity class];
    self.params = @{};
    self.requestTag=3003;
    [self loadInner];
}

/**
 请求订单配送完成操作
 */
-(void)order_delivery_done:(NSString *)delivery_id andStatus:(NSString *)status andPayType:(NSString *)pay_type andImgPath:(NSString *)img_path andOrderSn:(NSString *)order_sn{
    SPAccount *user=[[AccountManager sharedInstance] getCurrentUser];
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=order_delivery_done&delivery_id=%@&status=%@&pay_type=%@&user_id=%@&img_path=%@&order_sn=%@",delivery_id,status,pay_type,user.user_id,img_path,order_sn];
    self.parseDataClassType = [TaskEntity class];
    self.params = @{};
    self.requestTag=3003;
    [self loadInner];
}

-(void)handleParsedData:(SPBaseEntity*)parsedData{
    if ([parsedData isKindOfClass:[TaskEntity class]]) {
        self.entity = (TaskEntity*)parsedData;
    }
    else if ([parsedData isKindOfClass:[OrderGoodsEntity class]]) {
        self.goods_entity = (OrderGoodsEntity*)parsedData;
    }
    else if ([parsedData isKindOfClass:[TimeSectionEntity class]]) {
        self.time_entity = (TimeSectionEntity*)parsedData;
    }
}

/**
 根据配送状态抽取配送列表
 */
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

/**
 抽取配送列表中，所有的配送时间段
 */
-(NSArray *)getSectionTimes{
    NSMutableArray *mArr=[[NSMutableArray alloc] init];
    if(self.entity.list){
        for(int i=0;i<self.entity.list.count;i++){
            NSString *section_time=[self formatSectionTime:[self.entity.list objectAtIndex:i].delivery_time];
            if(![mArr containsObject:section_time]){
                [mArr addObject:section_time];
            }
        }
    }
    return mArr;
}

-(NSString *)formatSectionTime:(NSString *)sectionTime{
    NSString * str=sectionTime;
    if(str){
        NSArray *array =[str componentsSeparatedByString:@" "];
        if(array){
            return [array lastObject];
        }
        else{
            return @"";
        }
    }
    else{
        return @"";
    }
}


-(TaskEntity *)entity{
    if(!_entity){
        _entity=[[TaskEntity alloc] init];
    }
    
    return _entity;
}
@end
