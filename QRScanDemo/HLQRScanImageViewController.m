//
//  QRScanImageViewController.m
//  QRScanDemo
//
//  Created by Lucky on 2018/10/24.
//  Copyright © 2018年 Lucky. All rights reserved.
//

#import "HLQRScanImageViewController.h"

@interface HLQRScanImageViewController ()

@end

@implementation HLQRScanImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"个人二维码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 150, 150)];
    imageView.image = self.image;
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 280, self.view.frame.size.width - 20, 50)];
    label.text = self.urlStr;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor redColor];
    label.numberOfLines = 0;
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
