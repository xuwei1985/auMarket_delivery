//
//  PickOrderCell.m
//  auMarket
//
//  Created by 吴绪伟 on 2018/5/21.
//  Copyright © 2018 daao. All rights reserved.
//

#import "predictSmsTaskCell.h"

@implementation predictSmsTaskCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        @weakify(self);

        if (btn_select==nil) {
            btn_select=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn_select setImage:[UIImage imageNamed:@"option_off"] forState:UIControlStateNormal];
            [btn_select setImage:[UIImage imageNamed:@"option_on"] forState:UIControlStateSelected];
            [btn_select addTarget:self action:@selector(selData:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn_select];
            
            [btn_select mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(18);
                make.left.mas_equalTo(10);
                make.size.mas_equalTo(CGSizeMake(28, 28));
            }];
        }
        
        if(!lbl_predict_time){
            lbl_predict_time=[[UILabel alloc] init];
            lbl_predict_time.textColor=COLOR_WHITE;
            lbl_predict_time.font=FONT_SIZE_MIDDLE;
            lbl_predict_time.text=@"完成时间：";
            lbl_predict_time.clipsToBounds=YES;
            [lbl_predict_time.layer setCornerRadius:13];
            lbl_predict_time.backgroundColor=COLOR_MAIN;
            lbl_predict_time.textAlignment=NSTextAlignmentCenter;
            [self.contentView addSubview:lbl_predict_time];
            
            [lbl_predict_time mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(btn_select.mas_top).offset(0);
                make.left.mas_equalTo(btn_select.mas_right).offset(18);
                make.size.mas_equalTo(CGSizeMake(165, 28));
            }];
        }
        
//        if(!send_mark){
//            send_mark=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"send_off"]];
//            [self.contentView addSubview:send_mark];
//
//            @strongify(self);
//
//            [send_mark mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.mas_equalTo(btn_select.mas_top).offset(4);
//                make.left.mas_equalTo(self.mas_right).offset(-40);
//                make.size.mas_equalTo(CGSizeMake(28, 28));
//            }];
//        }
        
        if(!lbl_order_sn){
            lbl_order_sn=[[UILabel alloc] init];
            lbl_order_sn.textColor=COLOR_GRAY;
            lbl_order_sn.font=FONT_SIZE_MIDDLE;
            lbl_order_sn.text=@"订单号：";
            [self.contentView addSubview:lbl_order_sn];
            
            [lbl_order_sn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lbl_predict_time.mas_bottom).offset(15);
                make.left.mas_equalTo(btn_select.mas_right).offset(20);
                make.size.mas_equalTo(CGSizeMake(64, 20));
            }];
        }
        
        if(!lbl_order_sn_value){
            lbl_order_sn_value=[[UILabel alloc] init];
            lbl_order_sn_value.textColor=COLOR_DARKGRAY;
            lbl_order_sn_value.font=FONT_SIZE_MIDDLE;
            lbl_order_sn_value.text=@"--";
            [self.contentView addSubview:lbl_order_sn_value];
            
            [lbl_order_sn_value mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lbl_order_sn.mas_top);
                make.left.mas_equalTo(lbl_order_sn.mas_right);
                make.size.mas_equalTo(CGSizeMake(120, 20));
            }];
        }
        
        if(!lbl_order_region){
            lbl_order_region=[[UILabel alloc] init];
            lbl_order_region.textColor=COLOR_GRAY;
            lbl_order_region.font=FONT_SIZE_MIDDLE;
            lbl_order_region.text=@"区域：";
            [self.contentView addSubview:lbl_order_region];

            [lbl_order_region mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lbl_order_sn.mas_bottom).offset(6);
                make.left.mas_equalTo(btn_select.mas_right).offset(20);
                make.size.mas_equalTo(CGSizeMake(64, 20));
            }];
        }

        if(!lbl_order_region_value){
            lbl_order_region_value=[[UILabel alloc] init];
            lbl_order_region_value.textColor=COLOR_DARKGRAY;
            lbl_order_region_value.font=FONT_SIZE_MIDDLE;
            lbl_order_region_value.text=@"--";
            [self.contentView addSubview:lbl_order_region_value];

            [lbl_order_region_value mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lbl_order_sn_value.mas_bottom).offset(6);
                make.left.mas_equalTo(lbl_order_region.mas_right);
                make.size.mas_equalTo(CGSizeMake(120, 20));
            }];
        }
        
        if(!lbl_order_contact){
            lbl_order_contact=[[UILabel alloc] init];
            lbl_order_contact.textColor=COLOR_GRAY;
            lbl_order_contact.font=FONT_SIZE_MIDDLE;
            lbl_order_contact.text=@"收货人：";
            [self.contentView addSubview:lbl_order_contact];
            
            [lbl_order_contact mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lbl_order_region.mas_bottom).offset(6);
                make.left.mas_equalTo(btn_select.mas_right).offset(20);
                make.size.mas_equalTo(CGSizeMake(64, 20));
            }];
        }
        
        if(!lbl_order_contact_value){
            lbl_order_contact_value=[[UILabel alloc] init];
            lbl_order_contact_value.textColor=COLOR_DARKGRAY;
            lbl_order_contact_value.font=FONT_SIZE_MIDDLE;
            lbl_order_contact_value.text=@"--";
            [self.contentView addSubview:lbl_order_contact_value];
            
            [lbl_order_contact_value mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lbl_order_region_value.mas_bottom).offset(6);
                make.left.mas_equalTo(lbl_order_contact.mas_right);
                make.size.mas_equalTo(CGSizeMake(120, 20));
            }];
        }
        
        if(!lbl_order_tel){
            lbl_order_tel=[[UILabel alloc] init];
            lbl_order_tel.textColor=COLOR_GRAY;
            lbl_order_tel.font=FONT_SIZE_MIDDLE;
            lbl_order_tel.text=@"电话：";
            [self.contentView addSubview:lbl_order_tel];
            
            [lbl_order_tel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lbl_order_contact.mas_bottom).offset(6);
                make.left.mas_equalTo(btn_select.mas_right).offset(20);
                make.size.mas_equalTo(CGSizeMake(64, 20));
            }];
        }
        
        if(!lbl_order_tel_value){
            lbl_order_tel_value=[[UILabel alloc] init];
            lbl_order_tel_value.textColor=COLOR_DARKGRAY;
            lbl_order_tel_value.font=FONT_SIZE_MIDDLE;
            lbl_order_tel_value.text=@"--";
            [self.contentView addSubview:lbl_order_tel_value];
            
            [lbl_order_tel_value mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lbl_order_contact_value.mas_bottom).offset(6);
                make.left.mas_equalTo(lbl_order_tel.mas_right);
                make.size.mas_equalTo(CGSizeMake(150, 20));
            }];
        }
        
        
        if(!lbl_order_address){
            lbl_order_address=[[UILabel alloc] init];
            lbl_order_address.textColor=COLOR_GRAY;
            lbl_order_address.font=FONT_SIZE_MIDDLE;
            lbl_order_address.text=@"地址：";
            [self.contentView addSubview:lbl_order_address];
            
            [lbl_order_address mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lbl_order_tel.mas_bottom).offset(6);
                make.left.mas_equalTo(btn_select.mas_right).offset(20);
                make.size.mas_equalTo(CGSizeMake(64, 20));
            }];
        }
        
        if(!lbl_order_address_value){
            lbl_order_address_value=[[UILabel alloc] init];
            lbl_order_address_value.textColor=COLOR_DARKGRAY;
            lbl_order_address_value.font=FONT_SIZE_MIDDLE;
            lbl_order_address_value.text=@"--";
            lbl_order_address_value.numberOfLines=0;
            lbl_order_address_value.clipsToBounds=YES;
            lbl_order_address_value.lineBreakMode=NSLineBreakByWordWrapping;
            [self.contentView addSubview:lbl_order_address_value];
            
            [lbl_order_address_value mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lbl_order_tel_value.mas_bottom).offset(6);
                make.left.mas_equalTo(lbl_order_address.mas_right);
                make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-145, 20));
            }];
        }

    }
    return self;
}


