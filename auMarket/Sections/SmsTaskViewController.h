//
//  PickViewController.h
//  auMarket
//
//  Created by 吴绪伟 on 2018/1/4.
//  Copyright © 2018年 daao. All rights reserved.
//

#import "SPBaseViewController.h"
#import "predictSmsTaskCell.h"
#import "PredictTaskModel.h"
#import <MJRefresh.h>

@interface SmsTaskViewController : SPBaseViewController<UITextFieldDelegate>
{
    UIView *_summaryView;
    UIView *_summaryView_bottom;
    UIButton *_sumBtn;
    UIButton *_selectAllBtn;
    NSString *ids;
    UIView *blockView;
    UIButton *btn_picking;
    UIButton *btn_picked;
    UIAlertView *_inputAlertView;
    UIBarButtonItem *right_Item;
}


@property(nonatomic,retain) PredictTaskModel *model;
@property(nonatomic,assign) int list_type;
@end
