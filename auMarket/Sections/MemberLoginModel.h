//
//  MemberLoginModel.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/25.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseModel.h"
#import "MemberLoginEntity.h"

//登录方式
typedef enum {
    LoginForm_Normal = 0,
    LoginForm_Mobile = 1,
    LoginForm_Email = 2,
    LoginForm_Wexin = 3,
    LoginForm_QQ = 4,
    LoginForm_Weibo = 5,
    LoginForm_Other = 99
} LoginForm;


@interface MemberLoginModel : SPBaseModel
@property(nonatomic,retain) MemberLoginEntity *entity;


//普通登录
-(void)loginWithUsername:(NSString *)uname andPassword:(NSString *)upass;
//微信登录
-(void)loginWithWithUsername:(NSString *)uname andNickname:(NSString *)nickname andAvatar:(NSString *)avatar andGender:(NSString *)gender;

//将登录的实体信息提取出 用户实体（SpAccount）
-(SPAccount *)convertToSpAccount:(MemberEntity*)mEntity;
@end
