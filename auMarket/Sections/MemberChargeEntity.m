//
//  MemberLoginEntity.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/25.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "MemberChargeEntity.h"

@implementation MemberChargeEntity
-(id)init{
    self = [super init];
    if (self) {
        self.transfer_charge=@"0.00";
        self.cash_charge=@"0.00";
    }
    return self;
}
@end
