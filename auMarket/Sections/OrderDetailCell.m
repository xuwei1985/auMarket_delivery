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
            _itemLbl.lineBreakMode=NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
            _itemLbl.clipsToBounds=YES;
            [self.contentView addSubview:_itemLbl];
            
            [_itemLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.top.mas_equalTo(self.mas_top).offset(8);
                make.left.mas_equalTo(_iconImageView.mas_right).offset(10);
                make.right.mas_equalTo(self.mas_right).offset(-10);
                make.height.mas_equalTo(42);
            }];
        }
        
        if (_priceLbl==nil) {
            _priceLbl=[[UILabel alloc] init];
            _priceLbl.textAlignment=NSTextAlignmentLeft;
            _priceLbl.textColor= RGBCOLOR(33, 33, 33);
            _priceLbl.font=FONT_SIZE_MIDDLE;
            _priceLbl.text=@"$0.00";
            [self.contentView addSubview:_priceLbl];
            
            [_priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(50);
                make.left.mas_equalTo(_iconImageView.mas_right).offset(10);
                make.size.mas_equalTo(CGSizeMake(50, 20));
            }];
        }
        
        if (_numLbl==nil) {
            _numLbl=[[UILabel alloc] init];
            _numLbl.textAlignment=NSTextAlignmentLeft;
            _numLbl.textColor=COLOR_MAIN;
            _numLbl.font=FONT_SIZE_SMALL;
            [self.contentView addSubview:_numLbl];
            
            [_numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(50);
                make.left.mas_equalTo(_priceLbl.mas_right).offset(5);
                make.size.mas_equalTo(CGSizeMake(40, 20));
            }];
        }
        
        if (_promoteMarkLbl==nil) {
            _promoteMarkLbl=[[UILabel alloc] init];
            _promoteMarkLbl.text=@"特价";
            _promoteMarkLbl.font=DEFAULT_FONT(11);
            _promoteMarkLbl.textColor=COLOR_WHITE;
            _promoteMarkLbl.hidden=NO;
            _promoteMarkLbl.backgroundColor=RGBCOLOR(233, 76, 75);
            _promoteMarkLbl.textAlignment=NSTextAlignmentCenter;
            _promoteMarkLbl.clipsToBounds=YES;
            [_promoteMarkLbl.layer setCornerRadius:2];
            [self addSubview:_promoteMarkLbl];
            
            [_promoteMarkLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(46);
                make.right.mas_equalTo(self.mas_right).offset(-10);
                make.size.mas_equalTo(CGSizeMake(36, 20));
            }];
        }
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:self.itemImage] placeholderImage:[UIImage imageNamed:@"defaut_list"]];
    _itemLbl.text=self.itemName;
    _priceLbl.text=[NSString stringWithFormat:@"$%.2f",self.itemPrice*[self.itemNum intValue]];
    _numLbl.text=[NSString stringWithFormat:@"%@件",self.itemNum];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
