//
//  PayCodeViewController.m
//  auMarket
//
//  Created by 吴绪伟 on 2019/2/13.
//  Copyright © 2019 daao. All rights reserved.
//

#import "PayCodeViewController.h"

@interface PayCodeViewController ()

@end

@implementation PayCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI{
    self.title=@"扫描支付";
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIImageView *codeView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, WIDTH_SCREEN*1.415)];
    codeView.image=[UIImage imageNamed:@"pay_code.jpg"];
    [self.view addSubview:codeView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
