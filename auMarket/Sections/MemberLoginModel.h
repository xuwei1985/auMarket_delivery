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

@interface MemberLoginModel : SPBaseModel
@property(nonatomic,retain) MemberLoginEntity *entity;
@property(nonatomic,retain) MemberChargeEntity *charge_entity;

//普通登录
-(void)loginWithUsername:(NSString *)uname andPassword:(NSString *)upass;
-(void)setDeliverStatus:(NSString *)status;
-(void)getChargeInfo;

//将登录的实体信息提取出 用户实体（SpAccount）
-(SPAccount *)convertToSpAccount:(MemberEntity*)mEntity;
@end
