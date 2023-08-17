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
    
    NSString *nextpage=@"1";
    if(self.entity!=nil&&self.entity.nextpage.length>0){
        nextpage=self.entity.nextpage;
    }
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=delivery_list&delivery_id=%@&nextpage=%@",user.user_id,nextpage];
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

//MARK: 获取配送员的配送时间段
-(void)loadDeliveryTimeSection{
    SPAccount *user=[[AccountManager sharedInstance] getCurrentUser];
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=getDeliveryTimeSection&delivery_id=%@",user.user_id];
    self.parseDataClassType = [TimeSectionEntity class];
    self.params = @{};
    self.requestTag=3007;
    [self loadInner];
}

//MARK:  获取需要配置预计送达时间的订单总数
-(void)loadPredictOrderData:(int)shipping_date_id{
    SPAccount *user=[[AccountManager sharedInstance] getCurrentUser];
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=deliver_order_count&deliver_id=%@&shipping_date_id=%d",user.user_id,shipping_date_id];
    self.parseDataClassType = [PredictOrderDataEntity class];
    self.params = @{};
    self.requestTag=3010;
    [self loadInner];
}

//MARK: 请求预计送达批量设置
-(void)predictOrderSet:(NSString *)shipping_date_id andSize:(NSString *)size_num andList:(NSString *)list{
    SPAccount *user=[[AccountManager sharedInstance] getCurrentUser];
    
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=deliver_order_sort"];
    self.parseDataClassType = [TaskEntity class];
    self.params = @{@"deliver_id":user.user_id,@"shipping_date_id":shipping_date_id,@"size":size_num,@"list":list};
    self.requestTag=3011;
    [self loadInner];
}

-(void)savePredictSerial:(NSString *)ids{
    SPAccount *user=[[AccountManager sharedInstance] getCurrentUser];
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=savePredictSerial&ids=%@&deliver_id=%@",ids,user.user_id];
    self.parseDataClassType = [TaskItemEntity class];
    self.params = @{};
    self.requestTag=3003;
    [self loadInner];
}

-(void)saveOrderReturnInfo:(NSString *)order_id andReturnPrice:(int)price andProof:(NSString *)proof_path andMsg:(NSString *)msg{
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=saveOrderReturnInfo&order_id=%@&return_price=%d&proof=%@&msg=%@",order_id,price,proof_path,[Common encodeToPercentEscapeString:msg]];
    self.parseDataClassType = [SPBaseEntity class];
    self.params = @{};
    self.requestTag=3004;
    [self loadInner];
}

-(void)saveOrderChangePrice:(NSString *)order_id andChagePrice:(float)price andProof:(NSString *)proof_path andMsg:(NSString *)msg{
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=saveOrderPriceChange&order_id=%@&change_price=%f&proof_path=%@&msg=%@",order_id,price,proof_path,[Common encodeToPercentEscapeString:msg]];
    self.parseDataClassType = [SPBaseEntity class];
    self.params = @{};
    self.requestTag=3005;
    [self loadInner];
}


-(void)loadOrderFlowInfo:(NSString *)order_id{
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=order_flow_info&order_id=%@",order_id];
    self.parseDataClassType = [OrderFlowEntity class];
    self.params = @{};
    self.requestTag=3006;
    [self loadInner];
}



//获取配送员的预计送达时间设置统计数据和上货统计数据
-(void)getDeliveryStates{
    SPAccount *user=[[AccountManager sharedInstance] getCurrentUser];
    self.parseDataClassType = [DeliveryStateEntity class];
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=getDeliveryStates&delivery_id=%@",user.user_id];
    self.params = @{};
    self.requestTag=3012;
    [self loadInner];
}

//MARK: 请求订单配送完成操作
-(void)order_delivery_done:(NSString *)delivery_id andStatus:(NSString *)status andPayType:(int)pay_type andImgPath:(NSString *)img_path andOrderSn:(NSString *)order_sn andMsg:(NSString *)msg andBank:(NSString *)bank_id{
    SPAccount *user=[[AccountManager sharedInstance] getCurrentUser];

    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=order_delivery_done&delivery_id=%@&status=%@&pay_type=%d&user_id=%@&img_path=%@&order_sn=%@&msg=%@&bank=%@",delivery_id,status,pay_type,user.user_id,img_path,order_sn,[Common encodeToPercentEscapeString:msg],bank_id];
    self.parseDataClassType = [TaskEntity class];
    self.params = @{};
    self.requestTag=3008;
    [self loadInner];
}

