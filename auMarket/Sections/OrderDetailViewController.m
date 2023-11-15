//
//  UserCenterViewController.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//
#define ORDER_INFO_PANEL_HEIGHT 704
#define DONE_ACTION_BAR (IS_IPhoneX?64.5f:48.5f)
#import "OrderDetailViewController.h"

@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self initData];
}

-(void)initUI{
    [self setNavigation];
    if(self.order_id!=nil&&self.order_id.length>0){
        [self createOrderInfoView2];
    }
    else{
        [self createOrderInfoView];
        [self createDoneActionBar];
    }
    
    [self setUpTableView];
}

-(void)initData{
    [self loadGoodsForOrder];
    if(self.order_id==nil||self.order_id.length<=0){
        [self loadDeliveryInfo];
    }else{
        [self loadNoteInfo];
    }
}

-(void)setNavigation{
    self.title=@"订单详情";
    if(self.order_id==nil||self.order_id.length<=0){
        UIBarButtonItem *right_Item_cart = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"money_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(showAdjustPriceMenu)];
        self.navigationItem.rightBarButtonItem=right_Item_cart;
     }
}

//上货列表点击订单详情的信息板
-(void)createOrderInfoView2{
    ////////////////blockView_21///////////////
    blockView_21=[[UIView alloc] initWithFrame:CGRectMake(0, 12, WIDTH_SCREEN, 220)];
    blockView_21.backgroundColor=COLOR_WHITE;
    
    lbl_service_title=[[UILabel alloc] init];
    lbl_service_title.textColor=COLOR_BLACK;
    lbl_service_title.font=FONT_SIZE_MIDDLE;
    lbl_service_title.text=@"客服留言:";
    lbl_service_title.textAlignment=NSTextAlignmentLeft;
    [blockView_21 addSubview:lbl_service_title];
    
    [lbl_service_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_21.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(120, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_servicenote=[[UILabel alloc] initWithFrame:CGRectMake(10, 32, WIDTH_SCREEN-20, 20)];
    lbl_servicenote.textColor=COLOR_GRAY;
    lbl_servicenote.font=FONT_SIZE_MIDDLE;
    lbl_servicenote.numberOfLines=0;
    lbl_servicenote.text=@"暂无留言";
    lbl_servicenote.textAlignment=NSTextAlignmentLeft;
    [blockView_21 addSubview:lbl_servicenote];
    
    lbl_package_title=[[UILabel alloc] init];
    lbl_package_title.textColor=COLOR_BLACK;
    lbl_package_title.font=FONT_SIZE_MIDDLE;
    lbl_package_title.text=@"普通打包留言:";
    lbl_package_title.textAlignment=NSTextAlignmentLeft;
    [blockView_21 addSubview:lbl_package_title];
    
    [lbl_package_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_servicenote.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(120, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_packagenote=[[UILabel alloc] initWithFrame:CGRectMake(10, 82, WIDTH_SCREEN-20, 20)];
    lbl_packagenote.textColor=COLOR_GRAY;
    lbl_packagenote.font=FONT_SIZE_MIDDLE;
    lbl_packagenote.numberOfLines=0;
    lbl_packagenote.lineBreakMode = NSLineBreakByWordWrapping;
    lbl_packagenote.text=@"暂无留言";
    lbl_packagenote.textAlignment=NSTextAlignmentLeft;
    [blockView_21 addSubview:lbl_packagenote];
    
    lbl_freeze_package_title=[[UILabel alloc] init];
    lbl_freeze_package_title.textColor=COLOR_BLACK;
    lbl_freeze_package_title.font=FONT_SIZE_MIDDLE;
    lbl_freeze_package_title.text=@"冷冻打包留言:";
    lbl_freeze_package_title.textAlignment=NSTextAlignmentLeft;
    [blockView_21 addSubview:lbl_freeze_package_title];
    
    [lbl_freeze_package_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_packagenote.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(120, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_freeze_packagenote=[[UILabel alloc] initWithFrame:CGRectMake(10, 130, WIDTH_SCREEN-20, 20)];
    lbl_freeze_packagenote.textColor=COLOR_GRAY;
    lbl_freeze_packagenote.font=FONT_SIZE_MIDDLE;
    lbl_freeze_packagenote.numberOfLines=0;
    lbl_freeze_packagenote.text=@"暂无留言";
    lbl_freeze_packagenote.textAlignment=NSTextAlignmentLeft;
    [blockView_21 addSubview:lbl_freeze_packagenote];
    
    lbl_food_package_title=[[UILabel alloc] init];
    lbl_food_package_title.textColor=COLOR_BLACK;
    lbl_food_package_title.font=FONT_SIZE_MIDDLE;
    lbl_food_package_title.text=@"熟食打包留言:";
    lbl_food_package_title.textAlignment=NSTextAlignmentLeft;
    [blockView_21 addSubview:lbl_food_package_title];
    
    [lbl_food_package_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_freeze_packagenote.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(120, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_food_packagenote=[[UILabel alloc] initWithFrame:CGRectMake(10, 178, WIDTH_SCREEN-20, 20)];
    lbl_food_packagenote.textColor=COLOR_GRAY;
    lbl_food_packagenote.font=FONT_SIZE_MIDDLE;
    lbl_food_packagenote.numberOfLines=0;
    lbl_food_packagenote.text=@"暂无留言";
    lbl_food_packagenote.textAlignment=NSTextAlignmentLeft;
    [blockView_21 addSubview:lbl_food_packagenote];
    
    blockView_22=[[UIView alloc] initWithFrame:CGRectMake(0, blockView_21.frame.size.height+12+12, WIDTH_SCREEN, 200)];
    blockView_22.backgroundColor=COLOR_WHITE;
    blockView_22.userInteractionEnabled=YES;
    
    blockView_23=[[UIView alloc] initWithFrame:CGRectMake(0, blockView_22.frame.origin.y+blockView_22.frame.size.height+12, WIDTH_SCREEN, (self.task_entity.delivery_info.count*25+35)+12)];
    blockView_23.backgroundColor=COLOR_WHITE;
    blockView_23.userInteractionEnabled=YES;
    
    orderInfoView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN,blockView_23.frame.origin.y+blockView_23.frame.size.height)];
    orderInfoView.userInteractionEnabled=YES;
    orderInfoView.backgroundColor=COLOR_CLEAR;
    [orderInfoView addSubview:blockView_21];
    [orderInfoView addSubview:blockView_22];
    [orderInfoView addSubview:blockView_23];
    
    UILabel *lbl_tip_1=[[UILabel alloc] init];
    lbl_tip_1.textColor=COLOR_BLACK;
    lbl_tip_1.font=FONT_SIZE_MIDDLE;
    lbl_tip_1.text=@"订单状态";
    lbl_tip_1.textAlignment=NSTextAlignmentLeft;
    [blockView_22 addSubview:lbl_tip_1];
    
    [lbl_tip_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_22.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_state=[[UILabel alloc] init];
    lbl_state.textColor=COLOR_MAIN;
    lbl_state.font=FONT_SIZE_MIDDLE;
    lbl_state.text=@"--";
    lbl_state.textAlignment=NSTextAlignmentRight;
    [blockView_22 addSubview:lbl_state];
    
    [lbl_state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_22.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.right.mas_equalTo(blockView_22.mas_right).offset(-10);
    }];
    
    UILabel *lbl_tip_2=[[UILabel alloc] init];
    lbl_tip_2.textColor=COLOR_BLACK;
    lbl_tip_2.font=FONT_SIZE_MIDDLE;
    lbl_tip_2.text=@"拣货员";
    lbl_tip_2.textAlignment=NSTextAlignmentLeft;
    [blockView_22 addSubview:lbl_tip_2];
    
    [lbl_tip_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_22.top).offset(40);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_picker=[[UILabel alloc] init];
    lbl_picker.textColor=COLOR_BLACK;
    lbl_picker.font=FONT_SIZE_MIDDLE;
    lbl_picker.text=@"--";
    lbl_picker.textAlignment=NSTextAlignmentRight;
    [blockView_22 addSubview:lbl_picker];
    
    [lbl_picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_22.top).offset(40);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.right.mas_equalTo(blockView_22.mas_right).offset(-10);
    }];
    
    UILabel *lbl_tip_3=[[UILabel alloc] init];
    lbl_tip_3.textColor=COLOR_BLACK;
    lbl_tip_3.font=FONT_SIZE_MIDDLE;
    lbl_tip_3.text=@"拣货时间";
    lbl_tip_3.textAlignment=NSTextAlignmentLeft;
    [blockView_22 addSubview:lbl_tip_3];
    
    [lbl_tip_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_22.top).offset(70);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_pick_time=[[UILabel alloc] init];
    lbl_pick_time.textColor=COLOR_BLACK;
    lbl_pick_time.font=FONT_SIZE_MIDDLE;
    lbl_pick_time.text=@"--";
    lbl_pick_time.textAlignment=NSTextAlignmentRight;
    [blockView_22 addSubview:lbl_pick_time];
    
    [lbl_pick_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_22.top).offset(70);
        make.size.mas_equalTo(CGSizeMake(190, 20));
        make.right.mas_equalTo(blockView_22.mas_right).offset(-10);
    }];
    
    UILabel *lbl_tip_4=[[UILabel alloc] init];
    lbl_tip_4.textColor=COLOR_BLACK;
    lbl_tip_4.font=FONT_SIZE_MIDDLE;
    lbl_tip_4.text=@"打包箱";
    lbl_tip_4.textAlignment=NSTextAlignmentLeft;
    [blockView_22 addSubview:lbl_tip_4];
    
    [lbl_tip_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_22.top).offset(100);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_box=[[UILabel alloc] init];
    lbl_box.textColor=COLOR_BLACK;
    lbl_box.font=FONT_SIZE_MIDDLE;
    lbl_box.text=@"--";
    lbl_box.textAlignment=NSTextAlignmentRight;
    [blockView_22 addSubview:lbl_box];
    
    [lbl_box mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_22.top).offset(100);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.right.mas_equalTo(blockView_22.mas_right).offset(-10);
    }];
    
    
    UILabel *lbl_tip_6=[[UILabel alloc] init];
    lbl_tip_6.textColor=COLOR_BLACK;
    lbl_tip_6.font=FONT_SIZE_MIDDLE;
    lbl_tip_6.text=@"打包员";
    lbl_tip_6.textAlignment=NSTextAlignmentLeft;
    [blockView_22 addSubview:lbl_tip_6];
    
    [lbl_tip_6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_22.top).offset(130);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_packer=[[UILabel alloc] init];
    lbl_packer.textColor=COLOR_BLACK;
    lbl_packer.font=FONT_SIZE_MIDDLE;
    lbl_packer.text=@"--";
    lbl_packer.textAlignment=NSTextAlignmentRight;
    [blockView_22 addSubview:lbl_packer];
    
    [lbl_packer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_22.top).offset(130);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.right.mas_equalTo(blockView_22.mas_right).offset(-10);
    }];
    
    UILabel *lbl_tip_7=[[UILabel alloc] init];
    lbl_tip_7.textColor=COLOR_BLACK;
    lbl_tip_7.font=FONT_SIZE_MIDDLE;
    lbl_tip_7.text=@"打包时间";
    lbl_tip_7.textAlignment=NSTextAlignmentLeft;
    [blockView_22 addSubview:lbl_tip_7];
    
    [lbl_tip_7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_22.top).offset(160);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_pack_time=[[UILabel alloc] init];
    lbl_pack_time.textColor=COLOR_BLACK;
    lbl_pack_time.font=FONT_SIZE_MIDDLE;
    lbl_pack_time.text=@"--";
    lbl_pack_time.textAlignment=NSTextAlignmentRight;
    [blockView_22 addSubview:lbl_pack_time];
    
    [lbl_pack_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_22.top).offset(160);
        make.size.mas_equalTo(CGSizeMake(190, 20));
        make.right.mas_equalTo(blockView_22.mas_right).offset(-10);
    }];
    
    
    UILabel *lbl_section=[[UILabel alloc] init];
    lbl_section.textColor=[UIColor colorWithString:@"#4085EF"];
    lbl_section.font=FONT_SIZE_MIDDLE;
    lbl_section.text=@"历史配送:";
    lbl_section.textAlignment=NSTextAlignmentLeft;
    [blockView_23 addSubview:lbl_section];
    
    [lbl_section mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(10);
    }];
    
    if(self.task_entity.delivery_info!=nil&&self.task_entity.delivery_info.count>0){
        for(int i=0;i<self.task_entity.delivery_info.count;i++){
            UILabel *lbl_tip=[[UILabel alloc] init];
            lbl_tip.textColor=COLOR_DARKGRAY;
            lbl_tip.font=FONT_SIZE_SMALL;
            lbl_tip.text=[NSString stringWithFormat:@"[%@] - %@",[self.task_entity.delivery_info objectAtIndex:i].add_time,[self.task_entity.delivery_info objectAtIndex:i].staff];
            lbl_tip.textAlignment=NSTextAlignmentLeft;
            [blockView_23 addSubview:lbl_tip];
           
            [lbl_tip mas_makeConstraints:^(MASConstraintMaker *make) {
               make.top.mas_equalTo(blockView_23.top).offset(40+(i*25));
               make.size.mas_equalTo(CGSizeMake(190, 20));
               make.left.mas_equalTo(10);
            }];
           
            UILabel *lbl_tip_value=[[UILabel alloc] init];
            lbl_tip_value.textColor=COLOR_DARKGRAY;
            lbl_tip_value.font=FONT_SIZE_SMALL;
            lbl_tip_value.text=[self.task_entity.delivery_info objectAtIndex:i].flow_name;
            lbl_tip_value.textAlignment=NSTextAlignmentRight;
            [blockView_23 addSubview:lbl_tip_value];
           
            [lbl_tip_value mas_makeConstraints:^(MASConstraintMaker *make) {
               make.top.mas_equalTo(blockView_22.top).offset(40+(i*25));
               make.size.mas_equalTo(CGSizeMake(100, 20));
               make.right.mas_equalTo(blockView_23.mas_right).offset(-10);
            }];
        }
    }
}


