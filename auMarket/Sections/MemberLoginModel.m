//
//  MemberLoginModel.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/25.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "MemberLoginModel.h"

@implementation MemberLoginModel

-(instancetype)init{
    self = [super init];
    if (self) {
        self.parseDataClassType = [MemberLoginEntity class];
    }
    return self;
}

//普通登录
-(void)loginWithUsername:(NSString *)uname andPassword:(NSString *)upass{
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=delivery_login&username=%@&password=%@",uname,upass];
    self.params = @{
    };
    self.requestTag=1001;
    [self loadInner];
}

-(void)handleParsedData:(SPBaseEntity*)parsedData{
    if ([parsedData isKindOfClass:[MemberLoginEntity class]]) {
        self.entity = (MemberLoginEntity*)parsedData;
    }
}

-(SPAccount *)convertToSpAccount:(MemberEntity*)mEntity{
    SPAccount *_account=[[SPAccount alloc] init];
    _account.user_id=mEntity.userid;
    _account.user_account=mEntity.account;
    _account.user_nickname=mEntity.nickname;
    _account.user_mobile=mEntity.mobile;
    _account.user_pwd=mEntity.password;
    return _account;
}

-(MemberLoginEntity *)entity{
    if(!_entity){
        _entity=[[MemberLoginEntity alloc] init];
    }
    
    return _entity;
}
@end
