//
//  SyncManager.h
//  YP
//
//  Created by douj on 15/5/18.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import "SPBaseModel.h"


@class SPSyncEntity;
@interface YPSyncManager : SPBaseModel
DEC_SINGLETON(YPSyncManager)

-(void)load;
-(NSDictionary*)getData:(NSString*)key;

@end


@interface YPSyncItemListItem : SPBaseEntity
@property (strong,nonatomic) NSNumber* timestamp;
@property (copy,nonatomic)   NSString* key;
@property (strong,nonatomic) NSDictionary* data;
@end

@interface SPSyncEntity : SPBaseEntity

@property (nonatomic,strong) NSArray* itemlist;

@end

