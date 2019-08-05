//
//  OrderPriceChangeViewController.h
//  auMarket
//
//  Created by 吴绪伟 on 2019/07/02.
//  Copyright © 2019年 daao. All rights reserved.
//

#import "SPBaseViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "SPUploadFileModel.h"
#import "TaskModel.h"

@interface ReturnProofViewController : SPBaseViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
{
    UIImageView *orderInfoView;
    UIImageView *previewView;
    UIButton *btn_deletePreview;
    UILabel *lbl_packagenote;
    UIButton *_btn_doneAction;
    NSData *imageData;
    UILabel *lbl_tip_value_1;
    UITextView *text_msg;
    NSString *msg;
}
@property(nonatomic,retain) TaskItemEntity *task_entity;
@property(nonatomic,retain) TaskModel *model;
@property(nonatomic,retain) SPUploadFileModel *upload_model;
@property(nonatomic,assign) int returnPrice;//返现金额
@end
