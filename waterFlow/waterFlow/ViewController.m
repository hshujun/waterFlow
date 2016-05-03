//
//  ViewController.m
//  waterFlow
//
//  Created by HJ on 16/4/30.
//  Copyright © 2016年 hujun. All rights reserved.
//

#import "ViewController.h"
#import "HJWaterFlowLayout.h"
#import "HJShopModel.h"
#import "MJRefresh.h"
#import "HJShopCollectionViewCell.h"
#import "MJExtension.h"
#import "HJRefresh.h"

@interface ViewController ()<UICollectionViewDataSource,HJWaterFlowLayoutDelegate>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *shop;
@property (nonatomic, strong) HJRefresh *refresh ;
@end

@implementation ViewController
static NSString * const cellID = @"shop";

- (NSMutableArray *)shop
{
    if (_shop == nil) {
        _shop = [NSMutableArray array];
    }
    return _shop;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 创建一个 collectionView
    HJWaterFlowLayout *waterFlowLayout = [[HJWaterFlowLayout alloc] init];
    waterFlowLayout.delegate = self;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout: waterFlowLayout];
    // 注册 cell
//    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HJShopCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:cellID];
    
    collectionView.dataSource = self;
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self setupRefresh];
    [self loadNewShops];
}

- (void)setupRefresh
{
    /*
//     self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    MJRefreshGifHeader *head = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    self.collectionView.header = head;
    head.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏时间
    head.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    head.stateLabel.hidden = YES;
    // 下拉刷新
    UIImage *stateIdle = [UIImage imageNamed:@"1.png"];
    NSArray *stateIdleArr = @[stateIdle];
    [head setImages:stateIdleArr forState:MJRefreshStateIdle];
    
    // 松开刷新
    UIImage *statePulling = [UIImage imageNamed:@"2.png"];
    [head setImages:@[statePulling] forState:MJRefreshStatePulling];
    
    // 正在刷新
//    [head setImages:@[[UIImage imageNamed:@"3"],[UIImage imageNamed:@"4"],[UIImage imageNamed:@"5"],[UIImage imageNamed:@"6"],[UIImage imageNamed:@"7"],[UIImage imageNamed:@"8"],[UIImage imageNamed:@"9"],[UIImage imageNamed:@"10"],[UIImage imageNamed:@"11"]] duration:1 forState:MJRefreshStateRefreshing];
    [head setImages:@[[UIImage imageNamed:@"3"],[UIImage imageNamed:@"4"],[UIImage imageNamed:@"5"],[UIImage imageNamed:@"6"],[UIImage imageNamed:@"7"],[UIImage imageNamed:@"8"],[UIImage imageNamed:@"9"],[UIImage imageNamed:@"10"],[UIImage imageNamed:@"11"]] forState:MJRefreshStateRefreshing];
    
    // 刷新完毕
    [head setImages:@[[UIImage imageNamed:@"7"]] forState:MJRefreshStateWillRefresh];
    
    
    
    */
    // 上拉刷新
    [self.collectionView.header beginRefreshing];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
    self.collectionView.footer.hidden = YES;
    
    // 下拉刷新
    self.refresh = [[HJRefresh alloc] init];
    [self.refresh addTarget:self action:@selector(loadNewShops) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refresh];
    [self.refresh beginRefreshing];
    
    
}

- (void)loadNewShops
{
//    NSMutableArray *shops = [HJShopModel mj_objectArrayWithFilename:@"1.plist"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [HJShopModel mj_objectArrayWithFilename:@"1.plist"];
        
        [self.shop removeAllObjects];
        [self.shop addObjectsFromArray:shops];
        // 刷新数据
        [self.collectionView reloadData];
        [self.refresh endRefreshing];
    });
    
}

- (void)loadMoreShops
{
    NSArray *shops = [HJShopModel mj_objectArrayWithFilename:@"1.plist"];
    [self.shop addObjectsFromArray:shops];
    [self.collectionView reloadData];
    [self.collectionView.footer endRefreshing];
}


#pragma mark -<UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.collectionView.footer.hidden = self.shop.count == 0;

    return self.shop.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HJShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    HJShopModel *model = self.shop[indexPath.item];
    cell.model = model;
    return cell;
}


#pragma mark -HJWaterFlowLayoutDelegate
- (CGFloat)waterFlowLayout:(HJWaterFlowLayout *)waterFlowLayout heightForItemAtIndex:(NSInteger)index width:(CGFloat)width
{
    HJShopModel *model = self.shop[index];
    CGFloat height = [model.h doubleValue] * width / [model.w doubleValue];
    return height ;
}
- (NSInteger)columnCountInWaterFlowLayout:(HJWaterFlowLayout *)waterFlowLayout
{
    return 5;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
