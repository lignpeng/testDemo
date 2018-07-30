//
//  UILabelsViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/7/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "UILabelsViewController.h"
#import "UISelectCollectionViewCell.h"
#import "Masonry.h"
#import "GPTools.h"
#import <Photos/PHPhotoLibrary.h>
#import "FileTools.h"
#import "UIViewController+BackButtonHandler.h"
#import "DataTools.h"

@interface UILabelsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, strong) UIView *holderView;
@property(nonatomic, strong) UITextField *textField;
@end

@implementation UILabelsViewController

+ (instancetype)labelsViewControllerWith:(NSArray *)items complishBlock:(void(^)(NSArray *items))complishBlock {
    UILabelsViewController *vc = [UILabelsViewController new];
    if (items.count > 0) {
        [vc.dataSource addObjectsFromArray:items];
    }
    vc.actionBlock = complishBlock;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

//返回
- (BOOL)navigationShouldPopOnBackButton {
    if (self.actionBlock) {
        self.actionBlock(self.dataSource);
    }
    return YES;
}

- (void)initView {
    self.title = @"标签";
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(okAction)];
    CGFloat margin = 16;
    CGFloat theight = 42;
    CGFloat navigationbarHight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat holdHeight = margin * 2 + theight;
    
    [self.view addSubview:self.holderView];
    [self.holderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(navigationbarHight);
        make.right.left.equalTo(self.view);
        make.height.mas_equalTo(holdHeight);
    }];
    
    [self.holderView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.holderView).offset(margin);
        make.bottom.equalTo(self.holderView).offset(-margin);
        make.width.mas_equalTo(150);
    }];
    
    UIButton *addbutton = [[UIButton alloc] init];
    [addbutton setTitle:@"添加" forState:UIControlStateNormal];
    addbutton.backgroundColor = [UIColor colorWithRed:21.0/256.0 green:126.0/256.0 blue:251.0/256.0 alpha:1];
    [addbutton addTarget:self action:@selector(addLabelAction) forControlEvents:UIControlEventTouchUpInside];
    addbutton.titleLabel.font = [UIFont systemFontOfSize:14];
    CGFloat radius = 3;
    addbutton.layer.cornerRadius = radius;
    addbutton.clipsToBounds = YES;
    [self.holderView addSubview:addbutton];
    
    [addbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.holderView).offset(margin);
        make.bottom.equalTo(self.holderView).offset(-margin);
        make.left.equalTo(self.textField.mas_right).offset(margin * 0.25);
        make.width.mas_equalTo(64);
    }];
    
    UIButton *addImageBT = [[UIButton alloc] init];
    [addImageBT setTitle:@"添加图片" forState:UIControlStateNormal];
    [addImageBT addTarget:self action:@selector(addImageAction) forControlEvents:UIControlEventTouchUpInside];
    addImageBT.titleLabel.font = [UIFont systemFontOfSize:14];
    addImageBT.layer.cornerRadius = radius;
    addImageBT.clipsToBounds = YES;
    addImageBT.backgroundColor = [UIColor colorWithRed:21.0/256.0 green:126.0/256.0 blue:251.0/256.0 alpha:1];
    [self.holderView addSubview:addImageBT];
    [addImageBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.holderView).offset(margin);
        make.bottom.equalTo(self.holderView).offset(- margin);
        make.left.equalTo(addbutton.mas_right).offset(margin * 0.25);
        make.right.equalTo(self.holderView).offset(- margin*0.5);
    }];

    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.holderView.mas_bottom).offset(margin * 0.5);
        make.left.equalTo(self.holderView).offset(margin * 0.5);
        make.right.equalTo(self.holderView).offset(-margin * 0.5);
        make.bottom.equalTo(self.view.mas_bottom).offset(-margin * 0.25);
    }];
    [self.collectionView reloadData];
}

- (void)okAction {
    for (LabelModel *model in self.dataSource) {
        model.isShowDelete = !model.isShowDelete;
    }
    [self.collectionView reloadData];
}

- (void)addImageAction {
    [self.view endEditing:YES];
    [self checkPhotoStauts];
}

//检查照片权限
- (void) checkPhotoStauts{
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    if (photoAuthorStatus == PHAuthorizationStatusAuthorized || photoAuthorStatus == PHAuthorizationStatusNotDetermined) {
        [self selectImage];
    }else {
        [GPTools ShowAlert:@"没有访问相册权限，请在系统设置开启后再操作"];
    }
}

