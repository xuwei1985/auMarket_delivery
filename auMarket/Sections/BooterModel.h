//
//  TaskModel.h
//  auMarket
//
//  Created by 吴绪伟 on 2017/9/13.
//  Copyright © 2017年 daao. All rights reserved.
//

#import "SPBaseModel.h"
#import "ParkingEntity.h"
#import "SeqIDGenerator.h"

@class UserTokenEntity;
@interface BooterModel : SPBaseModel
@property(nonatomic,retain) UserTokenEntity *entity;
@property (nonatomic,retain) ParkingEntity *parking_entity;


-(void)loadParkingList;
-(void)postLocation:(CLLocationCoordinate2D)coordinate andUserId:(NSString *)user_id;
-(void)getTokenAsync;
-(void)getTokenSync;
@end


@interface UserTokenEntity : SPBaseEntity
@property(nonatomic,retain) NSString *token;
@property(nonatomic,retain) NSString *app_ver;
@end
