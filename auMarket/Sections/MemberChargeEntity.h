//
//  MemberLoginEntity.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/25.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseEntity.h"

@interface MemberChargeEntity : SPBaseEntity

@property(nonatomic,retain) NSString *cash_charge;
@property(nonatomic,retain) NSString *transfer_charge;
@property(nonatomic,retain) NSString *alipay_charge;
@property(nonatomic,retain) NSString *wechat_charge;
@property(nonatomic,retain) NSString *change_company;
@property(nonatomic,retain) NSString *change_personal;
@end


