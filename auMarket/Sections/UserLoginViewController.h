//
//  UserLoginViewController.h
//  zssq
//
//  Created by XuWei on 14-6-19.
//  Copyright (c) 2014年 zssq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import "UserRegistViewController.h"
#import "MemberLoginModel.h"

@interface UserLoginViewController : SPBaseViewController<UITextFieldDelegate,UIScrollViewDelegate,UITabBarControllerDelegate>
{
    CustomTextField *_accountText;
    CustomTextField *_passwordText;
}
@property (nonatomic, retain) MemberLoginModel *model;
@property (nonatomic, assign) BOOL isModalState;
@end
