//
//  MemberCell.m
//  XiaoYa
//
//  Created by XuWei on 15/1/3.
//  Copyright (c) 2015年 xuwei. All rights reserved.
//

#import "PickOrderCell.h"

@implementation PickOrderCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        @weakify(self);
        
        if (_iconImageView==nil) {
            _iconImageView=[[UIImageView alloc] init];
            _iconImageView.image=[UIImage imageNamed:@"defaut_list"];
            [self.contentView addSubview:_iconImageView];
            
            @strongify(self);
            [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.mas_centerY);
                make.left.mas_equalTo(12);
                make.size.mas_equalTo(CGSizeMake(30, 30));
            }];
        }

        if (lbl_package_number==nil) {
            lbl_package_number=[[UILabel alloc] init];
            lbl_package_number.textAlignment=NSTextAlignmentRight;
            lbl_package_number.textColor=COLOR_DARKGRAY;
            lbl_package_number.font=FONT_SIZE_MIDDLE;
            lbl_package_number.text=@"x0";
            [self.contentView addSubview:lbl_package_number];
            
            @strongify(self);
            [lbl_package_number mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.mas_centerY);
                make.right.mas_equalTo(self.mas_right).offset(-10);
                make.size.mas_equalTo(CGSizeMake(60, 22));
            }];
            
        }
        
        if (lbl_package_title==nil) {
            lbl_package_title=[[UILabel alloc] init];
            lbl_package_title.textAlignment=NSTextAlignmentLeft;
            lbl_package_title.textColor=COLOR_DARKGRAY;
            lbl_package_title.font=FONT_SIZE_SMALL;
            lbl_package_title.text=@"";
            [self.contentView addSubview:lbl_package_title];
            
            [lbl_package_title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.mas_centerY);
                make.left.mas_equalTo(_iconImageView.mas_right).offset(10);
                make.size.mas_equalTo(CGSizeMake(150, 22));
            }];
        }

        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
//    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:self.entity.goods_thumb] placeholderImage:[UIImage imageNamed:@"defaut_list"]];
    if(self.entity.package_arr&&self.entity.package_arr.count>0){
        NSDictionary *dic=[self.entity.package_arr objectAtIndex:self.row_index];
        lbl_package_number.text=[NSString stringWithFormat:@"x%@",[dic objectForKey:@"number"]];
        if([[dic objectForKey:@"category"] isEqualToString:@"普通包裹"]){
            lbl_package_title.text=[NSString stringWithFormat:@"%@(%@%@)",[dic objectForKey:@"category"],self.entity.default_code,self.entity.default_number];
        }
        else if([[dic objectForKey:@"category"] isEqualToString:@"冷冻包裹"]){
            lbl_package_title.text=[NSString stringWithFormat:@"%@(Y%@)",[dic objectForKey:@"category"],self.entity.freeze_number];
        }
        else if([[dic objectForKey:@"category"] isEqualToString:@"冷藏包裹"]){
            lbl_package_title.text=[NSString stringWithFormat:@"%@(X%@)",[dic objectForKey:@"category"],self.entity.refrigerate_number];
        }
        else{
            lbl_package_title.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"category"]];
        }
        
        _iconImageView.image=[UIImage imageNamed:[[self.entity.package_arr objectAtIndex:self.row_index] objectForKey:@"icon"]];
    }
    
    if(self.list_type==0){
        if([[[self.entity.package_arr objectAtIndex:self.row_index] objectForKey:@"picked"] intValue]==1){
            self.backgroundColor=[Common hexColor:@"#FFF489"];
        }
        else{
            self.backgroundColor=COLOR_WHITE;
        }
    }
    else{
        self.backgroundColor=COLOR_WHITE;
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
