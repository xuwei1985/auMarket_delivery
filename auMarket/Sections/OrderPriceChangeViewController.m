//
//  OrderPriceChangeViewController.m
//  auMarket
//
//  Created by 吴绪伟 on 2019/07/02.
//  Copyright © 2019年 daao. All rights reserved.
//
#define DONE_ACTION_BAR 48.0
#import "OrderPriceChangeViewController.h"

@interface OrderPriceChangeViewController ()

@end

@implementation OrderPriceChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initData];
}

-(void)initUI{
    [self setNavigation];
    [self createPaymentInfoView];
    [self createDoneActionBar];
}

-(void)initData{
    imageData=nil;
    lbl_tip_value_1.text=[NSString stringWithFormat:@"$%@",self.task_entity.order_amount];
    if(self.changeType==1){
        lbl_tip_2.text=@"减价金额:";
    }
    else{
        lbl_tip_2.text=@"增加金额:";
    }
    [changePriceField becomeFirstResponder];
}

-(void)setNavigation{
    self.title=@"订单价格调整";
}

-(void)createPaymentInfoView{
    UILabel *lbl_tip_1=[[UILabel alloc] init];
    lbl_tip_1.textColor=COLOR_BLACK;
    lbl_tip_1.font=FONT_SIZE_BIG;
    lbl_tip_1.text=@"订单价格:";
    lbl_tip_1.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:lbl_tip_1];
    
    [lbl_tip_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35);
        make.size.mas_equalTo(CGSizeMake(70, 20));
        make.left.mas_equalTo(15);
    }];
    
    lbl_tip_value_1=[[UILabel alloc] init];
    lbl_tip_value_1.textColor=COLOR_BLACK;
    lbl_tip_value_1.font=FONT_SIZE_BIG;
    lbl_tip_value_1.textAlignment=NSTextAlignmentLeft;
    lbl_tip_value_1.text=@"$0.00";
    [self.view addSubview:lbl_tip_value_1];
    
    [lbl_tip_value_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_tip_1.mas_top);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(lbl_tip_1.mas_right).offset(10);
    }];
    
    lbl_tip_2=[[UILabel alloc] init];
    lbl_tip_2.textColor=COLOR_BLACK;
    lbl_tip_2.font=FONT_SIZE_BIG;
    lbl_tip_2.text=@"减价金额:";
    lbl_tip_2.textAlignment=NSTextAlignmentLeft;
    lbl_tip_2.numberOfLines=0;
    [self.view addSubview:lbl_tip_2];
    
    [lbl_tip_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(75);
        make.width.mas_equalTo(70);
        make.left.mas_equalTo(15);
    }];
    
    changePriceField = [[UITextField alloc] init];
    changePriceField.delegate=self;
    changePriceField.keyboardType=UIKeyboardTypeDecimalPad;
    changePriceField.backgroundColor=COLOR_BG_WHITE;
    changePriceField.layer.cornerRadius=3.0;
    changePriceField.clipsToBounds=YES;
    changePriceField.font=FONT_SIZE_BIG;
    changePriceField.clearButtonMode = UITextFieldViewModeNever; //编辑时会出现个修改X
    [changePriceField setValue:[NSNumber numberWithInt:10] forKey:@"paddingLeft"];
    [changePriceField setValue:[NSNumber numberWithInt:10] forKey:@"paddingRight"];
    [self.view addSubview:changePriceField];
    
    [changePriceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_tip_2.mas_top).offset(-7);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.left.mas_equalTo(lbl_tip_2.mas_right).offset(10);
        make.height.mas_equalTo(35);
    }];
    
    UIButton *upload_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    upload_btn.titleLabel.font=DEFAULT_FONT(14);;
    [upload_btn setTitle:@"上传照片" forState:UIControlStateNormal];
    upload_btn.backgroundColor=COLOR_MAIN;
    upload_btn.layer.cornerRadius=4;
    upload_btn.clipsToBounds=YES;
    upload_btn.titleEdgeInsets=UIEdgeInsetsMake(2, 5, 0, 0);
    [upload_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [upload_btn addTarget:self action:@selector(showPictureInputMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: upload_btn];
    
    [upload_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(changePriceField.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake((WIDTH_SCREEN-30), 40));
        make.left.mas_equalTo(15);
    }];
    
    previewView=[[UIImageView alloc] init];
    previewView.hidden=YES;
    previewView.backgroundColor=COLOR_GRAY;
    previewView.contentMode=UIViewContentModeScaleAspectFill;
    previewView.clipsToBounds=YES;
    previewView.userInteractionEnabled=YES;
    [previewView.layer setCornerRadius:6];
    previewView.clipsToBounds=YES;
    [self.view addSubview: previewView];
    
    [previewView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(browserPhoto)]];
    
    [previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(upload_btn.mas_bottom).offset(35);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN*0.35, WIDTH_SCREEN*0.35));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    btn_deletePreview=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn_deletePreview setTitle:@"删除图片" forState:UIControlStateNormal];
    [btn_deletePreview setTitleColor:COLOR_DARKGRAY forState:UIControlStateNormal];
    btn_deletePreview.titleLabel.font=FONT_SIZE_MIDDLE;
    btn_deletePreview.hidden=YES;
    [btn_deletePreview addTarget:self action:@selector(clearPreviewImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: btn_deletePreview];
    
    [btn_deletePreview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(previewView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 28));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
}

