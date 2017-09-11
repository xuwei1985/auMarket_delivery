//
//  GoodsCategoryParentCell.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/13.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "GoodsCategoryChildCell.h"

@implementation GoodsCategoryChildCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    @weakify(self);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _markView=[[UIImageView alloc] init];
    _markView.image=[UIImage imageNamed:@"c1"];
    [self addSubview:_markView];
    [_markView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.left).offset(6);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    
    _categoryTitleLbl=[[UILabel alloc] init];
    _categoryTitleLbl.text=@"三级分类";
    _categoryTitleLbl.font=FONT_SIZE_MIDDLE;
    _categoryTitleLbl.textColor=COLOR_FONT_GOODS_CATEGORY;
    _categoryTitleLbl.textAlignment=NSTextAlignmentLeft;
    [self addSubview:_categoryTitleLbl];
    
    [_categoryTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(35);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(self.mas_right).offset(-10);
    }];
}

-(void)loadData{
    _categoryTitleLbl.text=self.categoryName;
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
