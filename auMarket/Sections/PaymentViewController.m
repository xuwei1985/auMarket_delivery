//
//  UserCenterViewController.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//
#define DONE_ACTION_BAR 48.0
#import "PaymentViewController.h"

@interface PaymentViewController ()

@end

@implementation PaymentViewController

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
    
}

-(void)setNavigation{
    self.title=@"转账信息";
}

-(void)createPaymentInfoView{
    UIView *blockView_1=[[UIView alloc] initWithFrame:CGRectMake(0, 10, WIDTH_SCREEN, 123)];
    blockView_1.backgroundColor=COLOR_WHITE;
    UIView *blockView_2=[[UIView alloc] initWithFrame:CGRectMake(0, 140, WIDTH_SCREEN, 85)];
    blockView_2.backgroundColor=COLOR_WHITE;
    
    [self.view addSubview:blockView_1];
    [self.view addSubview:blockView_2];
    
    
    ////////////////blockView_1///////////////
    UILabel *lbl_tip_1=[[UILabel alloc] init];
    lbl_tip_1.textColor=COLOR_BLACK;
    lbl_tip_1.font=FONT_SIZE_MIDDLE;
    lbl_tip_1.text=@"转账信息";
    lbl_tip_1.textAlignment=NSTextAlignmentLeft;
    [blockView_1 addSubview:lbl_tip_1];
    
    [lbl_tip_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_1.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(10);
    }];
    
    UILabel *lbl_tip_2=[[UILabel alloc] init];
    lbl_tip_2.textColor=COLOR_MAIN;
    lbl_tip_2.font=FONT_SIZE_MIDDLE;
    lbl_tip_2.text=@"Account Name:Transcity Trading\nBSB:033172\nAccount Number:867082";
    lbl_tip_2.textAlignment=NSTextAlignmentLeft;
    lbl_tip_2.numberOfLines=0;
    [blockView_1 addSubview:lbl_tip_2];
    
    [lbl_tip_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_1.top).offset(40);
        make.right.mas_equalTo(blockView_1.mas_right).offset(-10);
        make.left.mas_equalTo(10);
    }];
    
    UILabel *lbl_tip_3=[[UILabel alloc] init];
    lbl_tip_3.textColor=COLOR_GRAY;
    lbl_tip_3.font=FONT_SIZE_SMALL;
    lbl_tip_3.text=@"提示:请务必检查BSB和Account Number是否输入正确";
    lbl_tip_3.textAlignment=NSTextAlignmentLeft;
    [blockView_1 addSubview:lbl_tip_3];
    
    [lbl_tip_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(blockView_1.bottom).offset(-8);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-20, 20));
        make.left.mas_equalTo(10);
    }];

    
    ////////////////blockView_2///////////////
    UILabel *lbl_tip_8=[[UILabel alloc] init];
    lbl_tip_8.textColor=COLOR_BLACK;
    lbl_tip_8.font=FONT_SIZE_MIDDLE;
    lbl_tip_8.text=@"快递员注意:";
    lbl_tip_8.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_tip_8];
    
    [lbl_tip_8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(120, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_packagenote=[[UILabel alloc] init];
    lbl_packagenote.textColor=COLOR_DARKGRAY;
    lbl_packagenote.font=FONT_SIZE_SMALL;
    lbl_packagenote.numberOfLines=0;
    lbl_packagenote.text=@"转账必须拍转账截图哦，然后上传，会计需要审核的，谢谢配合！";
    lbl_packagenote.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_packagenote];
    
    [lbl_packagenote mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(38);
        make.right.mas_equalTo(blockView_2.mas_right).offset(-10);
        make.left.mas_equalTo(10);
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
        make.top.mas_equalTo(blockView_2.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake((WIDTH_SCREEN-40), 38));
        make.left.mas_equalTo(20);
    }];
    
    previewView=[[UIImageView alloc] init];
    previewView.hidden=YES;
    previewView.backgroundColor=COLOR_GRAY;
    [self.view addSubview: previewView];
    
    [previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(upload_btn.mas_bottom).offset(35);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN*0.35, WIDTH_SCREEN*0.35));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
}

-(void)createDoneActionBar{
    _btn_doneAction=[UIButton buttonWithType:UIButtonTypeCustom];
    [_btn_doneAction setTitle:@"完成订单" forState:UIControlStateNormal];
    _btn_doneAction.titleLabel.textAlignment=NSTextAlignmentCenter;
    [_btn_doneAction setBackgroundColor:RGBCOLOR(255, 255, 255)];
    [_btn_doneAction setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    _btn_doneAction.titleLabel.font=FONT_SIZE_BIG;
    [_btn_doneAction addTarget:self action:@selector(requestFinishDelivery) forControlEvents:UIControlEventTouchUpInside];
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

- (void)showPictureInputMenu
{
    UIActionSheet *actionsheet;
    actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"直接拍照", @"从相册选取", nil,nil];
    
    [actionsheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex=%ld", buttonIndex);
    
    if (0 == buttonIndex)//直接拍照
    {
        
    }
    else if (1 == buttonIndex)//从相册选取
    {
        
    }
}

-(void)requestFinishDelivery{
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
