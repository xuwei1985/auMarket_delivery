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

/**加载待拣货的订单列表
 goodsModel   0：普通商品上货 1：普通商品上货 2：冷冻上货
 */
-(void)loadPickOrderWithListType:(int)list_type andModel:(NSString *)goodsModel{
    self.parseDataClassType = [PickEntity class];
    SPAccount *user=[[AccountManager sharedInstance] getCurrentUser];
    self.shortRequestAddress= [NSString stringWithFormat:@"apiv1.php?act=pick_list&page=%@&list_type=%d&delivery_id=%@&goods_model=%@",(self.entity.next==nil?@"1":self.entity.next),list_type,user.user_id,goodsModel];
    self.params = @{};
    self.requestTag=1001;
    [self loadInner];
}

//完成包裹的上货
-(void)finishPickPackage:(int)type andOrderId:(NSString *)order_id andDeliveryId:(NSString *)delivery_id andPackageType:(NSString *)package_type andModel:(NSString *)goodsModel{
    self.parseDataClassType = [SPBaseEntity class];
//    SPAccount *user=[[AccountManager sharedInstance] getCurrentUser];
    self.shortRequestAddress= [NSString stringWithFormat:@"apiv1.php?act=package_pick_done&order_id=%@&delivery_id=%@&package_type=%@&type=%d&goods_model=%@",order_id,delivery_id,package_type,type,goodsModel];
    self.params = @{};
    self.requestTag=1002;
    [self loadInner];
}

-(void)finishAllPackagePick:(NSString *)order_ids andDeliveryId:(NSString *)delivery_ids andModel:(NSString *)goodsModel{
    self.parseDataClassType = [SPBaseEntity class];
    self.shortRequestAddress= [NSString stringWithFormat:@"apiv1.php?act=package_pick_all_done&order_ids=%@&delivery_ids=%@&goods_model=%@",order_ids,delivery_ids,goodsModel];
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
                dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[entity.list objectAtIndex:i].default_package,@"number",[entity.list objectAtIndex:i].default_package_pick,@"picked",@"普通",@"category",@"c_default",@"icon",nil];
                [mArr addObject:dic];
            }
            if([[entity.list objectAtIndex:i].food_package intValue]>0){
                dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[entity.list objectAtIndex:i].food_package,@"number",[entity.list objectAtIndex:i].food_package_pick,@"picked",@"熟食",@"category",@"c_food",@"icon",nil];
                [mArr addObject:dic];
            }
            if([[entity.list objectAtIndex:i].freeze_package intValue]>0){
                dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[entity.list objectAtIndex:i].freeze_package,@"number",[entity.list objectAtIndex:i].freeze_package_pick,@"picked",@"冷冻",@"category",@"c_freeze",@"icon",nil];
                [mArr addObject:dic];
            }
            if([[entity.list objectAtIndex:i].refrigerate_package intValue]>0){
                dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[entity.list objectAtIndex:i].refrigerate_package,@"number",[entity.list objectAtIndex:i].refrigerate_package_pick,@"picked",@"冷藏",@"category",@"c_refrigerate",@"icon",nil];
                [mArr addObject:dic];
            }
            if([[entity.list objectAtIndex:i].box_package intValue]>0){
                dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[entity.list objectAtIndex:i].box_package,@"number",[entity.list objectAtIndex:i].box_package_pick,@"picked",@"整箱",@"category",@"c_box",@"icon",nil];
                [mArr addObject:dic];
            }
            if([[entity.list objectAtIndex:i].meat_package intValue]>0){
                dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[entity.list objectAtIndex:i].meat_package,@"number",[entity.list objectAtIndex:i].box_package_pick,@"picked",@"纸箱",@"category",@"c_meat",@"icon",nil];
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
