//
//  MemberCell.m
//  XiaoYa
//
//  Created by XuWei on 15/1/3.
//  Copyright (c) 2015年 xuwei. All rights reserved.
//

#import "OrderDetailCell.h"

@implementation OrderDetailCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        @weakify(self);
        
        if (_iconImageView==nil) {
            _iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 54, 54)];
            _iconImageView.image=[UIImage imageNamed:@"defaut_list"];
            [self.contentView addSubview:_iconImageView];
        }
        if (_itemLbl==nil) {
            _itemLbl=[[UILabel alloc] init];
            _itemLbl.textAlignment=NSTextAlignmentLeft;
            _itemLbl.textColor=COLOR_BLACK;
            if(WIDTH_SCREEN<=320){
                _itemLbl.font=DEFAULT_FONT(13.0);
            }
            else{
                _itemLbl.font=DEFAULT_FONT(14.0);
            }
            _itemLbl.numberOfLines=0;
            _itemLbl.lineBreakMode=NSLineBreakByWordWrapping;
            [self.contentView addSubview:_itemLbl];
            
            [_itemLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.top.mas_equalTo(self.mas_top).offset(8);
                make.left.mas_equalTo(_iconImageView.mas_right).offset(10);
                make.right.mas_equalTo(self.mas_right).offset(-10);
            }];
        }
        
        if (_numLbl==nil) {
            _numLbl=[[UILabel alloc] init];
            _numLbl.textAlignment=NSTextAlignmentLeft;
            _numLbl.textColor=COLOR_MAIN;
            _numLbl.font=FONT_SIZE_SMALL;
            [self.contentView addSubview:_numLbl];
            
            [_numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(45);
                make.left.mas_equalTo(_iconImageView.mas_right).offset(10);
            }];
        }
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.kouzibuy.com/images/201702/thumb_img/34_thumb_G_1488235308203.jpg"] placeholderImage:[UIImage imageNamed:@"defaut_list"]];
    _itemLbl.text=@"山药五谷粥420g 营养香浓咸口味 即食冲饮";
    _numLbl.text=@"3件";
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
