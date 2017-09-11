//
//  UserLoginViewController.h
//  zssq
//
//  Created by XuWei on 14-6-19.
//  Copyright (c) 2014年 zssq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserLoginViewController.h"
#import "CustomTextField.h"

@interface UserRegistViewController : SPBaseViewController<UITextFieldDelegate,UIScrollViewDelegate,UITabBarControllerDelegate>
{
    CustomTextField *accountText;
    CustomTextField *passwordText;
    CustomTextField *nicknameText;
    CustomTextField *checkCodeText;
    NSURLConnection *connection;
    NSMutableData *receivedData;
    NSString* getUrlString;
    NSString* smsCode;
    NSDictionary *personInfoDic;
}
@property (nonatomic, retain) UITextField *accountText;
@property (nonatomic, retain) UITextField *passwordText;
@property (nonatomic, retain) UITextField *nicknameText;
@property (nonatomic, retain) UITextField *checkCodeText;
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
@property (retain, nonatomic) NSString* getUrlString;


- (id)init:(int)n;
@end
