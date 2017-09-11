//
//  GoodsCategoryParentCell.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/13.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "GoodsListItemCell.h"

@implementation GoodsListItemCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.backgroundColor=COLOR_BG_TABLEVIEWCELL;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    @weakify(self);

    _goodsImageView=[[UIImageView alloc] init];
    [self addSubview:_goodsImageView];
    
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(self.mas_height);
    }];
    
    _goodsTitleLbl=[[UILabel alloc] init];
    _goodsTitleLbl.text=@"";
    _goodsTitleLbl.font=DEFAULT_FONT(14.0);
    _goodsTitleLbl.numberOfLines=0;
    _goodsTitleLbl.lineBreakMode=NSLineBreakByWordWrapping;
    _goodsTitleLbl.textColor=COLOR_FONT_GOODS_TITLE;
    _goodsTitleLbl.textAlignment=NSTextAlignmentLeft;
    [self addSubview:_goodsTitleLbl];
    
    [_goodsTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.mas_top).offset(12);
        make.left.mas_equalTo(_goodsImageView.mas_right).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-10);
    }];
    
    _goodsPriceLbl=[[UILabel alloc] init];
    _goodsPriceLbl.text=@"$0.0";
    _goodsPriceLbl.font=DEFAULT_BOLD_FONT(14.0);
    _goodsPriceLbl.textColor=COLOR_FONT_GOODS_PRICE;
    _goodsPriceLbl.textAlignment=NSTextAlignmentLeft;
    [self addSubview:_goodsPriceLbl];
    
    [_goodsPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-8);
        make.left.mas_equalTo(_goodsImageView.mas_right).offset(15);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];

    
    _cartView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    _cartView.image=[UIImage imageNamed:@"addCart"];
    [self addSubview:_cartView];
    
    [_cartView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
    }];
}

-(void)loadData{
    _goodsTitleLbl.text=self.entity.goods_name;
    _goodsPriceLbl.text=[NSString stringWithFormat:@"$%@",self.entity.market_price];;
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:self.entity.goods_thumb] placeholderImage:nil];
}



-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self loadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