-(void)createDoneActionBar{
    _btn_doneAction=[UIButton buttonWithType:UIButtonTypeCustom];
    [_btn_doneAction setTitle:@"确认提交" forState:UIControlStateNormal];
    _btn_doneAction.titleLabel.textAlignment=NSTextAlignmentCenter;
    [_btn_doneAction setBackgroundColor:COLOR_BG_WHITE];
    [_btn_doneAction setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    _btn_doneAction.titleLabel.font=FONT_SIZE_BIG;
    [_btn_doneAction addTarget:self action:@selector(saveOrderPriceChange) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn_doneAction];
    
    
    @weakify(self);
    [_btn_doneAction mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.view.mas_bottom).offset(-48);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(WIDTH_SCREEN);
        make.height.mas_equalTo(DONE_ACTION_BAR);
    }];
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 0.5)];
    line.backgroundColor=RGBCOLOR(230, 230, 230);
    [_btn_doneAction addSubview:line];
}

-(void)clearPreviewImage:(id)sender{
    previewView.image=nil;
    imageData=nil;
    previewView.hidden=YES;
    btn_deletePreview.hidden=YES;
}

- (void)showPictureInputMenu
{
    UIActionSheet *actionsheet;
    actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"直接拍照", @"从相册选取", nil,nil];
    
    [actionsheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (0 == buttonIndex)//直接拍照
    {
        if([self imagePickerControlerIsAvailabelToCamera]){
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        else{
            [self showToastBottomWithText:@"您的设备不支持拍照"];
        }
    }
    else if (1 == buttonIndex)//从相册选取
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField==changePriceField){
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        keyboardDoneButtonView.barStyle = UIBarStyleDefault;
        keyboardDoneButtonView.translucent = YES;
        keyboardDoneButtonView.tintColor = RGBCOLOR(165, 165, 165);
        [keyboardDoneButtonView sizeToFit];
        
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                         style:UIBarButtonItemStyleBordered target:self
                                                                        action:@selector(changeNumCanceled:)];
        
        UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                                      target: nil
                                                                                      action: nil];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                       style:UIBarButtonItemStyleBordered target:self
                                                                      action:@selector(changeNumChanged:)];
        doneButton.tintColor=RGBCOLOR(99, 99, 99);
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:cancelButton,fixedButton,doneButton, nil]];
        textField.inputAccessoryView = keyboardDoneButtonView;
    }
}

-(void)changeNumCanceled:(id)sender{
    [changePriceField resignFirstResponder];
}