-(void)createOrderInfoView{
   blockView_0=[[UIView alloc] initWithFrame:CGRectMake(0, 12, WIDTH_SCREEN, 75)];
   blockView_0.backgroundColor=COLOR_WHITE;
    
    blockView_5=[[UIView alloc] initWithFrame:CGRectMake(0, 99, WIDTH_SCREEN, 150)];
    blockView_5.backgroundColor=COLOR_WHITE;
    blockView_5.userInteractionEnabled=YES;
   
   blockView_1=[[UIView alloc] initWithFrame:CGRectMake(0, 261, WIDTH_SCREEN, 75)];
   blockView_1.backgroundColor=COLOR_WHITE;

   blockView_2=[[UIView alloc] initWithFrame:CGRectMake(0, 348, WIDTH_SCREEN, 130)];
   blockView_2.backgroundColor=COLOR_WHITE;
   blockView_2.userInteractionEnabled=YES;
   
   blockView_3=[[UIView alloc] initWithFrame:CGRectMake(0, 490, WIDTH_SCREEN, 235)];
   blockView_3.backgroundColor=COLOR_WHITE;
   blockView_3.userInteractionEnabled=YES;
   
   blockView_4=[[UIView alloc] initWithFrame:CGRectMake(0, 712, WIDTH_SCREEN, 45)];
   blockView_4.clipsToBounds=YES;
   blockView_4.backgroundColor=COLOR_WHITE;
   
   
   orderInfoView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, ORDER_INFO_PANEL_HEIGHT)];
   orderInfoView.userInteractionEnabled=YES;
   orderInfoView.backgroundColor=COLOR_CLEAR;
   
   [orderInfoView addSubview:blockView_0];
   [orderInfoView addSubview:blockView_1];
   [orderInfoView addSubview:blockView_2];
   [orderInfoView addSubview:blockView_3];
   [orderInfoView addSubview:blockView_4];
   [orderInfoView addSubview:blockView_5];
   
   
   ////////////////blockView_0///////////////
   UILabel *lbl_tip_0=[[UILabel alloc] init];
   lbl_tip_0.textColor=COLOR_BLACK;
   lbl_tip_0.font=FONT_SIZE_MIDDLE;
   lbl_tip_0.text=@"包裹总数";
   lbl_tip_0.textAlignment=NSTextAlignmentLeft;
   [blockView_0 addSubview:lbl_tip_0];
   
   [lbl_tip_0 mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.mas_equalTo(blockView_1.top).offset(10);
       make.size.mas_equalTo(CGSizeMake(100, 20));
       make.left.mas_equalTo(10);
   }];
    
    lbl_packageNum=[[UILabel alloc] init];
    lbl_packageNum.textColor=COLOR_WHITE;
    lbl_packageNum.font=[UIFont boldSystemFontOfSize:14.0];
    lbl_packageNum.text=@"0";
    lbl_packageNum.backgroundColor=COLOR_MAIN;
    lbl_packageNum.textAlignment=NSTextAlignmentCenter;
    lbl_packageNum.clipsToBounds=YES;
    [lbl_packageNum.layer setCornerRadius:10.0f];
    [blockView_0 addSubview:lbl_packageNum];
    
    [lbl_packageNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_0.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(40, 20));
        make.right.mas_equalTo(blockView_0.mas_right).offset(-10);
    }];
    
    //创建动态包裹标签
    //NSArray *p_color= [[NSArray alloc]initWithObjects:@"#7437F5",@"#F1A46E",@"#3696FF",@"#AAA3FF",@"#FF6DD2",nil];
    for (int i=0; i<self.task_entity.package_arr.count; i++) {
        UILabel *lbl_package_item=[[UILabel alloc] initWithFrame:CGRectMake(i*(9+54)+9, 42, 54, 22)];
        lbl_package_item.textColor=COLOR_WHITE;
        lbl_package_item.font=[UIFont boldSystemFontOfSize:12.0];
        lbl_package_item.text=[NSString stringWithFormat:@"%@(%@)",[[self.task_entity.package_arr objectAtIndex:i] objectForKey:@"category"],[[self.task_entity.package_arr objectAtIndex:i] objectForKey:@"number"]];
        if([[[self.task_entity.package_arr objectAtIndex:i] objectForKey:@"category"] containsString:@"普通"]){
            lbl_package_item.backgroundColor=[UIColor colorWithString:@"#E4484A"];
        }else if([[[self.task_entity.package_arr objectAtIndex:i] objectForKey:@"category"] containsString:@"整箱"]){
            lbl_package_item.backgroundColor=[UIColor colorWithString:@"#49B554"];
        }else if([[[self.task_entity.package_arr objectAtIndex:i] objectForKey:@"category"] containsString:@"冷冻"]){
            lbl_package_item.backgroundColor=[UIColor colorWithString:@"#4251FF"];
        }else if([[[self.task_entity.package_arr objectAtIndex:i] objectForKey:@"category"] containsString:@"冷藏"]){
            lbl_package_item.backgroundColor=[UIColor colorWithString:@"#04ABFF"];
        }else if([[[self.task_entity.package_arr objectAtIndex:i] objectForKey:@"category"] containsString:@"熟食"]){
            lbl_package_item.backgroundColor=[UIColor colorWithString:@"#ff6400"];
        }else{
            lbl_package_item.backgroundColor=[UIColor colorWithString:@"#E94132"];
        }
        
        lbl_package_item.textAlignment=NSTextAlignmentCenter;
        lbl_package_item.clipsToBounds=YES;
        [lbl_package_item.layer setCornerRadius:10.0f];
        [blockView_0 addSubview:lbl_package_item];
    }
    
    ////////////////blockView_5///////////////
    lbl_service_title=[[UILabel alloc] init];
    lbl_service_title.textColor=COLOR_BLACK;
    lbl_service_title.font=FONT_SIZE_MIDDLE;
    lbl_service_title.text=@"客服留言:";
    lbl_service_title.textAlignment=NSTextAlignmentLeft;
    [blockView_5 addSubview:lbl_service_title];
    
    [lbl_service_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_5.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(120, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_servicenote=[[UILabel alloc] initWithFrame:CGRectMake(10, 32, WIDTH_SCREEN-20, 20)];
    lbl_servicenote.textColor=COLOR_GRAY;
    lbl_servicenote.font=FONT_SIZE_MIDDLE;
    lbl_servicenote.numberOfLines=0;
    lbl_servicenote.text=@"暂无留言";
    lbl_servicenote.textAlignment=NSTextAlignmentLeft;
    [blockView_5 addSubview:lbl_servicenote];
    
    lbl_package_title=[[UILabel alloc] init];
    lbl_package_title.textColor=COLOR_BLACK;
    lbl_package_title.font=FONT_SIZE_MIDDLE;
    lbl_package_title.text=@"普通打包留言:";
    lbl_package_title.textAlignment=NSTextAlignmentLeft;
    [blockView_5 addSubview:lbl_package_title];
    
    [lbl_package_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_servicenote.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(120, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_packagenote=[[UILabel alloc] initWithFrame:CGRectMake(10, 92, WIDTH_SCREEN-20, 20)];
    lbl_packagenote.textColor=COLOR_GRAY;
    lbl_packagenote.font=FONT_SIZE_MIDDLE;
    lbl_packagenote.numberOfLines=0;
    lbl_packagenote.lineBreakMode = NSLineBreakByWordWrapping;
    lbl_packagenote.text=@"暂无留言";
    lbl_packagenote.textAlignment=NSTextAlignmentLeft;
    [blockView_5 addSubview:lbl_packagenote];
    
    lbl_freeze_package_title=[[UILabel alloc] init];
    lbl_freeze_package_title.textColor=COLOR_BLACK;
    lbl_freeze_package_title.font=FONT_SIZE_MIDDLE;
    lbl_freeze_package_title.text=@"冷冻打包留言:";
    lbl_freeze_package_title.textAlignment=NSTextAlignmentLeft;
    [blockView_5 addSubview:lbl_freeze_package_title];
    
    [lbl_freeze_package_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_packagenote.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(120, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_freeze_packagenote=[[UILabel alloc] initWithFrame:CGRectMake(10, 153, WIDTH_SCREEN-20, 20)];
    lbl_freeze_packagenote.textColor=COLOR_GRAY;
    lbl_freeze_packagenote.font=FONT_SIZE_MIDDLE;
    lbl_freeze_packagenote.numberOfLines=0;
    lbl_freeze_packagenote.text=@"暂无留言";
    lbl_freeze_packagenote.lineBreakMode = NSLineBreakByWordWrapping;
    lbl_freeze_packagenote.textAlignment=NSTextAlignmentLeft;
    [blockView_5 addSubview:lbl_freeze_packagenote];
    
    
    lbl_food_package_title=[[UILabel alloc] init];
    lbl_food_package_title.textColor=COLOR_BLACK;
    lbl_food_package_title.font=FONT_SIZE_MIDDLE;
    lbl_food_package_title.text=@"熟食打包留言:";
    lbl_food_package_title.textAlignment=NSTextAlignmentLeft;
    [blockView_5 addSubview:lbl_food_package_title];
    
    [lbl_food_package_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_freeze_packagenote.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(120, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_food_packagenote=[[UILabel alloc] initWithFrame:CGRectMake(10, 216, WIDTH_SCREEN-20, 20)];
    lbl_food_packagenote.textColor=COLOR_GRAY;
    lbl_food_packagenote.font=FONT_SIZE_MIDDLE;
    lbl_food_packagenote.numberOfLines=0;
    lbl_food_packagenote.text=@"暂无留言";
    lbl_food_packagenote.textAlignment=NSTextAlignmentLeft;
    [blockView_5 addSubview:lbl_food_packagenote];
    
    ////////////////blockView_1///////////////
    UILabel *lbl_tip_1=[[UILabel alloc] init];
    lbl_tip_1.textColor=COLOR_BLACK;
    lbl_tip_1.font=FONT_SIZE_MIDDLE;
    lbl_tip_1.text=@"付款方式";
    lbl_tip_1.textAlignment=NSTextAlignmentLeft;
    [blockView_1 addSubview:lbl_tip_1];
    
    [lbl_tip_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_1.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_payType=[[UILabel alloc] init];
    lbl_payType.textColor=COLOR_MAIN;
    lbl_payType.font=FONT_SIZE_MIDDLE;
    lbl_payType.text=@"";
    lbl_payType.textAlignment=NSTextAlignmentRight;
    [blockView_1 addSubview:lbl_payType];
    
    [lbl_payType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_1.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(150, 20));
        make.right.mas_equalTo(blockView_1.mas_right).offset(-10);
    }];
    
    UILabel *lbl_tip_2=[[UILabel alloc] init];
    lbl_tip_2.textColor=COLOR_BLACK;
    lbl_tip_2.font=FONT_SIZE_MIDDLE;
    lbl_tip_2.text=@"总金额";
    lbl_tip_2.textAlignment=NSTextAlignmentLeft;
    [blockView_1 addSubview:lbl_tip_2];
    
    [lbl_tip_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_1.top).offset(40);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_orderSum=[[UILabel alloc] init];
    lbl_orderSum.textColor=COLOR_MAIN;
    lbl_orderSum.font=FONT_SIZE_MIDDLE;
    lbl_orderSum.text=@"";
    lbl_orderSum.textAlignment=NSTextAlignmentRight;
    [blockView_1 addSubview:lbl_orderSum];
    
    [lbl_orderSum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_1.top).offset(40);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.right.mas_equalTo(blockView_1.mas_right).offset(-10);
    }];
    
    
    ////////////////blockView_2///////////////
    UILabel *lbl_tip_11=[[UILabel alloc] init];
    lbl_tip_11.textColor=COLOR_BLACK;
    lbl_tip_11.font=FONT_SIZE_MIDDLE;
    lbl_tip_11.text=@"返现金额";
    lbl_tip_11.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_tip_11];
    
    [lbl_tip_11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_returnPrice=[[UILabel alloc] init];
    lbl_returnPrice.textColor=COLOR_BLACK;
    lbl_returnPrice.font=FONT_SIZE_MIDDLE;
    lbl_returnPrice.text=@"";
    lbl_returnPrice.textAlignment=NSTextAlignmentRight;
    [blockView_2 addSubview:lbl_returnPrice];
    
    [lbl_returnPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.right.mas_equalTo(blockView_2.mas_right).offset(-10);
    }];
    
    UILabel *lbl_tip_22=[[UILabel alloc] init];
    lbl_tip_22.textColor=COLOR_BLACK;
    lbl_tip_22.font=FONT_SIZE_MIDDLE;
    lbl_tip_22.text=@"增减金额";
    lbl_tip_22.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_tip_22];
    
    [lbl_tip_22 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(40);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_changePrice=[[UILabel alloc] init];
    lbl_changePrice.textColor=COLOR_BLACK;
    lbl_changePrice.font=FONT_SIZE_MIDDLE;
    lbl_changePrice.text=@"";
    lbl_changePrice.textAlignment=NSTextAlignmentRight;
    [blockView_2 addSubview:lbl_changePrice];
    
    [lbl_changePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(40);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.right.mas_equalTo(blockView_2.mas_right).offset(-10);
    }];
    
    
    UILabel *lbl_tip_222=[[UILabel alloc] init];
    lbl_tip_222.textColor=COLOR_BLACK;
    lbl_tip_222.font=FONT_SIZE_MIDDLE;
    lbl_tip_222.text=@"配送费";
    lbl_tip_222.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_tip_222];
    
    [lbl_tip_222 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(70);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_shippingPrice=[[UILabel alloc] init];
    lbl_shippingPrice.textColor=COLOR_BLACK;
    lbl_shippingPrice.font=FONT_SIZE_MIDDLE;
    lbl_shippingPrice.text=@"";
    lbl_shippingPrice.textAlignment=NSTextAlignmentRight;
    [blockView_2 addSubview:lbl_shippingPrice];
    
    [lbl_shippingPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(70);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.right.mas_equalTo(blockView_2.mas_right).offset(-10);
    }];
    
    UILabel *lbl_tip_33=[[UILabel alloc] init];
    lbl_tip_33.textColor=COLOR_BLACK;
    lbl_tip_33.font=FONT_SIZE_MIDDLE;
    lbl_tip_33.text=@"订单实际金额";
    lbl_tip_33.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_tip_33];
    
    [lbl_tip_33 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(100);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_orderSum2=[[UILabel alloc] init];
    lbl_orderSum2.textColor=COLOR_MAIN;
    lbl_orderSum2.font=FONT_SIZE_MIDDLE;
    lbl_orderSum2.text=@"";
    lbl_orderSum2.textAlignment=NSTextAlignmentRight;
    [blockView_2 addSubview:lbl_orderSum2];
    
    [lbl_orderSum2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_1.top).offset(100);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.right.mas_equalTo(blockView_2.mas_right).offset(-10);
    }];
    ////////////////blockView_3///////////////
    
    UILabel *lbl_tip_3=[[UILabel alloc] init];
    lbl_tip_3.textColor=COLOR_BLACK;
    lbl_tip_3.font=FONT_SIZE_MIDDLE;
    lbl_tip_3.text=@"订单号:";
    lbl_tip_3.textAlignment=NSTextAlignmentLeft;
    [blockView_3 addSubview:lbl_tip_3];
    
    [lbl_tip_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_3.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_orderNo=[[UILabel alloc] init];
    lbl_orderNo.textColor=COLOR_DARKGRAY;
    lbl_orderNo.font=FONT_SIZE_SMALL;
    lbl_orderNo.text=@"";
    lbl_orderNo.textAlignment=NSTextAlignmentLeft;
    [blockView_3 addSubview:lbl_orderNo];
    
    [lbl_orderNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_3.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-70, 20));
        make.left.mas_equalTo(95);
    }];
    
    UILabel *lbl_tip_4=[[UILabel alloc] init];
    lbl_tip_4.textColor=COLOR_BLACK;
    lbl_tip_4.font=FONT_SIZE_MIDDLE;
    lbl_tip_4.text=@"收货人:";
    lbl_tip_4.textAlignment=NSTextAlignmentLeft;
    [blockView_3 addSubview:lbl_tip_4];
    
    [lbl_tip_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_3.top).offset(38);
        make.size.mas_equalTo(CGSizeMake(60, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_contact=[[UILabel alloc] init];
    lbl_contact.textColor=COLOR_DARKGRAY;
    lbl_contact.font=FONT_SIZE_SMALL;
    lbl_contact.text=@"";
    lbl_contact.textAlignment=NSTextAlignmentLeft;
    [blockView_3 addSubview:lbl_contact];
    
    [lbl_contact mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_3.top).offset(38);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-70, 20));
        make.left.mas_equalTo(95);
    }];
    
    UILabel *lbl_tip_5=[[UILabel alloc] init];
    lbl_tip_5.textColor=COLOR_BLACK;
    lbl_tip_5.font=FONT_SIZE_MIDDLE;
    lbl_tip_5.text=@"手机:";
    lbl_tip_5.textAlignment=NSTextAlignmentLeft;
    [blockView_3 addSubview:lbl_tip_5];
    
    [lbl_tip_5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_3.top).offset(66);
        make.size.mas_equalTo(CGSizeMake(45, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_mobile=[[UILabel alloc] init];
    lbl_mobile.textColor=RGBCOLOR(15, 34, 177);
    lbl_mobile.font=FONT_SIZE_SMALL;
    lbl_mobile.text=@"";
    lbl_mobile.textAlignment=NSTextAlignmentLeft;
    lbl_mobile.userInteractionEnabled=YES;
    [blockView_3 addSubview:lbl_mobile];
    [lbl_mobile addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeCall:)]];
    
    [lbl_mobile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_3.top).offset(66);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-65, 20));
        make.left.mas_equalTo(95);
    }];
    
    UILabel *lbl_tip_6=[[UILabel alloc] init];
    lbl_tip_6.textColor=COLOR_BLACK;
    lbl_tip_6.font=FONT_SIZE_MIDDLE;
    lbl_tip_6.text=@"地址:";
    lbl_tip_6.textAlignment=NSTextAlignmentLeft;
    [blockView_3 addSubview:lbl_tip_6];
    
    [lbl_tip_6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_3.top).offset(94);
        make.size.mas_equalTo(CGSizeMake(45, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_address=[[UILabel alloc] init];
    lbl_address.textColor=COLOR_DARKGRAY;
    lbl_address.font=FONT_SIZE_SMALL;
    lbl_address.text=@"1/22 Oakleigh Road, Carnegie, Melbourne, Australia";
    lbl_address.textAlignment=NSTextAlignmentLeft;
    [blockView_3 addSubview:lbl_address];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
        lbl_address.userInteractionEnabled=YES;
        lbl_address.textColor=RGBCOLOR(15, 34, 177);
        [lbl_address addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(runNavigationByGoogle)]];
    }

    [lbl_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_3.top).offset(94);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-65, 20));
        make.left.mas_equalTo(95);
    }];
    
    UILabel *lbl_tip_7=[[UILabel alloc] init];
    lbl_tip_7.textColor=COLOR_BLACK;
    lbl_tip_7.font=FONT_SIZE_MIDDLE;
    lbl_tip_7.text=@"配送时间:";
    lbl_tip_7.textAlignment=NSTextAlignmentLeft;
    [blockView_3 addSubview:lbl_tip_7];
    
    [lbl_tip_7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_3.top).offset(122);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_deliverytime=[[UILabel alloc] init];
    lbl_deliverytime.textColor=COLOR_DARKGRAY;
    lbl_deliverytime.font=FONT_SIZE_SMALL;
    lbl_deliverytime.text=@"--";
    lbl_deliverytime.textAlignment=NSTextAlignmentLeft;
    [blockView_3 addSubview:lbl_deliverytime];
    
    [lbl_deliverytime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_3.top).offset(122);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-80, 20));
        make.left.mas_equalTo(95);
    }];
    
    UILabel *lbl_tip_111=[[UILabel alloc] init];
    lbl_tip_111.textColor=COLOR_BLACK;
    lbl_tip_111.font=FONT_SIZE_MIDDLE;
    lbl_tip_111.text=@"签收方式:";
    lbl_tip_111.textAlignment=NSTextAlignmentLeft;
    [blockView_3 addSubview:lbl_tip_111];
    
    [lbl_tip_111 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_3.top).offset(150);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_putType=[[UILabel alloc] init];
    lbl_putType.textColor=COLOR_MAIN;
    lbl_putType.font=FONT_SIZE_SMALL;
    lbl_putType.text=@"当面签收";
    lbl_putType.textAlignment=NSTextAlignmentLeft;
    [blockView_3 addSubview:lbl_putType];
    
    [lbl_putType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_3.top).offset(150);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-80, 20));
        make.left.mas_equalTo(95);
    }];
    
    UILabel *lbl_tip_back=[[UILabel alloc] init];
    lbl_tip_back.textColor=COLOR_BLACK;
    lbl_tip_back.font=FONT_SIZE_MIDDLE;
    lbl_tip_back.text=@"失败处理:";
    lbl_tip_back.textAlignment=NSTextAlignmentLeft;
    [blockView_3 addSubview:lbl_tip_back];
    
    [lbl_tip_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_3.top).offset(178);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_deliveryBack=[[UILabel alloc] init];
    lbl_deliveryBack.textColor=COLOR_BLACK;
    lbl_deliveryBack.font=FONT_SIZE_SMALL;
    lbl_deliveryBack.text=@"默认";
    lbl_deliveryBack.textAlignment=NSTextAlignmentLeft;
    [blockView_3 addSubview:lbl_deliveryBack];
    
    [lbl_deliveryBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_3.top).offset(178);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-100, 20));
        make.left.mas_equalTo(95);
    }];
    
    
    UILabel *lbl_tip_8=[[UILabel alloc] init];
    lbl_tip_8.textColor=COLOR_BLACK;
    lbl_tip_8.font=FONT_SIZE_MIDDLE;
    lbl_tip_8.text=@"地址补充:";
    lbl_tip_8.textAlignment=NSTextAlignmentLeft;
    [blockView_3 addSubview:lbl_tip_8];
    
    [lbl_tip_8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_3.top).offset(206);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_address_replenish=[[UILabel alloc] init];
    lbl_address_replenish.textColor=COLOR_DARKGRAY;
    lbl_address_replenish.font=FONT_SIZE_SMALL;
    lbl_address_replenish.text=@"";
    lbl_address_replenish.textAlignment=NSTextAlignmentLeft;
    [blockView_3 addSubview:lbl_address_replenish];
    
    [lbl_address_replenish mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_3.top).offset(206);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-80, 20));
        make.left.mas_equalTo(95);
    }];

    ////////////////blockView_4///////////////
    UILabel *lbl_tip_9=[[UILabel alloc] init];
    lbl_tip_9.textColor=COLOR_BLACK;
    lbl_tip_9.font=FONT_SIZE_MIDDLE;
    lbl_tip_9.text=@"送货方式:";
    lbl_tip_9.textAlignment=NSTextAlignmentLeft;
    [blockView_4 addSubview:lbl_tip_9];
    
    [lbl_tip_9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_3.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 28));
        make.left.mas_equalTo(10);
    }];
    
    lbl_upstairs=[[UILabel alloc] init];
    lbl_upstairs.textColor=COLOR_DARKGRAY;
    lbl_upstairs.font=FONT_SIZE_SMALL;
    lbl_upstairs.text=@"默认";
    lbl_upstairs.textAlignment=NSTextAlignmentRight;
    [blockView_4 addSubview:lbl_upstairs];
    
    [lbl_upstairs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_4.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(120, 28));
        make.right.mas_equalTo(blockView_4.mas_right).offset(-10);
    }];
    
    
}


