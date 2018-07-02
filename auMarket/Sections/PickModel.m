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
    self.shortRequestAddress= [NSString stringWithFormat:@"v1/pick/pick_list?page=%@&type=%d&delivery_id=%@",(self.entity.next==nil?@"1":self.entity.next),list_type,user.user_id];
    self.params = @{};
    self.requestTag=1001;
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
            NSDictionary *dic;
            if([[entity.list objectAtIndex:i].default_package intValue]>0){
                dic=[[NSDictionary alloc] initWithObjectsAndKeys:[entity.list objectAtIndex:i].default_package,@"default_package",nil];
                [mArr addObject:dic];
            }
            if([[entity.list objectAtIndex:i].freeze_package intValue]>0){
                dic=[[NSDictionary alloc] initWithObjectsAndKeys:[entity.list objectAtIndex:i].freeze_package,@"default_package",nil];
                [mArr addObject:dic];
            }
            if([[entity.list objectAtIndex:i].refrigerate_package intValue]>0){
                dic=[[NSDictionary alloc] initWithObjectsAndKeys:[entity.list objectAtIndex:i].refrigerate_package,@"default_package",nil];
                [mArr addObject:dic];
            }
            if([[entity.list objectAtIndex:i].box_package intValue]>0){
                dic=[[NSDictionary alloc] initWithObjectsAndKeys:[entity.list objectAtIndex:i].box_package,@"default_package",nil];
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
