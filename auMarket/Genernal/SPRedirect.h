//
//  SPRedirect.h
//  superenglish
//
//  Created by Mrc.cc on 16/3/31.
//  Copyright © 2016年 com.xuwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPRedirect : NSObject
DEC_SINGLETON(SPRedirect)

- (void)jumpByUserId:(NSString*)userId;
- (void)jumpByFid:(NSString*)fid;
//链接跳转
-(void)jumpByUrl:(NSString*)url;
//是否应该
-(BOOL)shouldJumpToLocalPage:(NSString*)url;

@end
