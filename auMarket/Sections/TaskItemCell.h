//
//  GoodsCategoryParentCell.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/13.
//  Copyright © 2016年 daao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskEntity.h"


@interface TaskItemCell : UITableViewCell<UITextFieldDelegate,UIAlertViewDelegate>{
    UIImageView *_iconImageView;
    UILabel *lbl_package_number;
    UILabel *lbl_package_title;
}

@property(nonatomic,retain)TaskItemEntity *entity;
@property(nonatomic,assign) int row_index;
@end
