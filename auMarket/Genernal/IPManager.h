//
//  IPManager.h
//  pgy
//
//  Created by douj on 15/6/8.
//  Copyright (c) 2015年 com.xuwei. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface IPManager : NSObject
DEC_SINGLETON(IPManager)

-(NSString*)getAvaliableIp;
@end
