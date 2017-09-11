//
//  GoodsCategoryParentCell.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/13.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "GoodsCartItemCell.h"

@implementation GoodsCartItemCell
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
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.left.mas_equalTo(_goodsImageView.mas_right).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-50);
    }];
    
    _goodsPriceLbl=[[UILabel alloc] init];
    _goodsPriceLbl.text=@"$0.0";
    _goodsPriceLbl.font=DEFAULT_BOLD_FONT(14.0);
    _goodsPriceLbl.textColor=COLOR_DARKGRAY;
    _goodsPriceLbl.textAlignment=NSTextAlignmentLeft;
    [self addSubview:_goodsPriceLbl];
    
    [_goodsPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-8);
        make.left.mas_equalTo(_goodsImageView.mas_right).offset(15);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];

    _numText=[[UITextField alloc] init];
    [_numText.layer setBorderWidth:1.0]; //外框类型
    [_numText.layer setBorderColor:COLOR_GRAY.CGColor];
    _numText.text = @"0"; //默认显示的字
    _numText.secureTextEntry = NO; //是否以密码形式显示
    _numText.returnKeyType = UIReturnKeyDone;
    _numText.clearButtonMode = UITextFieldViewModeNever; //编辑时会出现个修改X
    _numText.delegate = self;
    _numText.keyboardType = UIKeyboardTypeNumberPad;
    _numText.textAlignment=NSTextAlignmentCenter;
    _numText.font=FONT_SIZE_MIDDLE;
    _numText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; //设置居中输入
    [self addSubview:_numText];
    
    [_numText mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [_numText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)loadData{
    _goodsTitleLbl.text=self.entity.goods_name;
    _goodsPriceLbl.text=[NSString stringWithFormat:@"$%.2f",[self.entity.market_price floatValue]*[self.entity.buy_number intValue]];
    _numText.text=[NSString stringWithFormat:@"%d",[self.entity.buy_number intValue]];
    
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:self.entity.goods_thumb] placeholderImage:nil];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _numText) {
        if (textField.text.length > 2) {
            textField.text = [textField.text substringToIndex:2];
        }
        
        self.entity.buy_number=[_numText.text intValue]>0?_numText.text:@"1";
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField==_numText){
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        keyboardDoneButtonView.barStyle = UIBarStyleDefault;
        keyboardDoneButtonView.translucent = YES;
        keyboardDoneButtonView.tintColor = RGBCOLOR(165, 165, 165);
        [keyboardDoneButtonView sizeToFit];
        
        UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                                      target: nil
                                                                                      action: nil];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                       style:UIBarButtonItemStyleBordered target:self
                                                                      action:@selector(cartNumChanged:)];
        doneButton.tintColor=RGBCOLOR(99, 99, 99);
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:fixedButton,doneButton, nil]];
        textField.inputAccessoryView = keyboardDoneButtonView;
    }

}

// may be called if forced even if
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _numText) {
        if (textField.text.length <=0) {
            textField.text = @"1";
        }
    }
}

//计算单个商品的总价，和购物车的总价
-(void)cartNumChanged:(id)sender{
    self.entity.buy_number=[_numText.text intValue]>0?_numText.text:@"1";
    
    [self sumGoodsPrice];
    [self sumCartPrice];
    [_numText resignFirstResponder];
}

-(void)sumGoodsPrice{
    NSLog(@"sumGoodsPrice");
}

-(void)sumCartPrice{
    NSLog(@"sumCartPrice");
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