-(void)setUpTableView{
    float table_height=HEIGHT_SCREEN-HEIGHT_STATUS_AND_NAVIGATION_BAR-DONE_ACTION_BAR;
    //if(self.task_entity==nil||[self.task_entity.status intValue]==1||[self.task_entity.status intValue]==2){
    if(self.order_id!=nil&&[self.order_id length]>0){
        table_height=HEIGHT_SCREEN-HEIGHT_STATUS_AND_NAVIGATION_BAR;
    }
    
    if([self.task_entity respondsToSelector:@selector(status)]&&([self.task_entity.status intValue]==1||[self.task_entity.status intValue]==2)){
        table_height=HEIGHT_SCREEN-HEIGHT_STATUS_AND_NAVIGATION_BAR;
    }
    self.tableView=[[SPBaseTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN,table_height) style:UITableViewStylePlain];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor=COLOR_BG_TABLESEPARATE;
    self.tableView.backgroundColor=COLOR_BG_TABLEVIEW;
    
    UIView *view = [UIView new];
    view.backgroundColor = COLOR_CLEAR;
    
    [self.tableView setTableHeaderView:orderInfoView];
    
    [self.tableView setTableFooterView:view];
    [self.view addSubview:self.tableView];
}

/**
 创建完成操作条
 */
