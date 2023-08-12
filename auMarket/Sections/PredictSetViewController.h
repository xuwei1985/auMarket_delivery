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

@interface PredictSetViewController : SPBaseViewController<UITextFieldDelegate,PredictTimeSectionViewDelegate,PredictSettingCellDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    PredictTimeSectionView *headerView;
    UIView *footerView;
    UIButton *postBtn;
    
    int shipping_date_id;
    int request_num;
    int predict_select_index;
    int predict_model; //1：时间段的选择器,2:请求数量的选择，3：时间点的选择器
    int current_row_index;//当前操作下的表格所在行索引
    int current_time_mode;//当前操作下的表格内是开始时间还是结束时间 1开始 2结束
    UITextField *_txt_predict;
    UITextField *_focus_predict;
    UIPickerView *predictTimePicker;
    NSArray*request_num_arr;
    NSMutableArray<PredictTimeEntity *>*predict_time_arr;
    NSMutableArray<PredictTimeEntity *>*predict_data_arr;
    NSMutableArray<TimeItemEntity *>*predict_section_arr; //时间段的数据源
}
@property(nonatomic,retain) TaskModel *model;
@end
