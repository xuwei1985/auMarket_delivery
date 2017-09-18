//
//  TaskModel.m
//  auMarket
//
//  Created by 吴绪伟 on 2017/9/13.
//  Copyright © 2017年 daao. All rights reserved.
//

#import "BooterModel.h"

@implementation BooterModel
-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)loadParkingList{
    self.parseDataClassType = [ParkingEntity class];
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=parking_list"];
    self.params = @{};
    [self loadInner];
}


-(void)handleParsedData:(SPBaseEntity*)parsedData{
    if ([parsedData isKindOfClass:[ParkingEntity class]]) {
        self.parking_entity = (ParkingEntity*)parsedData;
    }
}


-(ParkingEntity *)parking_entity{
    if(!_parking_entity){
        _parking_entity=[[ParkingEntity alloc] init];
    }
    
    return _parking_entity;
}
@end
