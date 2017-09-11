//
//  GoodsCategoryParentCell.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/13.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "GoodsCategoryParentCell.h"

@implementation GoodsCategoryParentCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.backgroundColor=COLOR_BG_GOODS_CATEGORY_CELL;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    stateView=[[UIView alloc] init];
    stateView.backgroundColor=COLOR_MAIN;
    stateView.hidden=YES;
    [self addSubview:stateView];
    
    @weakify(self);
    [stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(self.mas_left).offset(4);
    }];
    
    
    categoryImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    [self addSubview:categoryImageView];
    
    [categoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).offset(-10);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    categoryTitleLbl=[[UILabel alloc] init];
    categoryTitleLbl.text=@"一级分类";
    categoryTitleLbl.font=DEFAULT_FONT(15.0);
    categoryTitleLbl.textColor=COLOR_FONT_GOODS_CATEGORY;
    categoryTitleLbl.textAlignment=NSTextAlignmentCenter;
    [self addSubview:categoryTitleLbl];
    
    [categoryTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(categoryImageView.mas_bottom).offset(8);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
    }];
}

-(void)loadData{
    categoryTitleLbl.text=self.categoryName;
    [categoryImageView sd_setImageWithURL:[NSURL URLWithString:self.categoryImgUrl]];
}

-(void)setCellSel{
    categoryTitleLbl.textColor=COLOR_FONT_GOODS_CATEGORY_SEL;
    self.backgroundColor=COLOR_BG_GOODS_CATEGORY_CELL_SEL;
    stateView.hidden=NO;
    [categoryImageView sd_setImageWithURL:[NSURL URLWithString:self.categorySelImgUrl]];
}

-(void)setCellUnSel{
    categoryTitleLbl.textColor=COLOR_FONT_GOODS_CATEGORY;
    self.backgroundColor=COLOR_BG_GOODS_CATEGORY_CELL;
    stateView.hidden=YES;
    [categoryImageView sd_setImageWithURL:[NSURL URLWithString:self.categoryImgUrl]];
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
