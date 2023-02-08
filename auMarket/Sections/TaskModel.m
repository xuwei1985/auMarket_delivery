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
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=delivery_list&delivery_id=%@",user.user_id];//
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

-(void)savePredictTime:(NSString *)ids andPredictTime:(NSString *)predict_time{
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=saveOrderPredictTime&ids=%@&predict_time=%@",ids,[Common encodeToPercentEscapeString:predict_time]];
    self.parseDataClassType = [SPBaseEntity class];
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


-(void)loadDeliveryTimeSection{
    SPAccount *user=[[AccountManager sharedInstance] getCurrentUser];
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=getDeliveryTimeSection&delivery_id=%@",user.user_id];
    self.parseDataClassType = [TimeSectionEntity class];
    self.params = @{};
    self.requestTag=3007;
    [self loadInner];
}

/**
 请求订单配送完成操作
 */
-(void)order_delivery_done:(NSString *)delivery_id andStatus:(NSString *)status andPayType:(int)pay_type andImgPath:(NSString *)img_path andOrderSn:(NSString *)order_sn andMsg:(NSString *)msg andBank:(NSString *)bank_id{
    SPAccount *user=[[AccountManager sharedInstance] getCurrentUser];

    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=order_delivery_done&delivery_id=%@&status=%@&pay_type=%d&user_id=%@&img_path=%@&order_sn=%@&msg=%@&bank=%@",delivery_id,status,pay_type,user.user_id,img_path,order_sn,[Common encodeToPercentEscapeString:msg],bank_id];
    self.parseDataClassType = [TaskEntity class];
    self.params = @{};
    self.requestTag=3003;
    [self loadInner];
}

-(void)handleParsedData:(SPBaseEntity*)parsedData{
    if ([parsedData isKindOfClass:[TaskEntity class]]) {
        self.entity=[self convertDeliverydata:(TaskEntity*)parsedData];
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
}


-(TaskEntity *)convertDeliverydata:(TaskEntity *)entity{
    NSMutableArray *mArr;
    if(entity&&entity.list){
        
        for(int i=0;i<entity.list.count;i++){
            mArr=[[NSMutableArray alloc] init];
            NSMutableDictionary *dic;
            if([[entity.list objectAtIndex:i].default_package intValue]>0){
                dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[entity.list objectAtIndex:i].default_package,@"number",[entity.list objectAtIndex:i].default_package_pick,@"picked",@"普通包裹",@"category",@"c_default",@"icon",nil];
                [mArr addObject:dic];
            }
            if([[entity.list objectAtIndex:i].freeze_package intValue]>0){
                dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[entity.list objectAtIndex:i].freeze_package,@"number",[entity.list objectAtIndex:i].freeze_package_pick,@"picked",@"冷冻包裹",@"category",@"c_freeze",@"icon",nil];
                [mArr addObject:dic];
            }
            if([[entity.list objectAtIndex:i].food_package intValue]>0){
                dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[entity.list objectAtIndex:i].food_package,@"number",[entity.list objectAtIndex:i].food_package_pick,@"picked",@"熟食包裹",@"category",@"c_food",@"icon",nil];
                [mArr addObject:dic];
            }
            if([[entity.list objectAtIndex:i].refrigerate_package intValue]>0){
                dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[entity.list objectAtIndex:i].refrigerate_package,@"number",[entity.list objectAtIndex:i].refrigerate_package_pick,@"picked",@"冷藏包裹",@"category",@"c_refrigerate",@"icon",nil];
                [mArr addObject:dic];
            }
            if([[entity.list objectAtIndex:i].box_package intValue]>0){
                dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[entity.list objectAtIndex:i].box_package,@"number",[entity.list objectAtIndex:i].box_package_pick,@"picked",@"整箱包裹",@"category",@"c_box",@"icon",nil];
                [mArr addObject:dic];
            }
            if([[entity.list objectAtIndex:i].meat_package intValue]>0){
                dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[entity.list objectAtIndex:i].meat_package,@"number",[entity.list objectAtIndex:i].box_package_pick,@"picked",@"纸箱包裹",@"category",@"c_meat",@"icon",nil];
                [mArr addObject:dic];
            }
            [entity.list objectAtIndex:i].package_arr=[NSArray arrayWithArray:mArr];
        }
    }
    return entity;
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
