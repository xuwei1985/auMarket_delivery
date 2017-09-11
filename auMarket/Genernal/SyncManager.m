//
//  YPSyncManager.m
//  YP
//
//  Created by douj on 15/5/18.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import "SyncManager.h"
#import "UIDevice-Hardware.h"
#define kSyncCache @"kSyncCache"

@interface YPSyncManager ()
@property (nonatomic,strong) NSMutableDictionary* index;
@property (nonatomic) BOOL  isUpdateRequest;
@end

@implementation YPSyncManager
DEF_SINGLETON(YPSyncManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.index = (NSMutableDictionary*)[self getItemFromCache:kSyncCache];
    }
    return self;
}

-(void)load
{
    self.isUpdateRequest = NO;
    self.shortRequestAddress = @"c/s/sync";
    self.parseDataClassType = [SPSyncEntity class];
    if (!self.index) {
         self.params = @{@"model":[[UIDevice currentDevice] tbcPlatformString],@"channel":@"appstore",@"type":@"0"};
    }
    else
    {
         self.params = @{@"model":[[UIDevice currentDevice] tbcPlatformString],@"channel":@"appstore",@"type":@"1"};
    }
   
    [self loadInner];
}

//检查时间戳是否需要更新
- (NSString*)checkNeedUpdate:(YPSyncItemListItem *)item
{
    NSString *updateKeys;
    YPSyncItemListItem* cacheItem =  [self.index objectForKey:item.key];
    //没有该item的缓存或者缓存时间戳过期就需要更新
    if (!cacheItem || ![cacheItem.timestamp isEqualToNumber:item.timestamp]) {
            updateKeys = item.key;
    }
    return updateKeys;
}


//更新item
-(void)updateItem:(YPSyncItemListItem *)item
{
    YPSyncItemListItem* cacheItem =  [self.index objectForKey:item.key];
    if (!cacheItem || ![cacheItem.timestamp isEqualToNumber:item.timestamp]) {
        [self.index setObject:item forKey:item.key];
    }
}

-(void)handleParsedData:(SPBaseEntity*)parsedData
{
    if ([parsedData isKindOfClass:[SPSyncEntity class]]) {
        BOOL needSave = NO;  //存到缓存
        NSString* updateKeys = nil;
        SPSyncEntity* syncData = (SPSyncEntity*)parsedData;
        if (self.index == nil)
        {
            [self setSyncData:syncData];
            needSave = YES;
        }
        else
        {
            for (YPSyncItemListItem*item in syncData.itemlist) {
                //如果是更新请求回来的数据 更新数据，否则检查更新
                if (self.isUpdateRequest) {
                    [self updateItem:item];
                    needSave = YES;
                }
                else
                {
                    NSString* key  = [self checkNeedUpdate:item];
                    if (!updateKeys) {
                        updateKeys = key;
                    }
                    else
                    {
                        updateKeys = [NSString stringWithFormat:@"%@,%@",updateKeys,key];
                    }
                   
                }
                
            }
        }
        if (needSave) {
            [self setItemToCache:self.index key:kSyncCache];
        }
        if (updateKeys) {
            [self requestUpdateKeys:updateKeys];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_UPDATE_NOTIFICATION object:nil];
}

-(void)requestUpdateKeys:(NSString*)keys
{
    self.isUpdateRequest = YES;
    self.params = @{@"model":[[UIDevice currentDevice] tbcPlatformString],@"channel":@"appstore",@"key":keys};
    [self loadInner];
}


-(void)setSyncData:(SPSyncEntity *)syncData{
    NSMutableDictionary* mutaleDict = [[NSMutableDictionary alloc] init];
    for (YPSyncItemListItem*item in syncData.itemlist) {
        [mutaleDict setObject:item forKey:item.key];
    }
    self.index = mutaleDict;
}

-(NSDictionary*)getData:(NSString*)key
{
    YPSyncItemListItem* item = [self.index objectForKey:key];
    return item.data;
}

- (NSString *)getHost{
    return SERVER_HTTP_ADDRESS;
}

@end


@implementation SPSyncEntity
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addMappingRuleArrayProperty:@"itemlist" class:[YPSyncItemListItem class]];
    }
    return self;
}

@end

@implementation YPSyncItemListItem

@end

