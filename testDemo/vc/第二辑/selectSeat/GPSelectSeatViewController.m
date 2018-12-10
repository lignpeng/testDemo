//
//  GPSelectSeatViewController.m
//  testDemo
//
//  Created by lignpeng on 16/12/27.
//  Copyright © 2016年 genpeng. All rights reserved.
//

#import "GPSelectSeatViewController.h"
#import "PagingCollectionViewLayout.h"
#import "SubCollectionViewCell.h"
#import "CSCabinBoundary.h"
#import "CSSeatMapElement.h"
#import "CustomFlowLayout.h"

#define reusableCell @"SubCollectionViewCell"
@interface GPSelectSeatViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) NSArray *data2;

@property (nonatomic, strong) NSArray *dataAll;

@property(nonatomic, strong) NSMutableArray<CSCabinBoundary *> *dataSource;
@property(nonatomic, strong) NSArray *imageArray;

@end

@implementation GPSelectSeatViewController

- (NSArray *)imageArray {
    if (_imageArray) {
        return  _imageArray;
    }
    _imageArray = @[@"alipay_r",@"bitcoin_r",@"dianpin_r",@"douban_r",@"dribbble_r",
    @"dropbox_r",@"email_r",@"evernote_r",@"facebook_r",@"google-plus_r",
    @"instagram_r",@"instapaper_r",@"line_r",@"linkedin_r",@"path_r",
    @"snapchat_r",@"path_r",@"snapchat_r",@"pinterest_r",@"pocket_r",
    @"qq_r",@"quora_r",@"qzone_r",@"readability_r",@"reddit_r",
    @"path_r",@"snapchat_r",@"pinterest_r",@"pocket_r",@"qq_r",
    @"quora_r",@"qzone_r",@"readability_r",@"reddit_r"];
    return _imageArray;
}

- (NSArray *)dataSource {
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = [NSMutableArray<CSCabinBoundary *> array]; //初始化数组
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"== 读取数据出错 ==");
        return _dataSource;
    }
    NSArray *list = [dic objectForKey:@"cabinBoundary"];
    if (list.count > 0) {
        for (NSDictionary *dic in list) {
            CSCabinBoundary *obj = [[CSCabinBoundary alloc] initWithDictionary:dic error:nil];
            if (obj) {
                [_dataSource addObject:obj];
            }
        }
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat margin = 32;
    CGFloat wdith = (CGRectGetWidth(frame) - 2 * margin);
    CGFloat height = 42;
    
    CGRect bframe = CGRectMake(margin, margin + 64, wdith, height);
    UIButton *showBtn = ({
        UIButton *btn = [[UIButton alloc] initWithFrame:bframe];
        btn.backgroundColor = [UIColor blueColor];
        [btn setTitle:@"show" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 5.0;
        btn.clipsToBounds = YES;
        btn;
    });
    [self.view addSubview:showBtn];
    [self initCollectionViewWithFrame:bframe];
}

- (void)initCollectionViewWithFrame:(CGRect)frame {
//    PagingCollectionViewLayout *layout = [[PagingCollectionViewLayout alloc]init];
//    layout.itemSize = CGSizeMake(70, 85);
//    layout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
//    layout.minimumLineSpacing = 1;
//    layout.minimumInteritemSpacing = 1;
    CustomFlowLayout *layout = [[CustomFlowLayout alloc] init];
    self.collectionView = ({
        UICollectionView *cView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) + CGRectGetMinY(frame) + 16, self.view.frame.size.width, self.view.frame.size.height - 64 - 200) collectionViewLayout:layout];
        cView.backgroundColor = [UIColor clearColor];
        cView.tag = 100;
        cView.delegate = self;
        cView.dataSource = self;
        cView.showsVerticalScrollIndicator = NO;
        cView.showsHorizontalScrollIndicator = NO;
        cView.pagingEnabled = YES;
        cView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
        [self.view addSubview:cView];
        //注册单元格
        [cView registerNib:[UINib nibWithNibName:reusableCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reusableCell];
        cView;
    });
}

- (void)showAction:(UIButton *)button {


    [self.collectionView reloadData];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (section < self.dataSource.count) {
        count = self.dataSource[section].eleList.count;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SubCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusableCell forIndexPath:indexPath];
    
    CSSeatMapElement *element = self.dataSource[indexPath.section].eleList[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%ld(%d:%d, %d)",(long)indexPath.row,element.row,element.yIndex,element.xIndex];
    cell.titleLabel.text = str;
//    cell.titleLabel.backgroundColor = [UIColor yellowColor];
    //    cell.titleLabel.text = name;
//    [cell setImageWithImageName:self.imageArray[(arc4random() %self.imageArray.count)]];
//    if (cell.hidden) {  //防止hide属性的cell的重用导致部分cell消失
//        cell.hidden = NO;
//    }
    
    return cell;
}


@end
