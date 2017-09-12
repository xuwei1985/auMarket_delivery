//
//  UserCenterViewController.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseViewController.h"
#import "UserLoginViewController.h"
#import "OrderDetailCell.h"

@interface OrderDetailViewController : SPBaseViewController
{
    UIImageView *orderInfoView;
    UILabel *lbl_payType;
    UILabel *lbl_orderSum;
    UILabel *lbl_orderNo;
    UILabel *lbl_contact;
    UILabel *lbl_mobile;
    UILabel *lbl_address;
    UILabel *lbl_deliverytime;
    UILabel *lbl_packagenote;
    UIButton *_btn_doneAction;
    
    CLLocationCoordinate2D coordinate;
}
@end
