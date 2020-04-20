//
//  MemberLoginModel.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/25.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseModel.h"
#import "MemberLoginEntity.h"
#import "MemberChargeEntity.h"
#import "VerifyMobileEntity.h"

@interface MemberLoginModel : SPBaseModel
@property(nonatomic,retain) MemberLoginEntity *entity;
@property(nonatomic,retain) MemberChargeEntity *charge_entity;
@property(nonatomic,retain) VerifyMobileListEntity *verify_entity;
@property(nonatomic,retain) OrderVerifyEntity *sEntity;

//普通登录
-(void)loginWithUsername:(NSString *)uname andPassword:(NSString *)upass andMobile:(NSString *)mobile andCode:(NSString *)code;
-(void)setDeliverStatus:(NSString *)status;
-(void)getChargeInfo;
-(void)getVerifyMobiles;
-(void)getSmsCode:(NSString *)code;

//将登录的实体信息提取出 用户实体（SpAccount）
-(SPAccount *)convertToSpAccount:(MemberEntity*)mEntity;
@end