-(void)createDoneActionBar{
    @weakify(self);

    
    if([self.task_entity.status intValue]!=1&&[self.task_entity.status intValue]!=2){
        UIView *top_line=[[UIView alloc] init];
        top_line.backgroundColor=COLOR_LIGHTGRAY;
        [self.view addSubview:top_line];
        
        [top_line mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self.view.mas_bottom).offset(-DONE_ACTION_BAR);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(WIDTH_SCREEN);
            make.height.mas_equalTo(0.5);
        }];
        
        _btn_returnAction=[UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_returnAction setTitle:@"订单返现" forState:UIControlStateNormal];
        _btn_returnAction.titleLabel.textAlignment=NSTextAlignmentCenter;
        [_btn_returnAction setBackgroundColor:COLOR_WHITE];
        [_btn_returnAction setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
        _btn_returnAction.titleLabel.font=FONT_SIZE_BIG;
        [_btn_returnAction addTarget:self action:@selector(confirmReturnPrice) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btn_returnAction];



        [_btn_returnAction mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self.view.mas_bottom).offset(DONE_ACTION_BAR*-1+0.5);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(WIDTH_SCREEN/2);
            make.height.mas_equalTo(DONE_ACTION_BAR);
        }];

        _btn_doneAction=[UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_doneAction setTitle:@"完成配送" forState:UIControlStateNormal];
        _btn_doneAction.titleLabel.textAlignment=NSTextAlignmentCenter;
        if([self.task_entity.is_ready intValue]==1){
            [_btn_doneAction setBackgroundColor:COLOR_MAIN];
            [_btn_doneAction setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
        }
        else{
            [_btn_doneAction setBackgroundColor:COLOR_LIGHTGRAY];
            [_btn_doneAction setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
        }

        _btn_doneAction.titleLabel.font=FONT_SIZE_BIG;
        [_btn_doneAction addTarget:self action:@selector(deliveryFinish) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btn_doneAction];

        [_btn_doneAction mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self.view.mas_bottom).offset(DONE_ACTION_BAR*-1+0.5);
            make.left.mas_equalTo(WIDTH_SCREEN/2);
            make.width.mas_equalTo(WIDTH_SCREEN/2);
            make.height.mas_equalTo(DONE_ACTION_BAR);
        }];
    }
}