-(void)selData:(UIButton *)sender{
    sender.selected=!sender.selected;
    self.entity.selected=sender.selected;
    if(self.entity.selected){
        self.selDataBlock(self.entity.order_id,1);//选中
    }
    else{
        self.selDataBlock(self.entity.order_id,0);//取消
    }
   
}

-(void)selDataId:(SelDataBlock)block
{
    self.selDataBlock = block;
}

-(void)toggleDataSel{
    self.entity.selected=!self.entity.selected;
    if(self.entity.selected){
        self.selDataBlock(self.entity.order_id,1);//选中
    }
    else{
        self.selDataBlock(self.entity.order_id,0);//取消
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if(self.list_model==0){
        [btn_select mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(28, 28));
        }];
    }
    else{
        [btn_select mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
    }
    
    btn_select.selected=self.entity.selected;
    lbl_order_contact_value.text=self.entity.consignee;
    lbl_predict_time.text=[NSString stringWithFormat:@"预设配送顺序:%@",self.entity.predict_add_time];
    lbl_order_sn_value.text=self.entity.order_sn;
    lbl_order_tel_value.text=self.entity.mobile;
    lbl_order_address_value.text=self.entity.address;
    lbl_order_region_value.text=self.entity.block_name;
    float h=[Common HeightOfLabel:self.entity.address ForFont:FONT_SIZE_MIDDLE withWidth:(WIDTH_SCREEN-150)];
    [lbl_order_address_value mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_order_tel_value.mas_bottom).offset(6);
        make.left.mas_equalTo(lbl_order_address.mas_right);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-150, h+5));
    }];
    
//    if([self.entity.predict_sms_send intValue]>0){
//        send_mark.image=[UIImage imageNamed:@"send_on"];
//    }
//    else{
//        send_mark.image=[UIImage imageNamed:@"send_off"];
//    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
