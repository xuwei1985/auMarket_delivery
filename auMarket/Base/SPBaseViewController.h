//
//  SPBaseViewController.h
//  Youpin
//
//  Created by DouJ on 15/3/7.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SPBaseTableViewCell.h"
#import "SPBaseTableView.h"
#import "SPBaseModel.h"
#import "KMActivityIndicator.h"
#import "AccountManager.h"

@interface SPBaseViewController : UIViewController <SPBaseModelProtocol,UITableViewDataSource,UITableViewDelegate>
{
    CALayer *_maskLayer;
}

@property (strong,nonatomic) KMActivityIndicator *loadingIndicator;
@property (strong,nonatomic) UIScrollView *netWorkErrorView;
@property (strong,nonatomic) UIView *loadingView;
@property (strong,nonatomic) UIScrollView *noContentView;
@property (strong,nonatomic) IBOutlet SPBaseTableView* tableView;

//
- (BOOL)prefersNaviagtionBarHidden;

//loading圈
-(void)startLoadingActivityIndicator;
-(void)startLoadingActivityIndicatorWithText:(NSString*)title;
-(void)stopLoadingActivityIndicator;

-(void)showSuccesWithText:(NSString*)text;
-(void)showFailWithText:(NSString*)text;

//Toast
-(void)showToastWithText:(NSString*)text;
-(void)showToastBottomWithText:(NSString*)text;
-(void)showToastTopWithText:(NSString*)text;

//nocontent界面
-(void)showNoContentViewWithTitle:(NSString*)title icon:(NSString*)imageName button:(UIButton*)button;
-(void)showNoContentView;
-(void)showNoContentViewWithTitle:(NSString *)title subTitle:(NSString*)title icon:(NSString*)imageName ;
-(void)hideNoContentView;

//network error界面
-(void)showNetWorkErrorWithTitle:(NSString*)title;
-(void)showNetWorkError;
-(void)hideNetWorkError;
-(void)onReloadBtnTap;


//tableView动画
-(void)reloadTableViewDataFadeAnimation:(BOOL)animation;

- (BOOL)checkLoginStatus;

- (void)showMaskView;
- (void)hideMaskView;

@end
