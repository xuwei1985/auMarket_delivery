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
@class LineEntity;
@class  LineItemEntity;
@interface BooterModel : SPBaseModel
@property(nonatomic,retain) UserTokenEntity *entity;
@property (nonatomic,retain) ParkingEntity *parking_entity;
@property(nonatomic,retain) LineEntity *lineEntity;

-(void)loadParkingList;
-(void)postLocation:(CLLocationCoordinate2D)coordinate andUserId:(NSString *)user_id;
-(void)getTokenAsync;
-(void)getTokenSync;
-(void)getDataLines;
@end

@interface UserTokenEntity : SPBaseEntity
@property(nonatomic,retain) NSString *token;
@property(nonatomic,retain) NSString *app_ver;
@end

@interface LineEntity : SPBaseEntity
@property(nonatomic,retain) NSArray<LineItemEntity*> *list;
@end


@interface LineItemEntity : SPBaseEntity
@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *url;
@end
