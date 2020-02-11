//
//  ReturnProofViewController.m
//  auMarket
//
//  Created by 吴绪伟 on 2019/07/02.
//  Copyright © 2019年 daao. All rights reserved.
//
#define DONE_ACTION_BAR (IS_IPhoneX?64.0f:48.0f)
#import "ReturnProofViewController.h"

@interface ReturnProofViewController ()

@end

@implementation ReturnProofViewController

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
    lbl_tip_value_1.text=[NSString stringWithFormat:@"$%d",self.returnPrice];
}

-(void)setNavigation{
    self.title=@"朋友圈返现";
}

-(void)createPaymentInfoView{
    UILabel *lbl_tip_1=[[UILabel alloc] init];
    lbl_tip_1.textColor=COLOR_BLACK;
    lbl_tip_1.font=FONT_SIZE_MIDDLE;
    lbl_tip_1.text=@"返现金额:";
    lbl_tip_1.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:lbl_tip_1];
    
    [lbl_tip_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(70, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_tip_value_1=[[UILabel alloc] init];
    lbl_tip_value_1.textColor=COLOR_BLACK;
    lbl_tip_value_1.font=FONT_SIZE_MIDDLE;
    lbl_tip_value_1.textAlignment=NSTextAlignmentLeft;
    lbl_tip_value_1.text=@"$0.00";
    [self.view addSubview:lbl_tip_value_1];
    
    [lbl_tip_value_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_tip_1.mas_top);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(lbl_tip_1.mas_right).offset(10);
    }];
    
    UILabel *lbl_tip_8=[[UILabel alloc] init];
    lbl_tip_8.textColor=COLOR_BLACK;
    lbl_tip_8.font=FONT_SIZE_MIDDLE;
    lbl_tip_8.text=@"留言备注:";
    lbl_tip_8.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:lbl_tip_8];
    
    [lbl_tip_8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_tip_1.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(10);
    }];
    
    //初始化UITextView
    text_msg =  [[UITextView alloc] init];
    text_msg.backgroundColor=COLOR_BG_WHITE; //设置背景色
    text_msg.scrollEnabled = YES;    //设置当文字超过视图的边框时是否允许滑动，默认为“YES”
    text_msg.editable = YES;        //设置是否允许编辑内容，默认为“YES”
    text_msg.delegate = self;       //设置代理方法的实现类
    text_msg.font=FONT_SIZE_MIDDLE; //设置字体名字和字体大小;
    text_msg.returnKeyType = UIReturnKeyDone;//设置return键的类型
    text_msg.keyboardType = UIKeyboardTypeDefault;//设置键盘类型一般为默认
    text_msg.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
    text_msg.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
    text_msg.textColor = COLOR_DARKGRAY;// 设置显示文字颜色
    text_msg.text = @"";//设置显示的文本内容
    text_msg.layer.cornerRadius=3.0;
    text_msg.clipsToBounds=YES;
    text_msg.layoutManager.allowsNonContiguousLayout=NO;//防止在拼音打字时抖动
    [self.view addSubview:text_msg];
    
    [text_msg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_tip_8.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-20, 75));
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
        make.top.mas_equalTo(text_msg.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake((WIDTH_SCREEN-30), 42));
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
    [_btn_doneAction addTarget:self action:@selector(saveReturnProof) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn_doneAction];
    
    
    @weakify(self);
    [_btn_doneAction mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.view.mas_bottom).offset(DONE_ACTION_BAR*-1);
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

-(void)saveReturnProof{
    [[AlertBlockView sharedInstance] showChoiceAlert:@"确认提交吗？" button1Title:@"确定" button2Title:@"取消" completion:^(int index) {
        if(index==0){
            [text_msg resignFirstResponder];
            msg=[text_msg.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [self startLoadingActivityIndicator];
            if(imageData){
                [self.upload_model uploadImages:imageData andResourceType:@"return"];
            }
            else{
                [self postReturnProof];
            }
        }
    }];
}


#pragma mark - TextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    int n=[Common getStingToInt:[textView.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]/2;
    
    //回车即完成
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    //判断是否为删除字符，如果为删除则让执行
    char c=[text UTF8String][0];
    if (c=='\000') {
        //numberOfCharsLabel.text=[NSString stringWithFormat:@"%d",50-[[contentText text] length]+1];
        return YES;
    }
    
    if(n>=120){
        return NO;
    }
    
    if(n>=120) {
        if(![text isEqualToString:@"\b"]) return NO;
    }
    
    //numberOfCharsLabel.text=[NSString stringWithFormat:@"%d",MaxNumberOfDescriptionChars-[[textView text] length]-[text length]];
    
    //    contentText.selectedRange = range;
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    //该判断用于联想输入
    int n=[Common getStingToInt:[textView.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]/2;
    if (n >= 120)
    {
        //获取光标位置
        NSMutableString *tobeStr = [NSMutableString stringWithString:textView.text];
        text_msg.text = [tobeStr substringToIndex:120];
    }
}


-(void)postReturnProof{
    if(self.task_entity.order_id.length>0){
        [self.model saveOrderReturnInfo:self.task_entity.order_id andReturnPrice:self.returnPrice andProof:self.upload_model.uploadEntity.filepath andMsg:msg];
    }
    else{
        [self showToastTopWithText:@"没有配送订单信息"];
    }
}

-(void)onResponse:(SPBaseModel *)model isSuccess:(BOOL)isSuccess{
    if(model==self.upload_model){
        if(isSuccess){
            [self postReturnProof];
        }
        else{
            [self stopLoadingActivityIndicator];
        }
    }
    else if(model==self.model&&self.model.requestTag==3004){
        [self stopLoadingActivityIndicator];
        if(isSuccess){
            [self showSuccesWithText:@"保存成功"];
            text_msg.text=@"";
            self.task_entity.return_price=[NSString stringWithFormat:@"%d",self.returnPrice];
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
