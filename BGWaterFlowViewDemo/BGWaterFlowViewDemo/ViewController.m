//
//  AppDelegate.h
//  BGWaterFlowViewDemo
//
//  Created by user on 15/11/7.
//  Copyright © 2015年 BG. All rights reserved.
//

#import "ViewController.h"
#import "BGWaterFlowView.h"
#import "BGCollectionViewCell.h"

#define BGISRefresh 1
static const CGFloat delayTiemSecond = 3.0;
static const NSInteger BGPageCount = 100;
static NSString * const BGCollectionCellIdentify = @"BGCollectionCellIdentify";
@interface ViewController () <BGWaterFlowViewDataSource, BGRefreshWaterFlowViewDelegate>
@property (nonatomic, strong) BGWaterFlowView *waterFlowView;
@property (nonatomic, strong) NSArray *dataArr;
/**
 *  源数据
 */
@property (nonatomic, strong) NSArray *sourceArr;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableDictionary *cellHeightDic;
@property (nonatomic, assign) NSInteger page;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"瀑布流式布局";
    self.navigationController.navigationBar.translucent = NO;
    self.dataList = [NSMutableArray array];
    self.cellHeightDic = [NSMutableDictionary dictionary];
    [self loadPicturesUrlDataFromPlistFile];
    [self initSubviews];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)loadPicturesUrlDataFromPlistFile{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"pic_url.plist" ofType:nil];
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *copyArr = [dataArr mutableCopy];
    for (NSInteger i = 0; i < 100; i++) {
        [copyArr addObjectsFromArray:dataArr];
    }
    dataArr = [copyArr copy];
    
    NSMutableArray *spaceArr = [NSMutableArray array];
    NSMutableArray *internalArr = nil;
    for (int i = 0; i < dataArr.count; i++) {
        if (i % BGPageCount == 0) {
            internalArr = [NSMutableArray array];
            [spaceArr addObject:internalArr];
        }
        [internalArr addObject:dataArr[i]];
    }
    self.sourceArr = dataArr;
    self.dataArr = spaceArr;
}

- (void)initSubviews {
#if BGISRefresh
    BGRefreshWaterFlowView *waterFlowView = [[BGRefreshWaterFlowView alloc] initWithFrame:self.view.bounds];
    waterFlowView.dataSource = self;
    waterFlowView.delegate = self;
    waterFlowView.columnNum = 4;
    waterFlowView.itemSpacing = 10;
    waterFlowView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.view addSubview:waterFlowView];
    [self loadNewRefreshData:waterFlowView];
    [waterFlowView registerClass:[BGCollectionViewCell class] forCellWithReuseIdentifier:BGCollectionCellIdentify];
#else
    BGWaterFlowView *waterFlowView = [[BGWaterFlowView alloc] initWithFrame:self.view.bounds];
    waterFlowView.dataSource = self;
    waterFlowView.delegate = self;
    waterFlowView.columnNum = 4;
    waterFlowView.itemSpacing = 10;
    waterFlowView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.view addSubview:waterFlowView];
    [waterFlowView registerClass:[BGCollectionViewCell class] forCellWithReuseIdentifier:BGCollectionCellIdentify];
    //给数据
    self.dataList = self.dataArr[0];
    [waterFlowView reloadData];
#endif
}

#pragma mark - BGWaterFlowViewDataSource
- (NSInteger)numberOfSectionsInWaterFlowView:(BGWaterFlowView *)waterFlowView{
    return 1;
}

- (NSInteger)waterFlowView:(BGWaterFlowView *)waterFlowView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UICollectionViewCell *)waterFlowView:(BGWaterFlowView *)waterFlowView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BGCollectionViewCell *cell = [waterFlowView dequeueReusableCellWithReuseIdentifier:BGCollectionCellIdentify forIndexPath:indexPath];
    cell.urlStr = self.dataList[indexPath.row];
    [cell setNeedsLayout];
    return cell;
}

- (CGFloat)waterFlowView:(BGWaterFlowView *)waterFlowView heightForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *heightNumber = self.cellHeightDic[indexPath];
    if(heightNumber){
        return heightNumber.floatValue;
    }
    else{
        //保存随机值
        CGFloat cellHeight = 100 + (rand() % 100);
        self.cellHeightDic[indexPath] = @(cellHeight);
        return cellHeight;
    }
}

- (void)waterFlowView:(BGWaterFlowView *)waterFlowView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", indexPath);
}

#pragma mark - BGRefreshWaterFlowViewDelegate method
- (void)pullDownWithRefreshWaterFlowView:(BGRefreshWaterFlowView *)refreshWaterFlowView{
    [self performSelector:@selector(loadNewRefreshData:) withObject:refreshWaterFlowView afterDelay:delayTiemSecond];
}

- (void)pullUpWithRefreshWaterFlowView:(BGRefreshWaterFlowView *)refreshWaterFlowView {
    [self performSelector:@selector(loadMoreRefreshData:) withObject:refreshWaterFlowView afterDelay:delayTiemSecond];
}

- (void)loadNewRefreshData :(BGRefreshWaterFlowView *)refreshWaterFlowView{
    if (self.dataArr.count > 0) {
        [self.dataList removeAllObjects];
        self.page = 0;
        [self.dataList addObjectsFromArray:self.dataArr[self.page]];
    }
    [refreshWaterFlowView reloadData];
    [refreshWaterFlowView pullDownDidFinishedLoadingRefresh];
}

- (void)loadMoreRefreshData:(BGRefreshWaterFlowView *)refreshWaterFlowView {
    if (self.sourceArr.count - self.dataList.count < BGPageCount) {
        refreshWaterFlowView.isLoadMore = NO;
        
    } else {
        refreshWaterFlowView.isLoadMore = YES;
    }
    self.page ++;
    [self.dataList addObjectsFromArray:self.dataArr[self.page]];
    [refreshWaterFlowView reloadData];
    [refreshWaterFlowView pullUpDidFinishedLoadingMore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
