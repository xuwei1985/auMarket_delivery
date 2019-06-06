//
//  goodsBindViewController.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseViewController.h"
#import "PickOrderCell.h"
#import "GoodsListItemCell.h"
#import "PickModel.h"
#import "OrderDetailViewController.h"

@interface PickOrderViewController : SPBaseViewController<UIActionSheetDelegate,UITextFieldDelegate>
{
    UIButton *btn_picking;
    UIButton *btn_picked;
    UIView *blockView;
    NSIndexPath *current_confirm_path;
    UIAlertView *_inputAlertView;
    UIButton *doneBtn;
    NSMutableString *all_delivery_ids;
    NSMutableString *all_order_ids;
    PickItemEntity *sel_entity;
}
@property(nonatomic,retain) PickModel *model;
@property(nonatomic,retain) NSString *order_ids;
@property(nonatomic,assign) int list_type;
@end
