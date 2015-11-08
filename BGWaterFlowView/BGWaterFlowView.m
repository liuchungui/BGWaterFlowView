//
//  BGWaterFlowView.m
//  BGCollectionView
//
//  Created by user on 15/11/7.
//  Copyright © 2015年 FAL. All rights reserved.
//

#import "BGWaterFlowView.h"
#import "BGWaterFlowLayout.h"
#import "EGORefreshTableHeaderView.h"
#import "UIView+Extra.h"

static NSString * const BGCollectionRefreshHeaderView = @"BGCollectionRefreshHeaderView";
static NSString * const BGCollectionRefreshFooterView = @"BGCollectionRefreshFooterView";
#define BGScreenWidth [UIScreen mainScreen].bounds.size.width
#define BGScreenHeight [UIScreen mainScreen].bounds.size.height
#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#pragma mark - BGWaterFlowView class
@interface BGWaterFlowView ()<BGWaterFlowLayoutDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end
@implementation BGWaterFlowView
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initViews];
    }
    return self;
}

- (void)awakeFromNib{
    [self initViews];
}

- (void)initViews{
    BGWaterFlowLayout *waterFlowLayout = [[BGWaterFlowLayout alloc] init];
    waterFlowLayout.columnNum = 4;
    waterFlowLayout.itemSpacing = 15;
    waterFlowLayout.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:waterFlowLayout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.alwaysBounceVertical = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

#pragma mark - UICollectionView的公共方法
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier{
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier{
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (void)reloadData{
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if([self.dataSource respondsToSelector:@selector(numberOfSectionsInWaterFlowView:)]){
        return [self.dataSource numberOfSectionsInWaterFlowView:self];
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataSource waterFlowView:self numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.dataSource waterFlowView:self cellForItemAtIndexPath:indexPath];
}

#pragma mark - BGWaterFlowLayoutDelegate method
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(waterFlowView:didSelectItemAtIndexPath:)]){
        [self.delegate waterFlowView:self didSelectItemAtIndexPath:indexPath];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(BGWaterFlowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.dataSource waterFlowView:self heightForItemAtIndexPath:indexPath];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

#pragma mark - BGRefreshWaterFlowView class
@interface BGRefreshWaterFlowView()<EGORefreshTableHeaderDelegate>{
    EGORefreshTableHeaderView *_refreshTableHeaderView;
    BOOL _reloading;
    UIButton *_loadMoreButton;
    UIActivityIndicatorView *_activityView;
    UILabel *_showHintDescLabel;
}

@end
@implementation BGRefreshWaterFlowView
- (void)initViews {
    [super initViews];
    BGWaterFlowLayout *waterFlowLayout = (BGWaterFlowLayout *)self.collectionView.collectionViewLayout;
    waterFlowLayout.headerHeight = 1.0f;
//    waterFlowLayout.headerHeight = 10;
    waterFlowLayout.footerHeight = 60;
    
    //注册头部、尾部
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BGCollectionRefreshHeaderView];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BGCollectionRefreshFooterView];
}

- (void)reloadData {
    [super reloadData];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if([kind isEqual:UICollectionElementKindSectionHeader]) {
        //解决多组造成的下拉刷新UI显示异常
        UICollectionReusableView *collectionHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BGCollectionRefreshHeaderView forIndexPath:indexPath];
        
        if (!_refreshTableHeaderView) {
            _refreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
            _refreshTableHeaderView.delegate = self;
            [collectionHeaderView addSubview:_refreshTableHeaderView];
            _refreshTableHeaderView.backgroundColor = [UIColor clearColor];
            [_refreshTableHeaderView refreshLastUpdatedDate];
        }
        
        return collectionHeaderView;
    } else if([kind isEqual:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *collectionFooterView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BGCollectionRefreshFooterView forIndexPath:indexPath];
        if (!_loadMoreButton) {
            _loadMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _loadMoreButton.backgroundColor = [UIColor clearColor];
            _loadMoreButton.frame = CGRectMake(0, 0, BGScreenWidth, 40);
            UIFont *font1 = [UIFont systemFontOfSize:13.0];
            [_loadMoreButton addTarget:self action:@selector(loadMoreDataAction) forControlEvents:UIControlEventTouchUpInside];
            _showHintDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BGScreenWidth, 13)];
            _showHintDescLabel.text = @"上拉加载更多图片...";
            _showHintDescLabel.font = font1;
            _showHintDescLabel.textColor = UIColorFromHex(0xaaaaaa);
            [_loadMoreButton addSubview:_showHintDescLabel];
            _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            _activityView.frame = CGRectMake(100, 10, 20, 20);
            _activityView.hidden = NO;
            [_activityView stopAnimating];
            [self refreshHintLabelFrame];
            [_loadMoreButton addSubview:_activityView];
            [collectionFooterView addSubview:_loadMoreButton];
        }
        return collectionFooterView;
    }
    return nil;
}
    
- (void)loadMoreDataAction {
    [self loadMoreDataLoadingUI];
    
    id<BGRefreshWaterFlowViewDelegate> delegate = (id<BGRefreshWaterFlowViewDelegate>)self.delegate;
    if([delegate respondsToSelector:@selector(pullUpWithRefreshWaterFlowView:)]){
        [delegate pullUpWithRefreshWaterFlowView:self];
    }
}
    
- (void)loadMoreDataLoadingUI {
    _showHintDescLabel.text = @"正在加载中...";
    [self refreshHintLabelFrame];
//    [_activityView stopAnimating];
    _loadMoreButton.enabled = NO;
    [_activityView startAnimating];
}
    
- (void)pullUpDidFinishedLoadingMore {
    if (_isLoadComplete) {
        _loadMoreButton.hidden = NO;
        _loadMoreButton.enabled = YES;
        _showHintDescLabel.text = @"上拉加载更多图片...";
        [self refreshHintLabelFrame];
        [_activityView stopAnimating];
    }else {
        _loadMoreButton.hidden = YES;
    }
}

    
#pragma mark - EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    id<BGRefreshWaterFlowViewDelegate> delegate = (id<BGRefreshWaterFlowViewDelegate>)self.delegate;
    if([delegate respondsToSelector:@selector(pullDownWithRefreshWaterFlowView:)]){
        [delegate pullDownWithRefreshWaterFlowView:self];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
    
    return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
    
    return [NSDate date]; // should return date data source was last changed
}

- (void)refreshHintLabelFrame {
    NSDictionary *showHintLabelAttDic = [NSDictionary dictionaryWithObjectsAndKeys:_showHintDescLabel.font,NSFontAttributeName, nil];
    CGSize showHintLabelRect = [_showHintDescLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 13) options:NSStringDrawingUsesFontLeading attributes:showHintLabelAttDic context:nil].size;
    _showHintDescLabel.size = showHintLabelRect;
    _showHintDescLabel.top = (_loadMoreButton.height - _showHintDescLabel.height) / 2.0;
    _showHintDescLabel.left = (_loadMoreButton.width - _showHintDescLabel.width) / 2.0;
    _activityView.right = _showHintDescLabel.left - 5;
    _activityView.top = (_loadMoreButton.height - _activityView.height) / 2.0;
}

#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource {
    _reloading = YES;
}

- (void)pullDownDidFinishedLoadingRefresh {
    _reloading = NO;
    [_refreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.collectionView];
}

#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_refreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_refreshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    float sub = scrollView.contentSize.height - scrollView.contentOffset.y;
    if (scrollView.height - sub > 60) {
        [self loadMoreDataAction];
    }
}
@end