-(void)handleParsedData:(SPBaseEntity*)parsedData{
    if ([parsedData isKindOfClass:[TaskEntity class]]) {
        TaskEntity *responseEntity=[self convertDeliverydata:(TaskEntity*)parsedData];
        if(self.entity!=nil && self.entity.list!=nil && self.entity.list.count>0&&[self.entity.nextpage intValue]>1){
            [self.entity.list addObjectsFromArray:responseEntity.list];
            self.entity.nextpage=responseEntity.nextpage;
        }else{
            self.entity=responseEntity;
        }
            
        if([self.entity.nextpage intValue]>0){
            [self loadTaskList];
        }
    }
    else if ([parsedData isKindOfClass:[OrderGoodsEntity class]]) {
        self.goods_entity = (OrderGoodsEntity*)parsedData;
    }
    else if ([parsedData isKindOfClass:[TimeSectionEntity class]]) {
        self.time_entity = (TimeSectionEntity*)parsedData;
    }
    else if ([parsedData isKindOfClass:[OrderFlowEntity class]]) {
        self.flow_entity = (OrderFlowEntity*)parsedData;
    }
    else if ([parsedData isKindOfClass:[PredictOrderDataEntity class]]) {
        self.predict_order_entity = (PredictOrderDataEntity*)parsedData;
    }
    else if ([parsedData isKindOfClass:[DeliveryStateEntity class]]) {
        self.deliver_state_entity = (DeliveryStateEntity*)parsedData;
    }else if ([parsedData isKindOfClass:[TaskItemEntity class]]) {
        self.predict_num_entity = (TaskItemEntity*)parsedData;
    }
    
    
}


-(TaskEntity *)convertDeliverydata:(TaskEntity *)obj{
    NSMutableArray *mArr;
    if(obj&&obj.list){
        for(int i=0;i<obj.list.count;i++){
            mArr=[[NSMutableArray alloc] init];
            NSMutableDictionary *dic;
            if([[obj.list objectAtIndex:i].default_package intValue]>0){
                dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[obj.list objectAtIndex:i].default_package,@"number",[obj.list objectAtIndex:i].default_package_pick,@"picked",@"普通",@"category",@"c_default",@"icon",nil];
                [mArr addObject:dic];
            }
            if([[obj.list objectAtIndex:i].freeze_package intValue]>0){
                dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[obj.list objectAtIndex:i].freeze_package,@"number",[obj.list objectAtIndex:i].freeze_package_pick,@"picked",@"冷冻",@"category",@"c_freeze",@"icon",nil];
                [mArr addObject:dic];
            }
            if([[obj.list objectAtIndex:i].food_package intValue]>0){
                dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[obj.list objectAtIndex:i].food_package,@"number",[obj.list objectAtIndex:i].food_package_pick,@"picked",@"熟食",@"category",@"c_food",@"icon",nil];
                [mArr addObject:dic];
            }
            if([[obj.list objectAtIndex:i].refrigerate_package intValue]>0){
                dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[obj.list objectAtIndex:i].refrigerate_package,@"number",[obj.list objectAtIndex:i].refrigerate_package_pick,@"picked",@"冷藏",@"category",@"c_refrigerate",@"icon",nil];
                [mArr addObject:dic];
            }
            if([[obj.list objectAtIndex:i].box_package intValue]>0){
                dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[obj.list objectAtIndex:i].box_package,@"number",[obj.list objectAtIndex:i].box_package_pick,@"picked",@"整箱",@"category",@"c_box",@"icon",nil];
                [mArr addObject:dic];
            }
            if([[obj.list objectAtIndex:i].meat_package intValue]>0){
                dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[obj.list objectAtIndex:i].meat_package,@"number",[obj.list objectAtIndex:i].box_package_pick,@"picked",@"纸箱",@"category",@"c_meat",@"icon",nil];
                [mArr addObject:dic];
            }
            [obj.list objectAtIndex:i].package_arr=[NSArray arrayWithArray:mArr];
        }
    }
    return obj;
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
        
        //以结束时间排序
        NSArray *result = [mArr sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id  _Nonnull obj2) {
            NSArray *array_1= [obj1 componentsSeparatedByString:@"-"];
            NSArray *array_2= [obj2 componentsSeparatedByString:@"-"];
            if(array_1&&array_1.count==2&&array_2&&array_2.count==2){
                NSArray *array_11= [[array_1 lastObject] componentsSeparatedByString:@":"];
                NSArray *array_22= [[array_2 lastObject] componentsSeparatedByString:@":"];
                int num_1=[[array_11 firstObject] intValue]*60+[[array_11 lastObject] intValue];
                int num_2=[[array_22 firstObject] intValue]*60+[[array_22 lastObject] intValue];
                
                return [[NSNumber numberWithInt:num_1] compare:[NSNumber numberWithInt:num_2]]; //升序
            }
            else{
                return [obj1 compare:obj2]; //升序
            }
        }];
        return result;
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