-(void)loadOrderFlowData:(OrderFlowEntity *)data{
    if(data){
        //订单状态
        if([data.order_status intValue]==0){//待确认
            lbl_state.text=@"待确认";
        }
        else if([data.order_status intValue]==1){//已确认
            lbl_state.text=@"已确认";
            
            if([data.shipping_status intValue]==5||[data.shipping_status intValue]==6||[data.shipping_status intValue]==7||[data.shipping_status intValue]==8){//打包中
                lbl_state.text=@"打包中";
            }
            else if([data.shipping_status intValue]==3){//已出库
                lbl_state.text=@"已出库";
            }
            else if([data.shipping_status intValue]==1){//配送中
                lbl_state.text=@"配送中";
            }
            else if([data.shipping_status intValue]==2){//已完成
                lbl_state.text=@"已完成";
            }
        }
        else if([data.order_status intValue]==2){//已取消
            lbl_state.text=@"已取消";
        }
        if(data.picker&&![data.picker isEqualToString:@"null"]){
            lbl_picker.text=data.picker;
            if(data.box.length>0){
                lbl_box.text=data.box;
            }
            lbl_pick_time.text=[NSString stringWithFormat:@"%@ ~ %@",data.pick_begin_time,data.pick_end_time];
        }

        if(data.packer&&![data.packer isEqualToString:@"null"]){
            lbl_packer.text=data.packer;
            lbl_pack_time.text=[NSString stringWithFormat:@"%@ ~ %@",data.pack_begin_time,data.pack_end_time];
        }
    }
}

