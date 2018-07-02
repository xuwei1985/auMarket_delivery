//
//  MemberCell.h
//  XiaoYa
//
//  Created by XuWei on 15/1/3.
//  Copyright (c) 2015年 xuwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PickEntity.h"

@interface PickGoodsCell : UITableViewCell
{
    UIImageView *_iconImageView;
    UILabel *lbl_box_mark;
    UILabel *lbl_goods_name;
    UILabel *lbl_goods_number;
    UILabel *lbl_box_name;
    UILabel *lbl_shelf_code;
    UILabel *lbl_care_mark;
}

@property(nonatomic,retain) PickItemEntity *entity;
@end
