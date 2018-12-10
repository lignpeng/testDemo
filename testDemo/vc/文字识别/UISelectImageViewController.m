//
//  UISelectImageViewController.m
//  testDemo
//
//  Created by lignpeng on 2018/8/22.
//  Copyright © 2018年 genpeng. All rights reserved.
//


#import "UISelectImageViewController.h"
#import "DataTools.h"
#import "HexColor.h"
#import "UIWordListViewController.h"
#import "UIHUD.h"
//#import <AipOcrSdk/AipOcrSdk.h>
#import "LGPhoto.h"
#import "UIWordViewController.h"
#import "GPTools.h"
#import "UINameListPickerView.h"

#define ApiKey @"l61gFq3Km3dywPQV4ny52Mya"
#define SecretKey @"qpHqeGue45LpeYniYLK0u9QdAWCMLpiP"

typedef enum : NSUInteger {
    NSWordTypeBasic,//通用文字识别(50000次/日)
    NSWordTypeBasicAccurate//文字识别(高精度版)(500次/日)
} NSWordType;


@interface UISelectImageViewController ()<LGPhotoPickerViewControllerDelegate,LGPhotoPickerBrowserViewControllerDataSource,LGPhotoPickerBrowserViewControllerDelegate>
@property(nonatomic, strong) UIButton *deletButton;
@property(nonatomic, strong) UIButton *okButton;
@property(nonatomic, strong) UIButton *selectButton;
@property(nonatomic, strong) UIButton *pickerButton;
@property(nonatomic, strong) NSMutableArray *images;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *typeLabel;
@property(nonatomic, copy) void (^successHandler)(id);// 默认的识别成功的回调
@property(nonatomic, copy) void (^failHandler)(NSError *);// 默认的识别失败的回调
@property(nonatomic, strong) NSArray *typeArray;
@property(nonatomic, assign) NSWordType wordType;
@end

@implementation UISelectImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[AipOcrService shardService] authWithAK:ApiKey andSK:SecretKey];
    [self initView];
    [self initData];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStylePlain target:self action:@selector(listAction)];
    
    [self.view addSubview:self.selectButton];
    [self.view addSubview:self.pickerButton];
    [self.view addSubview:self.okButton];
    [self.view addSubview:self.deletButton];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.typeLabel];
    self.wordType = NSWordTypeBasic;
    self.typeArray = @[@"通用文字识别(50000次/日)", @"文字识别(高精度版)(500次/日)"];
    self.typeLabel.text = self.typeArray[self.wordType];
}

- (void)viewDidLayoutSubviews {
    CGFloat nHight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat margin = 32;
    CGRect sframe = [UIScreen mainScreen].bounds;
    CGFloat gap = 2;
    CGFloat width = (CGRectGetWidth(sframe) - margin - gap * 3)/4;
    CGFloat bheigh = 42;
    
    //图片
    CGFloat iwidht = CGRectGetWidth(sframe) - margin;
    CGFloat iheight = iwidht * 3 /4.0;
    CGRect iframe = (CGRect){margin *0.5,nHight +0.5 * margin,iwidht,iheight};
    self.imageView.frame = iframe;
    //标签
    CGFloat y = CGRectGetMinY(iframe) + iheight + margin *0.5;
    CGFloat lheight = 32;
    CGRect lframe = (CGRect){margin,y,CGRectGetWidth(sframe) - margin * 2,lheight};
    self.typeLabel.frame = lframe;
    
    y = CGRectGetMinY(lframe) + lheight + margin *0.5;
    CGRect bframe = CGRectMake(margin*0.5,y, width, bheigh);
    //拍照
    self.pickerButton.frame = bframe;
    //选择
    bframe.origin.x += width + gap;
    self.selectButton.frame = bframe;
    //确定
    bframe.origin.x += width + gap;
    self.okButton.frame = bframe;
    //删除
    bframe.origin.x += width + gap;
    self.deletButton.frame = bframe;
}

- (void)initData {
        // 这是默认的识别成功的回调
    self.successHandler = ^(id result){
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIHUD dismissHUD];
        });
        
        NSLog(@"%@", result);
            // NSString *title = @"识别结果";
        NSMutableString *message = [NSMutableString string];
        
        if(result[@"words_result"]){
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@: %@\n", key, obj];
                    }
                    
                }];
            }else if([result[@"words_result"] isKindOfClass:[NSArray class]]){
                for(NSDictionary *obj in result[@"words_result"]){
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@\n", obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@\n", obj];
                    }
                }
            }
            
        }else{
            [message appendFormat:@"%@", result];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIWordViewController *vc = [UIWordViewController wordViewControllerWithString:message];
            
            [[GPTools getCurrentViewController] presentViewController:vc animated:YES completion:nil];
        }];
    };
    
    self.failHandler = ^(NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIHUD dismissHUD];
        });
        NSLog(@"%@", error);
        NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [GPTools ShowAlertViewWithoutCancelActionTitle:@"识别失败" message:msg handler:nil];
        }];
    };
}

- (void)listAction {
    UIWordListViewController *vc = [UIWordListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)labelAction{
    __weak typeof(self) weakSelf = self;
    [UINameListPickerView nameListPickerView:self.typeArray selectedIndex:self.wordType complish:^(NSInteger index, NSString *name) {
        weakSelf.wordType = index;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.typeLabel.text = weakSelf.typeArray[index];
        });
    }];
}

