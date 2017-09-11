//
//  CustomTextField.h
//  SouXue
//
//  Created by XuWei on 14-3-31.
//
//

#import <UIKit/UIKit.h>

@interface CustomTextField : UITextField
@property(nonatomic, strong) UIColor *placeholderColor;
@property(nonatomic, assign) float holdeOffsetY;

- (id)initWithFrame:(CGRect)frame andPlaceHolderOffsetY:(float)y;
@end
