//
//  FilterSlideViewController.m
//  Vasse
//
//  Created by 饶首建 on 16/5/19.
//  Copyright © 2016年 voossi. All rights reserved.
//

#import "FilterSlideDataViewController.h"
#import "InfoTableViewCell.h"
#import "DetailInfoTableViewCell.h"

@interface FilterSlideDataViewController ()<UITableViewDelegate, UITableViewDataSource>{
    CGRect _frame;
    UIButton *_sureBtn;
    UIButton *_resetBtn;
    UIButton *_backBtn;
    UIImageView *_backImgView;
    
    NSArray *_provinceArray;
    NSArray *_cityArray;
    
    NSArray *_firstArray;
    
    NSArray *_otherTableDatasource;
    NSInteger _otherTableDataType;
    
    NSString *_choosedProvince;
    NSString *_choosedCity;
}

@property (nonatomic, strong) UITableView * menuTableView;//一级页面Table
@property (nonatomic, strong) UIView * otherContainerView;//二级页面容器
@property (nonatomic, strong) UITableView * otherTableView;//二级页面Table，显示省、市

@end

@implementation FilterSlideDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

- (void)initView{
#pragma mark 一级页面
    CGRect wsframe = self.contentView.bounds;
    wsframe.origin.y = 20;
    wsframe.size.height = wsframe.size.height - 48;
    self.menuTableView = [[UITableView alloc] initWithFrame:wsframe style:UITableViewStyleGrouped];
    [self.menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.menuTableView.backgroundColor = [UIColor whiteColor];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:self.menuTableView];
    //重置
    _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _resetBtn.frame = CGRectMake(0, kSBHeight - 48, kSidebarWidth*0.5, 48);
    _resetBtn.backgroundColor = [UIColor lightGrayColor];
    [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    _resetBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_resetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_resetBtn addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_resetBtn];
    //确定
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame = CGRectMake(kSidebarWidth*0.5, kSBHeight - 48, kSidebarWidth*0.5, 48);
    _sureBtn.backgroundColor = [UIColor greenColor];
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_sureBtn];
    
    //二级页面
#pragma mark 二级页面
    _frame = self.contentView.bounds;
    _frame.origin.y = 0;
    _frame.origin.x = _frame.size.width;
    
    _otherContainerView = [[UIView alloc]initWithFrame:_frame];
    _otherContainerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_otherContainerView];
    //返回
    _backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 30, 13, 21)];
    _backImgView.image = [UIImage imageNamed:@"icon_Back Chevron"];
    [_otherContainerView addSubview:_backImgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backAction)];
    _backImgView.userInteractionEnabled = YES;
    [_backImgView addGestureRecognizer:tap];
    //线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 63.5, self.contentView.bounds.size.width, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [_otherContainerView addSubview:line];
    
    //省、市
    _otherTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, _frame.size.width, _frame.size.height-64)];
    [_otherTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _otherTableView.showsVerticalScrollIndicator = NO;
    _otherTableView.delegate = self;
    _otherTableView.dataSource = self;
    [_otherContainerView addSubview:_otherTableView];
    
    //添加右滑监测
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [panGesture delaysTouchesBegan];
    [self.view addGestureRecognizer:panGesture];
}

- (void)initData{
    _firstArray = @[@"省份",@"城市"];
    _provinceArray = @[@"四川",@"湖南",@"山东",@"陕西"];
    _cityArray = @[@"成都",@"长沙",@"青岛",@"西安",@"南宁"];
    [_menuTableView reloadData];
}

#pragma mark --------按钮点击事件
//返回
- (void)backAction{
    [self hideOtherTableView];
}
//重置
- (void)resetAction{
    //重置搜索条件
    _choosedProvince = @"";
    _choosedCity = @"";
    [self.menuTableView reloadData];
}
//确定
- (void)sureAction{
    [self showHideSidebar];
}
//父类方法，当slidebar隐藏时调用
- (void)slideToRight{
    _backBlock([NSString stringWithFormat:@"%@%@",_choosedProvince,_choosedCity]);
}
//父类方法，当slidebar出现时调用
- (void)sidebarDidShown{
    [_menuTableView reloadData];
}
//滑动手势
- (void)panAction:(UIPanGestureRecognizer*)recoginzer{
    [self panDetected:recoginzer];
}
//一级页面 tableView中按钮点击事件
#pragma mark - private
- (void)showOtherTableView{
    [UIView animateWithDuration:0.2 animations:^{
        _frame.origin.x = 0;
        _otherContainerView.frame = _frame;
    }];
}

- (void)hideOtherTableView{
    [UIView animateWithDuration:0.2 animations:^{
        _frame.origin.x = _frame.size.width;
        _otherContainerView.frame = _frame;
    }];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _menuTableView) {
        return _firstArray.count;
    }else if (tableView == _otherTableView){
        return _otherTableDatasource.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (tableView == _menuTableView) {
        InfoTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"InfoTableViewCell" owner:self options:nil]firstObject];
        if (row == 0) {
            cell.typeLabel.text = @"省份";
            cell.detailLabel.text = _choosedProvince;
        }else{
            cell.typeLabel.text = @"城市";
            cell.detailLabel.text = _choosedCity;
        }
        return cell;
    }else if(tableView == _otherTableView){
        static NSString *detailCellIdentifier = @"detailCellIdentifier";
        DetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellIdentifier];
        if(!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"DetailInfoTableViewCell" owner:self options:nil]firstObject];
        }
        cell.detailLabel.text = _otherTableDatasource[indexPath.row];
        if ([_otherTableDatasource[indexPath.row] isEqual:_choosedProvince]||[_otherTableDatasource[indexPath.row] isEqual:_choosedCity]) {
            cell.checkImgView.hidden = NO;
        }else{
            cell.checkImgView.hidden = YES;
        }
        return cell;
    }
    return [[UITableViewCell alloc]init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    if (tableView == _menuTableView) {
        if (row == 0) {
            //准备省份数据
            _otherTableDataType = 1;
            _otherTableDatasource = _provinceArray;
        }else if (row == 1){//准备城市数据
            _otherTableDataType = 2;
            _otherTableDatasource = _cityArray;
        }
        [_otherTableView reloadData];
        [self showOtherTableView];
    }else if(tableView == _otherTableView){
        if (_otherTableDataType == 1) {//选择省份
            _choosedProvince = _otherTableDatasource[row];
        }else if (_otherTableDataType == 2){ //选择市
            _choosedCity = _otherTableDatasource[row];
        }
        [_menuTableView reloadData];
        [self hideOtherTableView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