//确定
- (void)okAction {
    if (self.images.count == 0) {
        [GPTools ShowInfoTitle:@"提醒" message:@"请先添加图片" delayTime:0.2];
        return;
    }
    NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIHUD showHUD];
    });
    UIImage *image = self.images.firstObject;
    /*
    switch (self.wordType) {
        case NSWordTypeBasic:{
            [[AipOcrService shardService] detectTextBasicFromImage:image
                                                       withOptions:options
                                                    successHandler:self.successHandler
                                                       failHandler:self.failHandler];
        }break;
        case NSWordTypeBasicAccurate:{
            [[AipOcrService shardService] detectTextAccurateBasicFromImage:image
                                                               withOptions:options
                                                            successHandler:self.successHandler
                                                               failHandler:self.failHandler];
        }break;
        default:
            break;
    }
    */
}

//选择
- (void)selectAction {
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:LGShowImageTypeImagePicker];
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = 1;   // 最多能选9张图片
    pickerVc.delegate = self;
//    pickerVc.nightMode = YES;//夜间模式
    [pickerVc showPickerVc:self];
}

//拍照
- (void)pickerAction {
    ZLCameraViewController *cameraVC = [[ZLCameraViewController alloc] init];
        // 拍照最多个数
    cameraVC.maxCount = 1;
        // 单拍
    cameraVC.cameraType = ZLCameraSingle;
    __weak typeof(self) weakSelf = self;
    cameraVC.callback = ^(NSArray *cameras){
        //在这里得到拍照结果
        //数组元素是ZLCamera对象
        ZLCamera *canamerPhoto = cameras[0];
        UIImage *image = canamerPhoto.photoImage;
        [weakSelf.images removeAllObjects];
        [weakSelf.images addObject:image];
        [weakSelf updateImageView];
    };
    [cameraVC showPickerVc:self];
}

- (void)deletAction {
    [self.images removeAllObjects];
    [self updateImageView];
}


- (void)browserAction {
    if (self.images.count == 0) {
        //选择图片
        [self selectAction];
        return;
    }
    LGPhotoPickerBrowserViewController *vc = [[LGPhotoPickerBrowserViewController alloc] init];
    vc.delegate = self;
    vc.dataSource = self;
    vc.showType = LGShowImageTypeImageBroswer;
    //编辑图片
    __weak typeof(self) weakSelf = self;
    vc.editBlock = ^(UIImage *image) {
        [weakSelf.images removeAllObjects];
        [weakSelf.images addObject:image];
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)updateImageView {
    if (self.images.count > 0) {
        self.imageView.image = self.images.firstObject;
    }else {
        self.imageView.image = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateImageView];
}

#pragma mark - LGPhotoPickerViewControllerDelegate

- (void)pickerViewControllerDoneAsstes:(NSArray <LGPhotoAssets *> *)assets isOriginal:(BOOL)original{
     //assets的元素是LGPhotoAssets对象，获取image方法如下:
    [self.images removeAllObjects];
     for (LGPhotoAssets *photo in assets) {
         float size = [DataTools calulateImageFileSizeTypeMB:photo.originImage];
         if (size < 4) {
             [self.images addObject:photo.originImage];
         }else {
             size = [DataTools calulateImageFileSizeTypeMB:photo.compressionImage];
             if (size < 4) {
                 [self.images addObject:photo.compressionImage];
             }else {
                 [self.images addObject:photo.thumbImage];
             }
         }
     }
    [self updateImageView];
}

#pragma mark - LGPhotoPickerBrowserViewControllerDataSource

- (NSInteger)photoBrowser:(LGPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return self.images.count;
}

- (id<LGPhotoPickerBrowserPhoto>)photoBrowser:(LGPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath {
    LGPhotoAssets *imageObj = [[LGPhotoAssets alloc] init];
    imageObj = [self.images objectAtIndex:indexPath.item];
    // 包装下imageObj 成 LGPhotoPickerBrowserPhoto 传给数据源
    LGPhotoPickerBrowserPhoto *photo = [LGPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    return photo;
}

- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = ({
            UIButton *bt = [[UIButton alloc] initWithFrame:CGRectZero];
            [bt addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
            [bt setTitle:@"选择" forState:UIControlStateNormal];
            bt.backgroundColor = [UIColor colorWith8BitRedN:arc4random()%256 green:arc4random()%256 blue:arc4random()%256];
            bt.layer.cornerRadius = 5;
            bt.clipsToBounds = YES;
            bt;
        });
    }
    return _selectButton;
}

- (UIButton *)okButton {
    if (!_okButton) {
        _okButton = ({
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
            [button addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"确定" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWith8BitRedN:arc4random()%256 green:arc4random()%256 blue:arc4random()%256];
            button.layer.cornerRadius = 5;
            button.clipsToBounds = YES;
            button;
        });
    }
    return _okButton;
}

- (UIButton *)deletButton {
    if (!_deletButton) {
        _deletButton = [GPTools colorButton:@"清除" titleFont:nil isColor:YES corner:5 target:self action:@selector(deletAction)];
    }
    return _deletButton;
}

- (UIButton *)pickerButton {
    if (!_pickerButton) {
        _pickerButton = ({
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
            [button addTarget:self action:@selector(pickerAction) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"拍照" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWith8BitRedN:arc4random()%256 green:arc4random()%256 blue:arc4random()%256];
            button.layer.cornerRadius = 5;
            button.clipsToBounds = YES;
            button;
        });
    }
    return _pickerButton;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor lightGrayColor];
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 5.0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(browserAction)];
        [_imageView addGestureRecognizer:tap];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.layer.cornerRadius = 5;
            label.clipsToBounds = YES;
            label.backgroundColor = [UIColor groupTableViewBackgroundColor];
            label.textColor = [UIColor darkGrayColor];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
                //添加手势：单击
            UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelAction)];
            ges.numberOfTapsRequired = 1;
            label.userInteractionEnabled = YES;
            [label addGestureRecognizer:ges];
            label;
        });
    }
    return _typeLabel;
}

@end

