//
//  PredictTimeSectionView.h
//  auMarket
//
//  Created by 吴绪伟 on 2023/8/7.
//  Copyright © 2023 daao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PredictTimeSectionViewDelegate

@optional
-(void)timeSectionClick:(UITextField *)sender;
-(void)requestNumClick:(UITextField *)sender;
-(void)confirmClick;
@end

@interface PredictTimeSectionView : UIView<UITextFieldDelegate>
{
    UITextField *timeSectionTxt;
    UITextField *requestNumTxt;
    UILabel *requestNumLbl;
    UIButton *confirmBtm;
    
    UIImageView *timeSectionArrow;
    UIImageView *requestNumArrow;
}

// set the delegate
@property (nonatomic, retain) NSObject<PredictTimeSectionViewDelegate>* delegate;
@property (nonatomic, assign) int request_num;

@end

NS_ASSUME_NONNULL_END