-(void)changeNumChanged:(id)sender{
    [changePriceField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //判断是否为删除字符，如果为删除则让执行
    char c=[string UTF8String][0];
    if (c=='\000') {
        return YES;
    }
    //长度限制
    if([textField.text length] > 6){
        textField.text = [textField.text substringToIndex:6];
        return NO;
    }
    
    return YES;
}


#pragma mark -
#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *hdImage = [info objectForKey:UIImagePickerControllerOriginalImage];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            float imgMinLenght=MIN(hdImage.size.width, hdImage.size.height);
            float imgScacle=hdImage.size.width/hdImage.size.height;
            CGSize newSize;
            if (imgMinLenght==hdImage.size.width) {
                newSize=CGSizeMake(800, 800/imgScacle);
            }
            else{
                newSize=CGSizeMake(800*imgScacle,800);
            }

            UIImage *newImg= [self thumbnailWithImageWithoutScale:hdImage size:newSize];
            imageData = UIImageJPEGRepresentation(newImg, 0.8);
            dispatch_async(dispatch_get_main_queue(), ^{
                previewView.hidden=NO;
                btn_deletePreview.hidden=NO;
                previewView.image = newImg;
            });
        });
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }

    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(800, 800)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    //    [userPhotoButton setImage:selfPhoto forState:UIControlStateNormal];
    previewView.hidden=NO;
    btn_deletePreview.hidden=NO;
    previewView.image = selfPhoto;
}

//1.改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

// 判断硬件是否支持拍照
- (BOOL)imagePickerControlerIsAvailabelToCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return YES;
    } else {
        return NO;
    }
}

-(void)browserPhoto{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];

    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.srcImageView = previewView; // 来源于哪个UIImageView
    photo.image=previewView.image;
    [photos addObject:photo];
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

-(void)saveOrderPriceChange{
    [[AlertBlockView sharedInstance] showChoiceAlert:@"确认提交吗？" button1Title:@"确定" button2Title:@"取消" completion:^(int index) {
        if(index==0){
            //判断订单金额合法性
            BOOL fg=YES;
            if(self.changeType==1){//减少订单金额的情况
                if(([self.task_entity.order_amount floatValue]+[self.task_entity.return_price floatValue]-[[changePriceField.text stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue])<0){
                    fg=NO;
                }
            }
            
            if(fg){
                [self startLoadingActivityIndicator];
                if(imageData){
                    [self.upload_model uploadImages:imageData andResourceType:@"order"];
                }
                else{
                    [self postOrderPriceChange];
                }
            }
            else{
                [self showToastWithText:@"不能低于订单可减金额"];
            }
        }
    }];
}

-(void)postOrderPriceChange{
    if(self.task_entity.order_id.length>0){
        change_price=0.0;
        if(self.changeType==1){
            change_price-=[[changePriceField.text stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];
        }
        else{
            change_price=[[changePriceField.text stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];
        }
        
        [self.model saveOrderChangePrice:self.task_entity.order_id andChagePrice:change_price andProof:self.upload_model.uploadEntity.filepath];
    }
    else{
        [self showToastTopWithText:@"没有配送订单信息"];
    }
}

-(void)onResponse:(SPBaseModel *)model isSuccess:(BOOL)isSuccess{
    if(model==self.upload_model){
        if(isSuccess){
            [self postOrderPriceChange];
        }
        else{
            [self stopLoadingActivityIndicator];
        }
    }
    else if(model==self.model&&self.model.requestTag==3003){
        [self stopLoadingActivityIndicator];
        if(isSuccess){
            [self showSuccesWithText:@"操作成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else if(model==self.model&&self.model.requestTag==3005){
        [self stopLoadingActivityIndicator];
        if(isSuccess){
            [self showSuccesWithText:@"保存成功"];
            self.task_entity.change_price=[NSString stringWithFormat:@"%.2f",change_price];
            changePriceField.text=@"";
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(TaskModel *)model{
    if(!_model){
        _model=[[TaskModel alloc] init];
        _model.delegate=self;
    }
    return _model;
}

-(SPUploadFileModel *)upload_model{
    if(!_upload_model){
        _upload_model=[[SPUploadFileModel alloc] init];
        _upload_model.delegate=self;
    }
    return _upload_model;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
