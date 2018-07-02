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
    self.shortRequestAddress= [NSString stringWithFormat:@"v1/pick/pick_list?page=%@&delivery_id=%d",list_type,(self.entity.next==nil?@"1":self.entity.next),user.user_id];
    self.params = @{};
    self.requestTag=1001;
    [self loadInner];
}


-(void)handleParsedData:(SPBaseEntity*)parsedData{
    if ([parsedData isKindOfClass:[PickEntity class]]) {
        self.entity = (PickEntity*)parsedData;
    }
}

-(PickEntity *)entity{
    if(!_entity){
        _entity=[[PickEntity alloc] init];    }
    
    return _entity;
}

@end
