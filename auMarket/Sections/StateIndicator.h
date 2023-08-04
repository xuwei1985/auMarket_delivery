//
//  StateIndicator.h
//  auMarket
//
//  Created by 吴绪伟 on 2023/8/4.
//  Copyright © 2023 daao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StateIndicatorDelegate <NSObject>

@optional
-(void)toogleState:(NSInteger) state;
@end

NS_ASSUME_NONNULL_BEGIN

@interface StateIndicator : UIView
{
    UIButton *btn_gps;
    UIButton *btn_predict;
    UIButton *btn_pick;
}

@property(nonatomic,assign) NSObject<StateIndicatorDelegate> *delegate;
@property(nonatomic,assign) NSInteger state_gps;
@property(nonatomic,assign) NSInteger state_pick;
@property(nonatomic,assign) NSInteger state_predict;
@end

NS_ASSUME_NONNULL_END
