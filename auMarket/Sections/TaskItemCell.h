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
    UILabel *_taskTitleLbl;
    UIImageView *_iconView;
}

@property(nonatomic,retain)TaskEntity *entity;
@property(nonatomic,retain)NSIndexPath *indexPath;
@end
