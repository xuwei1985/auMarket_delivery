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
    self.requestTag=1002;
    [self loadInner];
}

-(void)postLocation:(CLLocationCoordinate2D)coordinate andUserId:(NSString *)user_id{
    self.parseDataClassType = [SPBaseEntity class];
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=updateDeliverLocation&latitude=%lf&longitude=%lf&delivery_id=%@",coordinate.latitude,coordinate.longitude,user_id];
    self.params = @{};
    self.requestTag=1003;
    [self loadInner];
}


//异步获取Token
-(void)getTokenAsync{
    self.parseDataClassType = [UserTokenEntity class];
    
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=get_token"];
    self.params = @{};
    self.requestTag=1001;
    [self loadInner];
}

//同步获取Token
-(void)getTokenSync{
    static NSString* systemVer;
    static dispatch_once_t once;
    dispatch_once( &once, ^{ systemVer = [UIDevice currentDevice].systemVersion; } );
    
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=get_token"];
    
    NSString *urlString =[NSString stringWithFormat:@"%@/%@",[self getHost],self.shortRequestAddress];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:15.0];
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"app_ver=%@&sys_ver=%@&seqid=%@&client_type=ios&client_source=ps",[SPBaseModel getAppVer],systemVer,[[SeqIDGenerator sharedInstance] seqId]];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];

    //2.创建一个 NSMutableURLRequest 添加 header
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest addValue:[Common getClientId] forHTTPHeaderField:@"clientid"];
    [mutableRequest setTimeoutInterval:8];
    //3.把值覆给request
    request = [mutableRequest copy];
    
    //发送用户名和密码给服务器（HTTP协议）
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *error;
    if(data==nil){
        data=[NSData new];
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        if(!APP_DELEGATE.isTokenRequestFaild){
            [APP_DELEGATE initTokenTimer:1];
        }
        APP_DELEGATE.isTokenRequestFaild=YES;
    }
    else{
        if([dict[@"code"] intValue]>0){
            NSLog(@"errMsg:%@",dict[@"msg"]);
            if(!APP_DELEGATE.isTokenRequestFaild){
                [APP_DELEGATE initTokenTimer:1];
            }
            APP_DELEGATE.isTokenRequestFaild=YES;
        }
        else{
            NSString *token = [[dict objectForKey:@"data"] objectForKey:@"token"];
            if(token!=nil&&token.length>0){
                if(APP_DELEGATE.isTokenRequestFaild){
                    [APP_DELEGATE initTokenTimer:0];
                }
                APP_DELEGATE.isTokenRequestFaild=NO;
                APP_DELEGATE.token=token;
            }
            else{
                if(!APP_DELEGATE.isTokenRequestFaild){
                    [APP_DELEGATE initTokenTimer:1];
                }
                APP_DELEGATE.isTokenRequestFaild=YES;
            }
        }
    }
}

-(void)handleParsedData:(SPBaseEntity*)parsedData{
    if (self.requestTag==1001&&[parsedData isKindOfClass:[UserTokenEntity class]]) {
        self.entity = (UserTokenEntity*)parsedData;
    }
    else if (self.requestTag==1002&&[parsedData isKindOfClass:[ParkingEntity class]]) {
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

@implementation UserTokenEntity

@end
