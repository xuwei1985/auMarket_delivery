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

@interface UserLoginViewController : SPBaseViewController<UITextFieldDelegate,UIScrollViewDelegate,UITabBarControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UITextField *_accountText;
    UITextField *_passwordText;
    UITextField *_verifyText;
    UITextField *_codeText;
    NSMutableArray *_mobileArray;
    UIPickerView *_picker_mobile;
    UILabel *_lbl_verify_mobile;
    UIButton *reSendBtn;
    BOOL isRequesting;
    int timeCount;
    NSTimer *timer;
    BOOL canGetCode;
    NSString *verify_mobile;
}
@property (nonatomic, retain) MemberLoginModel *model;
@end