//请求订单下在仓库的流程信息
-(void)loadOrderFlowInfo{
     if(self.order_id!=nil&&self.order_id.length>0){
        [self.model loadOrderFlowInfo:self.order_id];
    }
}

//请求订单下的商品信息
-(void)loadGoodsForOrder{
    [self startLoadingActivityIndicator];
    if(self.order_id==nil||self.order_id.length<=0){
        [self.model loadGoodsListForOrder:self.task_entity.order_id];
    }
    else{
        [self.model loadGoodsListForOrder:self.order_id];
    }
}

-(void)setDeliveryDone:(NSString *)status andPayType:(int)pay_type{
    [self startLoadingActivityIndicator];
    
    if(lbl_orderNo.text.length>0){
        [self.model order_delivery_done:self.task_entity.delivery_id andStatus:status andPayType:pay_type andImgPath:@"" andOrderSn:lbl_orderNo.text andMsg:@"" andBank:@"0"];
    }
    else{
        [self showToastTopWithText:@"没有配送订单信息"];
    }
}

-(void)onResponse:(SPBaseModel *)model isSuccess:(BOOL)isSuccess{
    [self stopLoadingActivityIndicator];
    
    if(model==self.model&&self.model.requestTag==3002){
        if(isSuccess){
            [self.tableView reloadData];
            if(self.order_id!=nil&&self.order_id.length>0){
                [self loadOrderFlowInfo];
            }
            else{
                [self stopLoadingActivityIndicator];
            }
        }
    }
    else if(model==self.model&&self.model.requestTag==3008){
        if(isSuccess){
            [self showSuccesWithText:@"操作成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:TASK_RELOAD_NOTIFICATION object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if(model==self.model&&self.model.requestTag==3006){
        if(isSuccess){
            [self loadOrderFlowData:self.model.flow_entity];
        }
    }
}

-(void)loadDeliveryInfo{
    if(self.task_entity){
        int n=0;
        for (int i=0; i<self.task_entity.package_arr.count; i++) {
            n+=[[[self.task_entity.package_arr objectAtIndex:i] objectForKey:@"number"] intValue];
        }
        lbl_packageNum.text=[NSString stringWithFormat:@"%d",n];
        lbl_payType.text=self.task_entity.pay_name;
        lbl_orderSum.text=[NSString stringWithFormat:@"$%@",self.task_entity.order_amount];
        lbl_orderNo.text=self.task_entity.order_sn;
        lbl_contact.text=self.task_entity.consignee;
        lbl_mobile.text=[self.task_entity.mobile length]>10 ? [self.task_entity.mobile substringToIndex:self.task_entity.mobile.length-1] : self.task_entity.mobile;
        lbl_address.text=self.task_entity.address;
        lbl_deliverytime.text=self.task_entity.delivery_time;
        lbl_changePrice.text=[NSString stringWithFormat:@"$%@",self.task_entity.change_price];
        lbl_shippingPrice.text=[NSString stringWithFormat:@"$%@",self.task_entity.shipping_fee];
        lbl_returnPrice.text=[NSString stringWithFormat:@"$%@",self.task_entity.return_price];
        lbl_orderSum2.text=[NSString stringWithFormat:@"$%.2f",([self.task_entity.order_amount floatValue]-[self.task_entity.return_price floatValue]+[self.task_entity.change_price floatValue])];
        if([self.task_entity.put_type intValue]==1){
            lbl_putType.text=@"放门口";
        }
        else{
            lbl_putType.text=@"当面签收";
        }
        lbl_deliveryBack.text=self.task_entity.delivery_back;
        
        lbl_address_replenish.text=self.task_entity.address_replenish;
        lbl_upstairs.text=self.task_entity.option_title;
        
        [self loadNoteInfo];
        
    }
}

-(void)loadNoteInfo{
    
    if(self.task_entity.service_note.length>0){
        lbl_servicenote.textColor=[Common hexColor:@"#E4484A"];
        lbl_servicenote.text=[NSString stringWithFormat:@"%@",self.task_entity.service_note];
    }
    lbl_servicenote.frame=CGRectMake(10, (35), WIDTH_SCREEN-20, 20);
    [lbl_servicenote sizeToFit];

    if(self.task_entity.package_note.length>0){
        lbl_packagenote.textColor=[Common hexColor:@"#E4484A"];
        lbl_packagenote.text=[NSString stringWithFormat:@"%@",self.task_entity.package_note];
    }
    lbl_packagenote.frame=CGRectMake(10, (lbl_servicenote.frame.origin.y+lbl_servicenote.frame.size.height+25+5), WIDTH_SCREEN-20, 20);
    [lbl_packagenote sizeToFit];

    if(self.task_entity.package_freeze_note.length>0){
        lbl_freeze_packagenote.textColor=[Common hexColor:@"#E4484A"];
        lbl_freeze_packagenote.text=[NSString stringWithFormat:@"%@",self.task_entity.package_freeze_note];
    }
    lbl_freeze_packagenote.frame=CGRectMake(10, (lbl_packagenote.frame.origin.y+lbl_packagenote.frame.size.height+25+5), WIDTH_SCREEN-20, 20);
    [lbl_freeze_packagenote sizeToFit];
    
    if(self.task_entity.package_food_note.length>0){
        lbl_food_packagenote.textColor=[Common hexColor:@"#E4484A"];
        lbl_food_packagenote.text=[NSString stringWithFormat:@"%@",self.task_entity.package_food_note];
    }
    lbl_food_packagenote.frame=CGRectMake(10, (lbl_freeze_packagenote.frame.origin.y+lbl_freeze_packagenote.frame.size.height+25+5), WIDTH_SCREEN-20, 20);
    [lbl_food_packagenote sizeToFit];
    
    if(self.order_id!=nil&&[self.order_id length]>0){
        blockView_21.frame= CGRectMake(0, 12, WIDTH_SCREEN,(lbl_food_packagenote.frame.origin.y+lbl_food_packagenote.frame.size.height+12));
        blockView_22.frame= CGRectMake(0, (blockView_21.frame.origin.y+blockView_21.size.height+12), WIDTH_SCREEN, 200);
        blockView_23.frame= CGRectMake(0, (blockView_22.frame.origin.y+blockView_22.size.height+12), WIDTH_SCREEN, (self.task_entity.delivery_info.count*25+35)+12);
        orderInfoView.frame=CGRectMake(0, 0, WIDTH_SCREEN, blockView_23.frame.origin.y+blockView_23.frame.size.height);
    }else{
        blockView_5.frame= CGRectMake(0, 99, WIDTH_SCREEN,(lbl_food_packagenote.frame.origin.y+lbl_food_packagenote.frame.size.height+12));
        blockView_1.frame= CGRectMake(0, (blockView_5.frame.origin.y+blockView_5.size.height+12), WIDTH_SCREEN, 75);
        blockView_2.frame= CGRectMake(0, (blockView_1.frame.origin.y+blockView_1.size.height+12), WIDTH_SCREEN, 130);
        blockView_3.frame= CGRectMake(0, (blockView_2.frame.origin.y+blockView_2.size.height+12), WIDTH_SCREEN, 235);
        blockView_4.frame= CGRectMake(0, (blockView_3.frame.origin.y+blockView_3.size.height+12), WIDTH_SCREEN, 45);
        orderInfoView.frame=CGRectMake(0, 0, WIDTH_SCREEN, blockView_4.frame.origin.y+blockView_4.frame.size.height);
    }
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return [self.model.goods_entity.goods_list_normal count];
    }
    else if(section==1){
        return [self.model.goods_entity.goods_list_alone count];
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0&&[self.model.goods_entity.goods_list_normal count]>0){
        return 38;
    }
    else if(section==1&&[self.model.goods_entity.goods_list_alone count]>0){
        return 38;
    }
    return 0;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *packageCategory=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 150, 20)];
    packageCategory.font=FONT_SIZE_MIDDLE;
    packageCategory.textColor=COLOR_BLACK;
    if(section==0){
        packageCategory.text=@"  通用打包商品";
    }
    else if(section==1){
        packageCategory.text=@"  单独打包商品";
    }
    return packageCategory;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=@"MemberCellIdentifier";
    OrderDetailCell *cell = [tv dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.showsReorderControl = NO;
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.backgroundColor=COLOR_BG_TABLEVIEWCELL;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font=FONT_SIZE_MIDDLE;
        cell.textLabel.textColor=COLOR_DARKGRAY;
    }
    if(indexPath.section==0){
        cell.itemName=[self.model.goods_entity.goods_list_normal objectAtIndex:indexPath.row].goods_name;
        cell.itemNum=[self.model.goods_entity.goods_list_normal objectAtIndex:indexPath.row].goods_number;
        cell.itemImage=[self.model.goods_entity.goods_list_normal objectAtIndex:indexPath.row].thumb_url;
        if([[self.model.goods_entity.goods_list_normal objectAtIndex:indexPath.row] isPromote]){
            cell.itemPrice=[[self.model.goods_entity.goods_list_normal objectAtIndex:indexPath.row].promote_price floatValue];
            cell.isPromote=YES;
        }else{
            cell.itemPrice=[[self.model.goods_entity.goods_list_normal objectAtIndex:indexPath.row].shop_price floatValue];
            cell.isPromote=NO;
        }
        
        if([[self.model.goods_entity.goods_list_normal objectAtIndex:indexPath.row].is_fixed_point intValue]==1){
            cell.isPromote=YES;
        }
        
    }
    else if(indexPath.section==1){
        cell.itemName=[self.model.goods_entity.goods_list_alone objectAtIndex:indexPath.row].goods_name;
        cell.itemNum=[self.model.goods_entity.goods_list_alone objectAtIndex:indexPath.row].goods_number;
        cell.itemImage=[self.model.goods_entity.goods_list_alone objectAtIndex:indexPath.row].thumb_url;

        if([[self.model.goods_entity.goods_list_alone objectAtIndex:indexPath.row] isPromote]){
            cell.itemPrice=[[self.model.goods_entity.goods_list_alone objectAtIndex:indexPath.row].promote_price floatValue];
            cell.isPromote=YES;
        }else{
            cell.itemPrice=[[self.model.goods_entity.goods_list_alone objectAtIndex:indexPath.row].shop_price floatValue];
            cell.isPromote=NO;
        }
        
        if([[self.model.goods_entity.goods_list_alone objectAtIndex:indexPath.row].is_fixed_point intValue]==1){
            cell.isPromote=YES;
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tv deselectRowAtIndexPath:[tv indexPathForSelectedRow] animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UITableView *tableview = (UITableView *)scrollView;
    CGFloat sectionHeaderHeight = 40;
    CGFloat sectionFooterHeight = 0;
    
    
    CGFloat offsetY = tableview.contentOffset.y;
    
    if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
    {
        tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
    }else if (offsetY >= sectionHeaderHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight)
    {
        tableview.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
    }else if (offsetY >= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height)
    {
        if(offsetY>0){
            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight), 0);
        }
    }
}


