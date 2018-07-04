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

@interface PickOrderCell : UITableViewCell
{
    UIImageView *_iconImageView;
    UILabel *lbl_package_number;
    UILabel *lbl_package_title;
}

@property(nonatomic,retain) PickItemEntity *entity;
@property(nonatomic,assign) int row_index;
@property(nonatomic,assign) int list_type;
@end
