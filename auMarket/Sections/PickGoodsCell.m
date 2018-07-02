//
//  MemberCell.m
//  XiaoYa
//
//  Created by XuWei on 15/1/3.
//  Copyright (c) 2015年 xuwei. All rights reserved.
//

#import "PickGoodsCell.h"

@implementation PickGoodsCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        @weakify(self);
        
        if (_iconImageView==nil) {
            _iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 84, 84)];
            _iconImageView.image=[UIImage imageNamed:@"defaut_list"];
            [self.contentView addSubview:_iconImageView];
        }
        
        UILabel *lbl_title=[[UILabel alloc] init];
        
        
        if (lbl_shelf_code==nil) {
            lbl_title=[[UILabel alloc] init];
            lbl_title.textAlignment=NSTextAlignmentLeft;
            lbl_title.textColor=COLOR_DARKGRAY;
            lbl_title.font=FONT_SIZE_SMALL;
            lbl_title.text=@"货架位置:";
            [self.contentView addSubview:lbl_title];
            
            [lbl_title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(12);
                make.left.mas_equalTo(_iconImageView.mas_right).offset(10);
                make.size.mas_equalTo(CGSizeMake(68, 22));
            }];
            
            lbl_shelf_code=[[UILabel alloc] init];
            lbl_shelf_code.textAlignment=NSTextAlignmentLeft;
            lbl_shelf_code.textColor=COLOR_BLACK;
            lbl_shelf_code.font=FONT_SIZE_SMALL;
            [self.contentView addSubview:lbl_shelf_code];
            
            [lbl_shelf_code mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.top.mas_equalTo(12);
                make.left.mas_equalTo(lbl_title.mas_right);
                make.right.mas_equalTo(self.mas_right).offset(-10);
                make.height.mas_equalTo(22);
            }];
        }
        
        if (lbl_box_mark==nil) {
            lbl_box_mark=[[UILabel alloc] init];
            lbl_box_mark.textAlignment=NSTextAlignmentCenter;
            lbl_box_mark.backgroundColor=COLOR_RED;
            lbl_box_mark.font=DEFAULT_FONT(11.0);
            lbl_box_mark.clipsToBounds=YES;
            lbl_box_mark.textColor=COLOR_WHITE;
            [lbl_box_mark.layer setCornerRadius:7];
            lbl_box_mark.layer.borderColor = COLOR_WHITE.CGColor;
            [lbl_box_mark.layer setBorderWidth:0.5];
            lbl_box_mark.text=@"";
            lbl_box_mark.layer.shouldRasterize = YES;
            [self.contentView addSubview:lbl_box_mark];
            
            [lbl_box_mark mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.top.mas_equalTo(14);
                make.right.mas_equalTo(self.mas_right).offset(-14);
                make.size.mas_equalTo(CGSizeMake(14, 14));
            }];
            
        }
        
        if (lbl_goods_number==nil) {
            lbl_title=[[UILabel alloc] init];
            lbl_title.textAlignment=NSTextAlignmentLeft;
            lbl_title.textColor=COLOR_DARKGRAY;
            lbl_title.font=FONT_SIZE_SMALL;
            lbl_title.text=@"拣货数量:";
            [self.contentView addSubview:lbl_title];
            
            [lbl_title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lbl_shelf_code.mas_bottom).offset(2);
                make.left.mas_equalTo(_iconImageView.mas_right).offset(10);
                make.size.mas_equalTo(CGSizeMake(68, 22));
            }];
            
            lbl_goods_number=[[UILabel alloc] init];
            lbl_goods_number.textAlignment=NSTextAlignmentLeft;
            lbl_goods_number.textColor=COLOR_DARKGRAY;
            lbl_goods_number.font=FONT_SIZE_SMALL;
            [self.contentView addSubview:lbl_goods_number];
            
            [lbl_goods_number mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lbl_shelf_code.mas_bottom).offset(2);
                make.left.mas_equalTo(lbl_title.mas_right);
                make.size.mas_equalTo(CGSizeMake(60, 22));
            }];
        }
        
        if (lbl_box_name==nil) {
            lbl_title=[[UILabel alloc] init];
            lbl_title.textAlignment=NSTextAlignmentLeft;
            lbl_title.textColor=COLOR_DARKGRAY;
            lbl_title.font=FONT_SIZE_SMALL;
            lbl_title.text=@"货箱标志:";
            [self.contentView addSubview:lbl_title];
            
            [lbl_title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lbl_goods_number.mas_bottom).offset(2);
                make.left.mas_equalTo(_iconImageView.mas_right).offset(10);
                make.size.mas_equalTo(CGSizeMake(68, 22));
            }];
            
            lbl_box_name=[[UILabel alloc] init];
            lbl_box_name.textAlignment=NSTextAlignmentLeft;
            lbl_box_name.textColor=COLOR_BLACK;
            lbl_box_name.font=FONT_SIZE_SMALL;
            [self.contentView addSubview:lbl_box_name];
            
            [lbl_box_name mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lbl_goods_number.mas_bottom).offset(2);
                make.left.mas_equalTo(lbl_title.mas_right);
                make.size.mas_equalTo(CGSizeMake(80, 22));
            }];
        }

        if (lbl_goods_name==nil) {
            lbl_goods_name=[[UILabel alloc] init];
            lbl_goods_name.textAlignment=NSTextAlignmentLeft;
            lbl_goods_name.textColor=COLOR_BLACK;
            lbl_goods_name.font=FONT_SIZE_SMALL;
            lbl_goods_name.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
            lbl_goods_name.numberOfLines = 2;
            [self.contentView addSubview:lbl_goods_name];
            
            [lbl_goods_name mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.top.mas_equalTo(lbl_box_name.mas_bottom).offset(2);
                make.left.mas_equalTo(_iconImageView.mas_right).offset(10);
                make.right.mas_equalTo(self.mas_right).offset(-12);
                make.height.mas_equalTo(38);
            }];
        }
        
        if (lbl_care_mark==nil) {
            lbl_care_mark=[[UILabel alloc] init];
            lbl_care_mark.textAlignment=NSTextAlignmentCenter;
            lbl_care_mark.textColor=COLOR_WHITE;
            lbl_care_mark.backgroundColor=RGBCOLOR(244, 66, 72);
            lbl_care_mark.text=@"易错";
            lbl_care_mark.font=DEFAULT_FONT(11);
            lbl_care_mark.clipsToBounds=YES;
            lbl_care_mark.layer.borderColor=RGBCOLOR(244, 66, 72).CGColor;
            lbl_care_mark.layer.cornerRadius=3;
            lbl_care_mark.hidden=YES;
            [self.contentView addSubview:lbl_care_mark];
            
            [lbl_care_mark mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.centerY.mas_equalTo(self.mas_centerY).offset(-3);
                make.right.mas_equalTo(self.mas_right).offset(-12);
                make.height.mas_equalTo(18);
                make.width.mas_equalTo(34);
            }];
        }
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:self.entity.goods_thumb] placeholderImage:[UIImage imageNamed:@"defaut_list"]];
    lbl_goods_name.text=self.entity.goods_name;
    
    @weakify(self);
    [lbl_goods_name mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(lbl_box_name.mas_bottom).offset(2);
        make.left.mas_equalTo(_iconImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.height.mas_equalTo(38);
    }];
    lbl_goods_number.text=[NSString stringWithFormat:@"%@",self.entity.goods_number];
    if([self.entity.goods_number intValue]>1){
        lbl_goods_number.textColor=COLOR_MAIN;
    }
    else{
        lbl_goods_number.textColor=COLOR_DARKGRAY;
    }
    lbl_shelf_code.text=self.entity.shelves_code;
    
    NSRange range = [self.entity.box rangeOfString:@"-"];
    if(range.location != NSNotFound){
        lbl_box_name.text=[NSString stringWithFormat:@"%@",[self.entity.box substringToIndex:range.location]];
        lbl_box_mark.backgroundColor=[Common hexColor:[self.entity.box substringFromIndex:range.location+1]];
    }
    else{
        lbl_box_name.text=@"invalid";
        lbl_box_mark.backgroundColor=[UIColor clearColor];
    }
    
    if([self.entity.need_care intValue]==1){
        lbl_care_mark.hidden=NO;
    }
    else{
        lbl_care_mark.hidden=YES;
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
