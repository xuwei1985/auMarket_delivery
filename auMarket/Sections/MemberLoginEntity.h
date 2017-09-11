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

@property (nonatomic, copy) NSString *openid;//微信
@property (nonatomic, copy) NSString *utoken;//微信
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *userheader;
@property (nonatomic, copy) NSString *shopping_cart_item_count;
@property (nonatomic, copy) NSString *is_new_user;
@property (nonatomic, copy) NSString *user_status;

@end
