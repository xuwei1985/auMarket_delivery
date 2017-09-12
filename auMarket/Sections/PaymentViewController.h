//
//  UserCenterViewController.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseViewController.h"

@interface PaymentViewController : SPBaseViewController<UIActionSheetDelegate>
{
    UIImageView *orderInfoView;
    UIImageView *previewView;
    UILabel *lbl_packagenote;
    UIButton *_btn_doneAction;
}
@end
