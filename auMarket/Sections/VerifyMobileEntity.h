//
//  MemberLoginEntity.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/25.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseEntity.h"
@class VerifyMobileEntity;

@interface VerifyMobileListEntity : SPBaseEntity
@property(nonatomic,retain)NSMutableArray <VerifyMobileEntity*> *verify_account_list;
@end

@interface VerifyMobileEntity : SPBaseEntity

@property(nonatomic,retain) NSString *id;
@property(nonatomic,retain) NSString *mobile;
@property(nonatomic,retain) NSString *nickname;
@end

@interface OrderVerifyEntity : SPBaseEntity
@property(nonatomic,retain) NSString *status;
@property(nonatomic,retain) NSString *needImgCode;
@property(nonatomic,retain) NSString *keeptime;
@end
