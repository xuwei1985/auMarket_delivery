//
//  UserCenterViewController.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseViewController.h"
#import "UserLoginViewController.h"
#import "MemberCell.h"
#import "MemberLoginModel.h"

@interface UserCenterViewController : SPBaseViewController
{
    NSMutableArray *_itemArr;
    UIImageView *_userInfoView;
    UIImageView *_headView;
    UILabel *_nicknameLbl;
    UILabel *_loginLbl;
    UIButton *_btn_exit;
}
@property (nonatomic, retain) MemberLoginModel *model;
@end