-(void)confirmReturnPrice{
    if(self.order_id==nil||self.order_id.length<=0){
        [self showReturnMenu];
    }
    else{
        [self showToastWithText:@"缺少订单数据"];
    }
}

- (void)showReturnMenu
{
    UIActionSheet *actionsheet;
    if([self.task_entity.return_price_pre intValue]>=5){
        actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择返现金额" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"返现5澳币", @"返现2澳币", nil,nil];
        actionsheet.tag=3888;
    }
    else if([self.task_entity.return_price_pre intValue]>=2&&[self.task_entity.return_price_pre intValue]<5){
        actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择返现金额" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"返现2澳币", nil,nil];
        actionsheet.tag=3889;
    }
    else if([self.task_entity.return_price_pre intValue]<=0){
        actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择返现金额" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"无返现", nil,nil];
        actionsheet.tag=3890;
    }
    
    
    [actionsheet showInView:self.view];
}

-(void)deliveryFinish{
    if([self.task_entity.is_ready intValue]==1){
        [self showFinishMenu];
//        if([self.task_entity.pay_type intValue]==4){//如果是货到付款，则须先选择结算方式
//            [self showFinishMenu];
//        }
//        else{//如果是线上支付，直接调用配送完成接口
//            [[AlertBlockView sharedInstance] showChoiceAlert:@"确认完成订单配送吗？" button1Title:@"确定" button2Title:@"取消" completion:^(int index) {
//                if(index==0){
//                    [self setDeliveryDone:@"1" andPayType:@"0"];//0代表线上支付 1现金 2转账
//                }
//            }];
//        }
    }
    else{
        [self showToastWithText:@"订单尚未发货"];
    }
    
}

