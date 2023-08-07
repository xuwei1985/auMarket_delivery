//
//  PickViewController.h
//  auMarket
//
//  Created by 吴绪伟 on 2018/1/4.
//  Copyright © 2018年 daao. All rights reserved.
//

#import "SPBaseViewController.h"
#import "PredictSettingCell.h"
#import "PredictTimeSectionView.h"

@interface PredictSetViewController : SPBaseViewController<UITextFieldDelegate>
{
    PredictTimeSectionView *headerView;
    UIView *footerView;
    
}
@property(nonatomic,retain) TaskModel *model;
@end
