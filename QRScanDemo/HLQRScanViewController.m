//
//  QRScanViewController.m
//  QRScanDemo
//
//  Created by Lucky on 2018/10/24.
//  Copyright © 2018年 Lucky. All rights reserved.
//

#import "HLQRScanViewController.h"
#import "HLQRScanView.h"
#import "HLQRScanManagerTool.h"
#import "HLQRScanImageViewController.h"
#import "HLQRScanConfig.h"

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define StatusBarAndNavigationBarHeight (iPhoneX ? 88.f : 64.f)

@interface HLQRScanViewController ()

@property (nonatomic, strong) HLQRScanManagerTool * scanTool;
@property (nonatomic, strong) HLQRScanView * scanView;
@property (nonatomic, strong) UIView *outputView;

@end

@implementation HLQRScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"扫一扫";
    
    self.view.backgroundColor = [UIColor blackColor];
    //设置导航栏透明
    [self.navigationController.navigationBar setTranslucent:true];
    //把背景设为空
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //处理导航栏有条线的问题
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    UIButton * photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, StatusBarAndNavigationBarHeight/2, 64, StatusBarAndNavigationBarHeight/2)];
    [photoBtn setTitle:@"相册" forState:UIControlStateNormal];
    [photoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(photoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:photoBtn];
    
    [HLQRScanConfig QR_checkCameraAuthorizationStatusWithGrand:^(BOOL granted) {
        if (granted) {
            [self setupScanUI];
        } else {
            NSLog(@"没有开启相机权限");
        }
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_scanView startScanAnimation];
    [_scanTool sessionStartRunning];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_scanView stopScanAnimation];
    [_scanView finishedHandle];
    [_scanView showFlashSwitch:NO];
    [_scanTool sessionStopRunning];
}

- (void)setupScanUI {
    //输出流视图
    _outputView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0)];
    [self.view addSubview:self.outputView];
    
    __weak typeof(self) weakSelf = self;
    // 构建扫描样式视图
    _scanView = [[HLQRScanView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0)];
    _scanView.scanRetangleRect = CGRectMake(60, 120, (self.view.frame.size.width - 2 * 60),  (self.view.frame.size.width - 2 * 60));
    _scanView.colorAngle = [UIColor greenColor];
    _scanView.isNeedShowRetangle = YES;
    _scanView.colorRetangleLine = [UIColor whiteColor];
    _scanView.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _scanView.animationImage = [UIImage imageNamed:@"scanLine"];
    
    _scanView.myQRCodeBlock = ^{
        
    };
    
    // 开启关闭闪光灯
    _scanView.flashSwitchBlock = ^(BOOL open) {
        [weakSelf.scanTool openFlashSwitch:open];
    };
    
    [self.view addSubview:_scanView];
    
    [_scanView startScanAnimation];
    
    [self setupSacnTool];
}

- (void)setupSacnTool {
    __weak typeof(self) weakSelf = self;
    // 初始化扫描工具
    _scanTool = [[HLQRScanManagerTool alloc] initWithQRScanPreview:_outputView andScanView:_scanView];
    [_scanTool scanFinishedResultSuccessBlock:^(NSString * _Nullable scanString) {
        NSLog(@"扫描结果 %@",scanString);
        [weakSelf.scanView handlingResultsOfScan];
        
        [weakSelf.scanTool sessionStopRunning];
        [weakSelf.scanTool openFlashSwitch:NO];
        UIImage *image = [weakSelf.scanTool qrImageWithString:scanString avatar:[UIImage imageNamed:@"scanImg"]];
        HLQRScanImageViewController *scanImageCtr = [[HLQRScanImageViewController alloc] init];
        scanImageCtr.image = image;
        scanImageCtr.urlStr = scanString;
        [weakSelf.navigationController pushViewController:scanImageCtr animated:YES];
        [weakSelf.scanView finishedHandle];
        
    } failureBlock:^{
        NSLog(@"扫描失败");
    }];
    
    //  环境光感
    _scanTool.monitorLightBlock = ^(float brightness) {
//        NSLog(@"环境光感 ： %f",brightness);
        if (brightness < 0) {
            // 环境太暗，显示闪光灯开关按钮
            [weakSelf.scanView showFlashSwitch:YES];
        }else if(brightness > 0){
            // 环境亮度可以,且闪光灯处于关闭状态时，隐藏闪光灯开关
            if(!weakSelf.scanTool.flashOpen){
                [weakSelf.scanView showFlashSwitch:NO];
            }
        }
    };
    [_scanTool sessionStartRunning];
}

#pragma mark -- Events Handle
- (void)photoBtnClicked{
    [_scanTool imagePickerWithJumpController:self];
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
