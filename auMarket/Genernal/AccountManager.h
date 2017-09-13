//
//  AccountManager.h
//  Youpin
//
//  Created by douj on 15/4/29.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const KEYCHAIN_IDENTIFIER;

@class SPAccount;
@interface AccountManager : NSObject
DEC_SINGLETON(AccountManager)

-(BOOL)isLogin;
-(SPAccount*)getCurrentUser;

//注册用户
-(void)registerLoginUser:(SPAccount*)user;
//注册用户
-(void)registerLoginUserWithUserName:(NSString *)userName
                              utoken:(NSString *)utoken
                              userId:(NSString *)userId
                           isNewUser:(NSString *)isNewUser
                              openid:(NSString *)openid
                          userStatus:(NSString *)userStatus
                              mobile:(NSString *)mobile
                              avatar:(NSString *)avatar;

//注销用户
-(void)unRegisterLoginUser;

//显示登录界面
-(void)showLogin:(UINavigationController *)navigationController;

//显示登录界面(模态形式)
-(void)showLoginWithModalState;

//修改用户昵称
-(void)updateNickName:(NSString*)nickName;

//修改用户ID
-(void)updateUserId:(NSString*)userId;

//修改用户头像
-(void)updateUserPortrait:(NSString*)portrait;

- (void)updateUserStatusIfNeeded;

- (void)updateUserStatus:(NSString*)newStatus;
@end


@interface SPAccount : SPBaseEntity

@property (nonatomic,retain) NSString *user_id;
@property (nonatomic,retain) NSString *user_account;
@property (nonatomic,retain) NSString *user_nickname;
@property (nonatomic,retain) NSString *user_avatar;
@property (retain,nonatomic) NSString *user_mobile;
@property (retain,nonatomic) NSString *user_token;
@property (nonatomic,retain) NSString *user_openID;
@property (nonatomic,retain) NSString *user_status;
@property (nonatomic,retain) NSString *user_pwd;
@property (retain,nonatomic) NSString *isNewUser;


//绑定判断方法
- (BOOL)isAlphaBind;
- (BOOL)isMobileBind;
- (BOOL)isWechatBind;

@end
