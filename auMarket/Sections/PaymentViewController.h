//
//  UserCenterViewController.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "SPUploadFileModel.h"
#import "TaskModel.h"
#import "PayCodeViewController.h"

@interface PaymentViewController : SPBaseViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
{
    UIImageView *orderInfoView;
    UIImageView *previewView;
    UIButton *btn_deletePreview;
    UILabel *lbl_packagenote;
    UIButton *_btn_doneAction;
    NSData *imageData;
    UITextView *text_msg;
    NSString *msg;
}
@property(nonatomic,retain) TaskItemEntity *task_entity;
@property(nonatomic,retain) TaskModel *model;
@property(nonatomic,retain) SPUploadFileModel *upload_model;
@property(nonatomic,retain) NSString *order_sn;
@property(nonatomic,assign) int payment_type;
@property(nonatomic,retain) NSDictionary *bank_info;
@end
