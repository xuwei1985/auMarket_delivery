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
        self.entity.err_msg=@"未获取到有效的购物车数据";
    }
    return self;
}

//普通登录
-(void)loginWithUsername:(NSString *)uname andPassword:(NSString *)upass{
    self.shortRequestAddress=@"apiv1.php?act=user_login";
    self.params = @{
        @"username":uname,
        @"password":upass
    };
    self.requestTag=1001;
    [self loadInner];
}

//微信登录
-(void)loginWithWithUsername:(NSString *)uname andNickname:(NSString *)nickname andAvatar:(NSString *)avatar andGender:(NSString *)gender{
    self.shortRequestAddress=@"apiv1.php?act=login_register";
    self.params = @{
                    @"username":uname,
                    @"nickname":nickname,
                    @"userheader":avatar,
                    @"gender":gender
                    };
    self.requestTag=1002;
    [self loadInner];
}

-(void)handleParsedData:(SPBaseEntity*)parsedData{
    if ([parsedData isKindOfClass:[MemberLoginEntity class]]) {
        self.entity = (MemberLoginEntity*)parsedData;
    }
}

-(SPAccount *)convertToSpAccount:(MemberEntity*)mEntity{
    SPAccount *_account=[[SPAccount alloc] init];
    _account.user_id=mEntity.user_id;
    _account.user_nickname=mEntity.nickname;
    _account.user_avatar=mEntity.userheader;
    return _account;
}

-(MemberLoginEntity *)entity{
    if(!_entity){
        _entity=[[MemberLoginEntity alloc] init];
    }
    
    return _entity;
}
@end
