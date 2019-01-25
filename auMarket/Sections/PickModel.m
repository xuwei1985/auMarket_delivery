//
//  BannerModel.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/28.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "PickModel.h"

@implementation PickModel

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//加载待拣货的订单列表
-(void)loadPickOrderWithListType:(int)list_type{
    self.parseDataClassType = [PickEntity class];
    SPAccount *user=[[AccountManager sharedInstance] getCurrentUser];
    self.shortRequestAddress= [NSString stringWithFormat:@"apiv1.php?act=pick_list&page=%@&list_type=%d&delivery_id=%@",(self.entity.next==nil?@"1":self.entity.next),list_type,user.user_id];
    self.params = @{};
    self.requestTag=1001;
    [self loadInner];
}

//完成包裹的上货
-(void)finishPickPackage:(int)type andOrderId:(NSString *)order_id andDeliveryId:(NSString *)delivery_id andPackageType:(NSString *)package_type{
    self.parseDataClassType = [SPBaseEntity class];
//    SPAccount *user=[[AccountManager sharedInstance] getCurrentUser];
    self.shortRequestAddress= [NSString stringWithFormat:@"apiv1.php?act=package_pick_done&order_id=%@&delivery_id=%@&package_type=%@&type=%d",order_id,delivery_id,package_type,type];
    self.params = @{};
    self.requestTag=1002;
    [self loadInner];
}

-(void)finishAllPackagePick:(NSString *)order_ids andDeliveryId:(NSString *)delivery_ids{
    self.parseDataClassType = [SPBaseEntity class];
    self.shortRequestAddress= [NSString stringWithFormat:@"apiv1.php?act=package_pick_all_done&order_ids=%@&delivery_ids=%@",order_ids,delivery_ids];
    self.params = @{};
    self.requestTag=1003;
    [self loadInner];
}

-(void)handleParsedData:(SPBaseEntity*)parsedData{
    if ([parsedData isKindOfClass:[PickEntity class]]) {
        self.entity=[self convertPickOrderdata:(PickEntity*)parsedData];
    }
}

-(PickEntity *)convertPickOrderdata:(PickEntity *)entity{
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

-(PickEntity *)entity{
    if(!_entity){
        _entity=[[PickEntity alloc] init];    }
    
    return _entity;
}

@end
