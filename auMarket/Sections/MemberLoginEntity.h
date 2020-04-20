//
//  MemberLoginEntity.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/25.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseEntity.h"
@class MemberEntity;

@interface MemberLoginEntity : SPBaseEntity

@property(nonatomic,retain)MemberEntity *userinfo;
@end


@interface MemberEntity : SPBaseEntity

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *userheader;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *token;
@end
