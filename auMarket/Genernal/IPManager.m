//
//  IPManager.m
//  pgy
//
//  Created by douj on 15/6/8.
//  Copyright (c) 2015年 com.xuwei. All rights reserved.
//

#import "IPManager.h"
#import "SyncManager.h"

@interface IPManager()

@property (nonatomic,strong) NSArray* ipList;

@end
@implementation IPManager
DEF_SINGLETON(IPManager)



- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateIp) name:SYNC_UPDATE_NOTIFICATION object:nil];
    }
    return self;
}


-(void)updateIp
{
    NSDictionary* data = [[YPSyncManager sharedInstance] getData:@"ip_list"];
    self.ipList = [data objectForKey:@"ip"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSString*)getAvaliableIp
{
#ifdef DEBUG
    return SERVER_ADDRESS;
#else
    if (!self.ipList) {

        [self updateIp];
    }

    if (self.ipList.count == 0) {
        
        return SERVER_ADDRESS;
    }
    return self.ipList.firstObject;
#endif
}
@end
