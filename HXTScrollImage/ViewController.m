//
//  ViewController.m
//  HXTScrollImage
//
//  Created by mac on 16/5/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import "HXTScrollImageView.h"

@interface ViewController () <HXTScrollImageViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *imageNameArr = @[@"ad_00",@"ad_01",@"ad_02",@"ad_03",@"ad_04",@"ad_00",@"ad_05",@"ad_06",@"ad_07",@"ad_08",@"ad_09"];
    HXTScrollImageView *scrollImageView = [HXTScrollImageView viewWithImgNameArr:imageNameArr frame:CGRectMake(0, 0, 375, 200)];
    scrollImageView.delegate = self;
    [self.view addSubview:scrollImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)HXTScrollImageView:(HXTScrollImageView *)scrollImageView didTapImageIndex:(NSInteger)index
{
    NSLog(@"点击了第%ld张图片", index);
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
