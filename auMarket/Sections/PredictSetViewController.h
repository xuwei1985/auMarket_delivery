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

@interface PredictSetViewController : SPBaseViewController<UITextFieldDelegate,PredictTimeSectionViewDelegate,PredictSettingCellDelegate>
{
    PredictTimeSectionView *headerView;
    UIView *footerView;
    UIButton *postBtn;
    
    int predict_select_index;
    UIPickerView *predictTimePicker;
    NSMutableArray<PredictTimeEntity *>*predict_time_arr;
}
@property(nonatomic,retain) TaskModel *model;
@end
