//
//  MemberCell.h
//  XiaoYa
//
//  Created by XuWei on 15/1/3.
//  Copyright (c) 2015年 xuwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PredictSettingCell : UITableViewCell<UITextFieldDelegate>
{
    UITextField *beginTxt;
    UITextField *endTxt;
    UILabel *linkLbl;
    UIImageView *beginArrow;
    UIImageView *endArrow;
}

@property(nonatomic,assign) NSString* begin_time;
@property(nonatomic,assign) NSString* end_time;
@end
