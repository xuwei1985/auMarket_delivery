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
        
    }
    return self;
}

//普通登录
-(void)loginWithUsername:(NSString *)uname andPassword:(NSString *)upass andMobile:(NSString *)mobile andCode:(NSString *)code{
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=deliver_login&username=%@&password=%@&mobile=%@&code=%@",uname,upass,mobile,code];
    self.parseDataClassType = [MemberLoginEntity class];
    self.params = @{
    };
    self.requestTag=1001;
    [self loadInner];
}



//设置工作状态
-(void)setDeliverStatus:(NSString *)status{
    SPAccount *user=[[AccountManager sharedInstance] getCurrentUser];
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=set_deliver_status&status=%@&deliver_id=%@",status,user.user_id];
    self.params = @{};
    self.requestTag=1002;
    [self loadInner];
}

//获取结算信息
-(void)getChargeInfo{
    SPAccount *user=[[AccountManager sharedInstance] getCurrentUser];
    self.parseDataClassType = [MemberChargeEntity class];
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=get_deliver_charge&deliver_id=%@",user.user_id];
    self.params = @{};
    self.requestTag=1003;
    [self loadInner];
}

-(void)getVerifyMobiles{
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=login_verify_account"];
    self.parseDataClassType = [VerifyMobileListEntity class];
    self.params = @{
    };
    self.requestTag=1004;
    [self loadInner];
}

//校验短信验证码
-(void)getSmsCode:(NSString *)mobile{
    self.parseDataClassType = [OrderVerifyEntity class];
    self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=getSmsCodeForClient&mobile=%@",mobile];
    self.requestTag=1005;
    [self loadInner];
}


-(void)handleParsedData:(SPBaseEntity*)parsedData{
    if ([parsedData isKindOfClass:[MemberLoginEntity class]]) {
        self.entity = (MemberLoginEntity*)parsedData;
    }
    else if ([parsedData isKindOfClass:[MemberChargeEntity class]]) {
        self.charge_entity = (MemberChargeEntity*)parsedData;
    }
    else if ([parsedData isKindOfClass:[VerifyMobileListEntity class]]) {
        self.verify_entity = (VerifyMobileListEntity*)parsedData;
    }
    else if ([parsedData isKindOfClass:[OrderVerifyEntity class]]) {
        self.sEntity = (OrderVerifyEntity*)parsedData;
    }
    
}

-(SPAccount *)convertToSpAccount:(MemberEntity*)mEntity{
    SPAccount *_account=[[SPAccount alloc] init];
    _account.user_id=mEntity.userid;
    _account.user_account=mEntity.account;
    _account.user_nickname=mEntity.nickname;
    _account.user_mobile=mEntity.mobile;
    _account.user_pwd=mEntity.password;
    _account.user_token=mEntity.token;
    return _account;
}

-(MemberLoginEntity *)entity{
    if(!_entity){
        _entity=[[MemberLoginEntity alloc] init];
    }
    
    return _entity;
}

-(MemberChargeEntity *)charge_entity{
    if(!_charge_entity){
        _charge_entity=[[MemberChargeEntity alloc] init];
    }
    
    return _charge_entity;
}

-(VerifyMobileListEntity *)verify_entity{
    if(!_verify_entity){
        _verify_entity=[[VerifyMobileListEntity alloc] init];
    }
    
    return _verify_entity;
}

-(OrderVerifyEntity *)sEntity{
    if(!_sEntity){
        _sEntity=[[OrderVerifyEntity alloc] init];
    }
    
    return _sEntity;
}


@end
