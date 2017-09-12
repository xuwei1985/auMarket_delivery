//
//  UserCenterViewController.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface PaymentViewController : SPBaseViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImageView *orderInfoView;
    UIImageView *previewView;
    UILabel *lbl_packagenote;
    UIButton *_btn_doneAction;
}
@end
