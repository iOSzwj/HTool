//
//  HCollectionVC.m
//  HToolDemo
//
//  Created by hare27 on 16/9/21.
//  Copyright © 2016年 hare27. All rights reserved.
//

#import "HCollectionViewLayoutDemo.h"
#import "HCollectionViewFallLayout.h"
#import "HCollectionViewLineLayout.h"
#import "HCollectionViewCircleLayout.h"
#import "HCollectionViewStackLayout.h"

@interface HCollectionViewLayoutDemo ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)NSMutableArray *layoutArr;

@property(nonatomic,assign)int layoutIndex;

@end

@implementation HCollectionViewLayoutDemo

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layoutArr = [NSMutableArray array];
    
    self.layoutIndex = -1;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 基本布局
    UICollectionViewFlowLayout *flowlayout = [UICollectionViewFlowLayout new];
    flowlayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    [self.layoutArr addObject:flowlayout];
    
    
    // 瀑布流
    [self.layoutArr addObject:[HCollectionViewFallLayout new]];
    // 线性
    [self.layoutArr addObject:[HCollectionViewLineLayout new]];
    // 堆
    [self.layoutArr addObject:[HCollectionViewCircleLayout new]];
    // 圆
    [self.layoutArr addObject:[HCollectionViewStackLayout new]];
    
    [self changeLayout];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"切换布局" style:UIBarButtonItemStyleDone target:self action:@selector(changeLayout)];
    
}

-(void)changeLayout{
    
    self.layoutIndex ++;
    
    [self.collectionView removeFromSuperview];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:self.layoutArr[self.layoutIndex]];
    
    [self.view addSubview:self.collectionView];
    
    self.collectionView.dataSource =self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    if (self.layoutIndex == self.layoutArr.count - 1) {
        self.layoutIndex  = -1;
    }
    
    
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.layoutIndex != 0) {
        self.layoutIndex = -1;
        [self changeLayout];
    }
    
    
}

@end
