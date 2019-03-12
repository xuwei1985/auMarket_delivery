//
//  TaskModel.h
//  auMarket
//
//  Created by 吴绪伟 on 2017/9/13.
//  Copyright © 2017年 daao. All rights reserved.
//

#import "SPBaseModel.h"
#import "ParkingEntity.h"

@interface BooterModel : SPBaseModel
@property (nonatomic,retain) ParkingEntity *parking_entity;

-(void)loadParkingList;
-(void)postLocation:(CLLocationCoordinate2D)coordinate andUserId:(NSString *)user_id;
@end
