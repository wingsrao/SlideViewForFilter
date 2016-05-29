//
//  ViewController.m
//  SlideViewForFilter
//
//  Created by 饶首建 on 16/5/27.
//  Copyright © 2016年 wings. All rights reserved.
//

#import "ViewController.h"
#import "FilterSlideDataViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (nonatomic, strong) FilterSlideDataViewController* slidebarVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)filterAction:(id)sender {
    //侧滑FilterSlideViewController
    _slidebarVC = [[FilterSlideDataViewController alloc] init];
    _slidebarVC.view.frame  = [UIScreen mainScreen].bounds;
    [self.view addSubview:_slidebarVC.view];
    [_slidebarVC showHideSidebar];
    
    __weak typeof(self) weakSelf = self;
    _slidebarVC.backBlock = ^(id backData){
        if ([NSString stringWithFormat:@"%@",backData].length) {
            weakSelf.label.text = backData;
        }
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
