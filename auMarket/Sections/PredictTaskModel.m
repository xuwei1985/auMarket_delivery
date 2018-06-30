//
//  BannerModel.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/28.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "PredictTaskModel.h"

@implementation PredictTaskModel

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)predict_task_list{
    SPAccount *user=[[AccountManager sharedInstance] getCurrentUser];
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=predict_task_list&delivery_id=%@",user.user_id];
    self.parseDataClassType = [TaskEntity class];
    self.params = @{};
    self.requestTag=1001;
    [self loadInner];
}



-(void)handleParsedData:(SPBaseEntity*)parsedData{
    if ([parsedData isKindOfClass:[TaskEntity class]]) {
        self.entity = (TaskEntity*)parsedData;
    }
}

-(TaskEntity *)entity{
    if(!_entity){
        _entity=[[TaskEntity alloc] init];    }
    
    return _entity;
}


@end
