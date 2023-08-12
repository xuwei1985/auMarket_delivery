//
//  MemberCell.h
//  XiaoYa
//
//  Created by XuWei on 15/1/3.
//  Copyright (c) 2015年 xuwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PredictSettingCellDelegate

@optional
-(void)startTimeClick:(int)row_index fromTextField:(UITextField *)sender;
-(void)endTimeClick:(int)row_index fromTextField:(UITextField *)sender;
@end

@interface PredictSettingCell : UITableViewCell<UITextFieldDelegate>
{
    UITextField *beginTxt;
    UITextField *endTxt;
    UILabel *linkLbl;
    UIImageView *beginArrow;
    UIImageView *endArrow;
}

@property(nonatomic,retain) NSString* begin_time;
@property(nonatomic,retain) NSString* end_time;
@property(nonatomic,assign) int row_index;
@property (nonatomic, retain) NSObject<PredictSettingCellDelegate>* delegate;
-(void)showData;
@end
