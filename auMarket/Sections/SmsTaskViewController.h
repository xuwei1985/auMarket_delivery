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

@interface SmsTaskViewController : SPBaseViewController
{
    UIView *_summaryView;
    UIView *_summaryView_bottom;
    UIButton *_sumBtn;
    UIButton *_selectAllBtn;
    NSString *ids;
}


@property(nonatomic,retain) PredictTaskModel *model;
@end
