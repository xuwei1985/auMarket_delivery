//
//  UserLoginViewController.h
//  zssq
//
//  Created by XuWei on 14-6-19.
//  Copyright (c) 2014年 zssq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserRegistViewController.h"
#import "MemberLoginModel.h"
#import "HomeViewController.h"

@interface UserLoginViewController : SPBaseViewController<UITextFieldDelegate,UIScrollViewDelegate,UITabBarControllerDelegate>
{
    UITextField *_accountText;
    UITextField *_passwordText;
}
@property (nonatomic, retain) MemberLoginModel *model;
@end