-(void)showAdjustPriceMenu{
    UIActionSheet *actionsheet;
    actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"减少金额", @"增加金额", nil,nil];
    actionsheet.tag=4000;
    [actionsheet showInView:self.view];
}

- (void)showFinishMenu
{
    UIActionSheet *actionsheet;
    if([self.task_entity.pay_type intValue]==4){//如果是货到付款，则须先选择结算方式
        actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"现金结算", @"银行转账结算", @"支付宝转账结算", @"微信转账结算",@"无法配送", nil,nil];
    }
    else{
        actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"配送完成",@"无法配送", nil,nil];
    }
    actionsheet.tag=3999;
    [actionsheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag==3999){
        if([self.task_entity.pay_type intValue]==4){//如果是货到付款
            if (0 == buttonIndex)//现金结算
            {
                [[AlertBlockView sharedInstance] showChoiceAlert:@"确认完成订单配送吗？" button1Title:@"确定" button2Title:@"取消" completion:^(int index) {
                    if(index==0){
                        [self setDeliveryDone:@"1" andPayType:1];//0代表线上支付 1现金 2转账
                    }
                }];
            }
            else if (buttonIndex>0&&buttonIndex<4)//转账结算
            {
                int payType=0;
                if(buttonIndex==1){
                    payType=2;
                }
                else if(buttonIndex==2){
                    payType=4;
                }
                else if(buttonIndex==3){
                    payType=5;
                }
                if(lbl_orderNo.text.length>0){
                    if(payType!=2){
                        PaymentViewController *pvc=[[PaymentViewController alloc] init];
                        pvc.task_entity=self.task_entity;
                        pvc.order_sn=lbl_orderNo.text;
                        pvc.payment_type=payType;
                        [self.navigationController pushViewController:pvc animated:YES];
                    }
                    else{
                        BankListViewController *pvc=[[BankListViewController alloc] init];
                        pvc.task_entity=self.task_entity;
                        pvc.order_sn=lbl_orderNo.text;
                        pvc.payment_type=payType;
                        [self.navigationController pushViewController:pvc animated:YES];
                    }
                }
                else{
                    [self showToastTopWithText:@"没有配送订单信息"];
                }
                
            }
            else if (4 == buttonIndex)//无法配送
            {
                [self setDeliveryDone:@"2" andPayType:-1];//0代表线上支付 1现金 2转账 -1未配送结算
            }
        }
        else{//显示支付
            if (0 == buttonIndex)//完成配送
            {
                [[AlertBlockView sharedInstance] showChoiceAlert:@"确认完成订单配送吗？" button1Title:@"确定" button2Title:@"取消" completion:^(int index) {
                    if(index==0){
                        [self setDeliveryDone:@"1" andPayType:0];//0代表线上支付 1现金 2转账
                    }
                }];
            }
            else if (1 == buttonIndex)//无法配送
            {
                [self setDeliveryDone:@"2" andPayType:-1];//0代表线上支付 1现金 2转账 -1未配送结算
                
            }
        }
    }
    else if(actionSheet.tag==3888){
        ReturnProofViewController *rvc=[[ReturnProofViewController alloc] init];
        rvc.task_entity=self.task_entity;
        isGotoReturnProofView=YES;
        
        if (0 == buttonIndex){//5
            rvc.returnPrice=5;
            [self.navigationController pushViewController:rvc animated:YES];
        }
        else if (1 == buttonIndex){//2
            rvc.returnPrice=2;
            [self.navigationController pushViewController:rvc animated:YES];
        }
        
    }
    else if(actionSheet.tag==3889){
        ReturnProofViewController *rvc=[[ReturnProofViewController alloc] init];
        rvc.task_entity=self.task_entity;
        isGotoReturnProofView=YES;
        
        if (0 == buttonIndex){//2
            rvc.returnPrice=2;
            [self.navigationController pushViewController:rvc animated:YES];
        }
        
    }
    else if(actionSheet.tag==3890){
        ReturnProofViewController *rvc=[[ReturnProofViewController alloc] init];
        rvc.task_entity=self.task_entity;
        isGotoReturnProofView=YES;
        
        if (0 == buttonIndex){//5
            rvc.returnPrice=5;
            [self.navigationController pushViewController:rvc animated:YES];
        }
    }
    else if(actionSheet.tag==4000){
        if (0 == buttonIndex){//减少金额
            [self gotoOrderPriceChangeView:1];
        }
        else if (1 == buttonIndex){//增加金额
            [self gotoOrderPriceChangeView:2];
        }
    }
}


-(void)runNavigationByGoogle{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%@,%@&directionsmode=driving",APP_NAME,APP_SCHEME,self.task_entity.latitude, self.task_entity.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else{
        [self showToastBottomWithText:@"您未安装Google Maps"];
    }
}

-(void)gotoOrderPriceChangeView:(int)model{
    OrderPriceChangeViewController *cvc=[[OrderPriceChangeViewController alloc] init];
    cvc.task_entity=self.task_entity;
    cvc.changeType=model;
    isGotoOrderChangeView=YES;
    [self.navigationController pushViewController:cvc animated:YES];
}

-(void)makeCall:(UIGestureRecognizer *)sender{
    UILabel *lbl_sender=(UILabel *)sender.view;
    NSMutableString *str;
    if(lbl_sender){
        NSString *mobile=[self.task_entity.mobile length]>10 ? [self.task_entity.mobile substringToIndex:self.task_entity.mobile.length-1] : lbl_sender.text;
        if([self.task_entity.mobile length]>10){
            mobile=[Common decryptPhoneNumber:[self.task_entity.mobile substringToIndex:self.task_entity.mobile.length-1] withOffset:[[self.task_entity.mobile substringFromIndex:self.task_entity.mobile.length-1] intValue]];
            str=[[NSMutableString alloc] initWithFormat:@"tel:%@",mobile];
        }else{
            str=[[NSMutableString alloc] initWithFormat:@"tel:%@",lbl_sender.text];
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

-(TaskModel *)model{
    if(!_model){
        _model=[[TaskModel alloc] init];
        _model.delegate=self;
    }
    return _model;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(isGotoOrderChangeView){
        [self loadDeliveryInfo];
        isGotoOrderChangeView=false;
    }
    
    if(isGotoReturnProofView){
        [self loadDeliveryInfo];
        isGotoReturnProofView=false;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
