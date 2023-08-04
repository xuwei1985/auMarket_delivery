//
//  AccountManager.m
//  Youpin
//
//  Created by douj on 15/4/29.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import "AccountManager.h"
#import "UserLoginViewController.h"
#import <UICKeyChainStore.h>

NSString *const KEY_CHAIN_USR_KEY = @"loginUser";
NSString *const KEYCHAIN_IDENTIFIER = @"com.wilson.auMarket.account";

@interface AccountManager()
@property (nonatomic,strong) SPAccount* account;
@end

@implementation AccountManager
DEF_SINGLETON(AccountManager)

#pragma mark - Account
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserNameChange:) name:USERNAME_UPDATE_NOTIFICATION object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)onUserNameChange:(NSNotification*) notification
{
    if ([notification.object isKindOfClass:[NSString class]]) {
        [self updateNickName:notification.object];
    }
}

-(BOOL)isLogin
{
    if ([self getCurrentUser]) {
        return YES;
    }
    return NO;
}

-(SPAccount*)getCurrentUser
{
    if (!self.account) {
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:KEYCHAIN_IDENTIFIER];
        NSData* data = [keychain dataForKey:KEY_CHAIN_USR_KEY];
        if (data) {
            NSKeyedUnarchiver *archiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            self.account = [archiver decodeObject];
            [archiver finishDecoding];
        }
    }
    return self.account;
}

-(void)registerLoginUser:(SPAccount*)user
{
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:KEYCHAIN_IDENTIFIER];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:user];
    [archiver finishEncoding];
    
    [keychain setData:data forKey:KEY_CHAIN_USR_KEY];
    self.account = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ACCOUNT_UPDATE_NOTIFICATION object:[NSNumber numberWithBool:YES]];
}

-(void)registerLoginUserWithUserName:(NSString *)userName
                              utoken:(NSString *)utoken
                              userId:(NSString *)userId
                           isNewUser:(NSString *)isNewUser
                              openid:(NSString *)openid
                          userStatus:(NSString *)userStatus
                              mobile:(NSString *)mobile
                              avatar:(NSString *)avatar{
    SPAccount *account = [[SPAccount alloc] init];
    account.user_id = userId;
    account.user_nickname = userName;
    account.user_token = utoken;
    account.isNewUser = isNewUser;
    account.user_openID = openid;
    account.user_mobile = mobile;
    account.user_status = userStatus;
    account.user_avatar = avatar;
    [self registerLoginUser:account];
}

-(void)unRegisterLoginUser
{
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:KEYCHAIN_IDENTIFIER];
    [keychain removeItemForKey:KEY_CHAIN_USR_KEY];
    self.account = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:ACCOUNT_UPDATE_NOTIFICATION object:[NSNumber numberWithBool:NO]];
}

- (void)showLogin:(UINavigationController *)navigationController
{
    UserLoginViewController* lvc = [[UserLoginViewController alloc] init];
    [navigationController pushViewController:lvc animated:YES];
}

-(void)showLoginWithModalState{
    UserLoginViewController *lvc=[[UserLoginViewController alloc] init];
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:lvc];
    [[AppDelegate getNavigationController] presentViewController:navC animated:YES completion:nil];
}

-(void)updateNickName:(NSString*)nickName
{
    if (nickName == nil) {
        return;
    }
    SPAccount* account = [self getCurrentUser];
    if (![account.user_nickname isEqualToString:nickName]) {
        account.user_nickname = nickName;
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:KEYCHAIN_IDENTIFIER];
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:account];
        [archiver finishEncoding];
        [keychain setData:data forKey:KEY_CHAIN_USR_KEY];
    }
}

-(void)updateUserPortrait:(NSString*)portrait
{
    if (portrait == nil) {
        return;
    }
    SPAccount* account = [self getCurrentUser];
    if (![account.user_avatar isEqualToString:portrait]) {
        account.user_avatar = portrait;
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:KEYCHAIN_IDENTIFIER];
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:account];
        [archiver finishEncoding];
        [keychain setData:data forKey:KEY_CHAIN_USR_KEY];
    }
}
-(void)updateUserId:(NSString*)userId
{
    if (userId == nil) {
        return;
    }
    SPAccount* account = [self getCurrentUser];
    if (![account.user_id isEqualToString:userId]) {
        account.user_id = userId;
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:KEYCHAIN_IDENTIFIER];
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:account];
        [archiver finishEncoding];
        [keychain setData:data forKey:KEY_CHAIN_USR_KEY];
        
    }
}

- (void)updateUserStatusIfNeeded{
    SPAccount *account = [self getCurrentUser];
    if (account) {
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:KEYCHAIN_IDENTIFIER];
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:account];
        [archiver finishEncoding];
        [keychain setData:data forKey:KEY_CHAIN_USR_KEY];
    }
}


- (void)updateUserStatus:(NSString *)newStatus{
    if (!newStatus) {
        return;
    }
    SPAccount* account = [self getCurrentUser];
    account.user_status = newStatus;
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:KEYCHAIN_IDENTIFIER];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:account];
    [archiver finishEncoding];
    [keychain setData:data forKey:KEY_CHAIN_USR_KEY];
}

@end


@implementation SPAccount

- (BOOL)isAlphaBind{
    BOOL bind = NO;
    @try {
        NSString *c = [self.user_status substringWithRange:NSMakeRange(self.user_status.length-3, 1)];
        bind = [c boolValue];
    } @catch (NSException *exception) {
        
    } @finally {
        return bind;
    }
}
- (BOOL)isMobileBind{
    BOOL bind = NO;
    @try {
        NSString *c = [self.user_status substringWithRange:NSMakeRange(self.user_status.length-1, 1)];
        bind = [c boolValue];
    } @catch (NSException *exception) {
        
    } @finally {
        return bind;
    }
}
- (BOOL)isWechatBind{
    BOOL bind = NO;
    @try {
        NSString *c = [self.user_status substringWithRange:NSMakeRange(self.user_status.length-2, 1)];
        bind = [c boolValue];
    } @catch (NSException *exception) {
        
    } @finally {
        return bind;
    }
}
@end
