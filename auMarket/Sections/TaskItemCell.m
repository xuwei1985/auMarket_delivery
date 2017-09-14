//
//  GoodsCategoryParentCell.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/13.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "TaskItemCell.h"

@implementation TaskItemCell
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

    _iconView=[[UIImageView alloc] init];
    _iconView.image=[UIImage imageNamed:@"1_45"];
    [self addSubview:_iconView];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(18);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    _taskTitleLbl=[[UILabel alloc] init];
    _taskTitleLbl.text=@"";
    _taskTitleLbl.font=DEFAULT_FONT(14.0);
    _taskTitleLbl.numberOfLines=0;
    _taskTitleLbl.lineBreakMode=NSLineBreakByWordWrapping;
    _taskTitleLbl.textColor=COLOR_FONT_BLACK;
    _taskTitleLbl.textAlignment=NSTextAlignmentLeft;
    [self addSubview:_taskTitleLbl];
    
    [_taskTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.mas_top).offset(13);
        make.left.mas_equalTo(_iconView.mas_right).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-40);
    }];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    _taskTitleLbl.text=self.entity.address;
    [_taskTitleLbl sizeToFit];
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
