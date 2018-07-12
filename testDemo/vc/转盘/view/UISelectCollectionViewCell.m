//
//  UISelectCollectionViewCell.m
//  testDemo
//
//  Created by lignpeng on 2018/7/11.
//  Copyright © 2018年 genpeng. All rights reserved.
//

#import "UISelectCollectionViewCell.h"
#import "Masonry.h"

@interface UISelectCollectionViewCell()

@property(nonatomic, strong) UILabel *namelabel;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIButton *deletButton;
@property(nonatomic, assign) BOOL status;//YES:显示删除按钮
@property(nonatomic, strong) NSIndexPath *indexpath;
@end

@implementation UISelectCollectionViewCell

+ (instancetype)buttonViewWithTitle:(NSString *)title {
    UISelectCollectionViewCell *view = [[UISelectCollectionViewCell alloc] init];
    view.namelabel.text = title;
    return view;
}

+ (instancetype)selectCollectionViewCell:(UICollectionView *)colletionview indexPath:(NSIndexPath *)indexPath model:(LabelModel *)model{
    UISelectCollectionViewCell *cell = [colletionview dequeueReusableCellWithReuseIdentifier:identifyCell forIndexPath:indexPath];
    if (!cell) {
        cell = [[UISelectCollectionViewCell alloc] init];
        
    }
    cell.indexpath = indexPath;
    [cell initView];
    [cell configCell:model];
    return cell;
}

- (void)configCell:(LabelModel *)model {
    self.imageView.hidden = !model.isImage;
    self.namelabel.hidden = model.isImage;
    self.deletButton.hidden = !model.isShowDelete;
    if (model.isImage) {
        self.imageView.image = [[UIImage alloc] initWithContentsOfFile:model.name];
    }else {
        self.namelabel.text = model.name;
    }
}

- (void)initView {
//    CGFloat commom = 64;
    self.backgroundColor = [UIColor clearColor];
//    self.frame = (CGRect){0,0,commom,commom};
    [self addSubview:self.namelabel];
    [self.namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self addSubview:self.deletButton];
    [self.deletButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.width.height.mas_equalTo(20);
    }];
//    self.namelabel.layer.cornerRadius = CGRectGetWidth(self.bounds)*0.5;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.namelabel.layer.cornerRadius = CGRectGetWidth(self.bounds) *0.5;
    self.imageView.layer.cornerRadius = CGRectGetWidth(self.bounds) *0.5;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    self.deletButton.hidden = !self.status;
    self.status = !self.status;
}

- (void)deletaction {
    if (self.deleteActionBlock) {
        self.deleteActionBlock(self.indexpath);
    }
}

- (UILabel *)namelabel {
    if (!_namelabel) {
        _namelabel = [UILabel new];
        _namelabel.backgroundColor = [UIColor whiteColor];
        _namelabel.textColor = [UIColor darkTextColor];
        _namelabel.textAlignment = NSTextAlignmentCenter;
        _namelabel.font = [UIFont systemFontOfSize:12];
        _namelabel.numberOfLines = 0;
        _namelabel.clipsToBounds = YES;
        _namelabel.layer.borderWidth = 1;
        _namelabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//        tap.numberOfTapsRequired = 2;
//        [_namelabel addGestureRecognizer:tap];
    }
    return _namelabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        _imageView.layer.borderWidth = 1;
        _imageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//        tap.numberOfTapsRequired = 2;
//        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (UIButton *)deletButton {
    if (!_deletButton) {
        _deletButton = [[UIButton alloc] init];
        [_deletButton setImage:[UIImage imageNamed:@"blue_delete"] forState:UIControlStateNormal];
        [_deletButton addTarget:self action:@selector(deletaction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deletButton;
}
@end