- (void)selectImage {
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate = self;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}
#pragma mark -实现图片选择器代理-（上传图片的网络请求也是在这个方法里面进行，这里我不再介绍具体怎么上传图片）
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
//    UIImage *orignImage = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
//    CGRect selectRect = [[info objectForKey:UIImagePickerControllerCropRect] CGRectValue]; //通过key值获取到图片
//    UIImage *image = [GPTools clipImageOrignImage:orignImage WithRect:selectRect];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSString *path = [FileTools createFileFolderInDocumentsWithName:@"images"];
    
    NSString *pathStr = [path stringByAppendingString:[NSString stringWithFormat:@"/%@.png",[DataTools createFileName:6]]];
    [UIImagePNGRepresentation(image) writeToFile:pathStr atomically:YES];
    NSLog(@"str = %@",pathStr);
    [self addLabelModel:pathStr isImage:YES];
}
//当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)addLabelAction {
    [self.view endEditing:YES];
    if (self.textField.text.length > 0) {
        [self addLabelModel:self.textField.text isImage:NO];
    }
}

- (void)addLabelModel:(NSString *)name isImage:(BOOL)isImage{
    LabelModel *model = [[LabelModel alloc] init];
    model.isImage = isImage;
    if (isImage) {
        model.path = name;
        NSPredicate *predic = [NSPredicate predicateWithFormat:@"self.isImage == YES"];
        NSArray *array = [self.dataSource filteredArrayUsingPredicate:predic];
        model.name = [NSString stringWithFormat:@"%lu号",array.count + 1];        
    }else {
        model.name = name;
    }
    
    //对象重定向到realm存储的数据对象，上面创建的model跟下面存储到realm的对象不相关的
//    [FileTools addObjectToDB:model];
    [self.dataSource addObject:model];
    [self.collectionView reloadData];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UISelectCollectionViewCell *cell = [UISelectCollectionViewCell selectCollectionViewCell:collectionView indexPath:indexPath model:self.dataSource[indexPath.row]];
    __weak typeof(self) weakSelf = self;
    cell.deleteActionBlock = ^(NSIndexPath *indexPath) {
        [GPTools ShowAlertView:[NSString stringWithFormat:@"是否删除：“%@”标签",((LabelModel *)weakSelf.dataSource[indexPath.row]).name] alertHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf removeItem:indexPath];
            });
            
        }];
    };
    return cell;
}

- (void)removeItem:(NSIndexPath *)indexPath {
//    [FileTools deletDBObject:@[self.dataSource[indexPath.row]]];
//    LabelModel *model = self.dataSource[indexPath.row];
//    [FileTools deletDBObject:model withKeyValue:model.id];
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [self.collectionView reloadData];
}

//- (void)longTouchAction:(UILongPressGestureRecognizer *)tap {
//    CGPoint pointTouch = [tap locationInView:self.collectionView];
//
//    if (tap.state == UIGestureRecognizerStateBegan) {
//        NSLog(@"UIGestureRecognizerStateBegan");
//
//        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointTouch];
//        if (indexPath == nil) {
//            NSLog(@"空");
//        }else{
//
//            NSLog(@"Section = %ld,Row = %ld",(long)indexPath.section,(long)indexPath.row);
//           LabelModel *model = self.dataSource[indexPath.row];
//            model.isShowDelete = !model.isShowDelete;
//            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
//        }
//    }
//    if (tap.state == UIGestureRecognizerStateChanged) {
//        NSLog(@"UIGestureRecognizerStateChanged");
//    }
//
//    if (tap.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"UIGestureRecognizerStateEnded");
//    }
//
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat widht = CGRectGetWidth(self.collectionView.bounds) / 4;
    return  CGSizeMake(widht,widht);
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIView *)holderView {
    if (!_holderView) {
        _holderView = [UIView new];
        _holderView.backgroundColor = [UIColor whiteColor];
//        [_holderView addSubview:self.textField];
    }
    return _holderView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.placeholder = @"输入标签";
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _textField;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowlayout  = [UICollectionViewFlowLayout new];
        flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:(CGRect){0,0,120,120} collectionViewLayout:flowlayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UISelectCollectionViewCell class] forCellWithReuseIdentifier:identifyCell];
        UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTouchAction:)];
        tap.minimumPressDuration = 1.0;
        [_collectionView addGestureRecognizer:tap];
    }
    return _collectionView;
}

@end
