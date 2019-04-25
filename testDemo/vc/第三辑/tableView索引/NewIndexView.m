//

#import "NewIndexView.h"

@interface NewIndexView ()
@property (nonatomic, weak, nullable) id<NewIndexViewDelegate> delegate;
@property (nonatomic, copy) NSArray<NSString *> *indexItems;//组标题数组
@property (nonatomic, strong) NSMutableArray<UIButton *> *itemsViewArray;//标题item view数组
@property (nonatomic, assign) NSInteger selectedIndex;//当前选中下标
@property (nonatomic, strong) UIView *holderView;//用于加载item view
@property (nonatomic, strong) UILabel *indicatorView;//指示提示view
@property (nonatomic, assign) BOOL isShowIndicatorView;//是否显示indicatorview
@property (nonatomic, weak) UITableView *tableView;//外部传进来的
@property (nonatomic, weak) UIView *otherIndicatorView;//来自外部提供的indicatorview
@property (nonatomic, assign) BOOL isOtherIndicatorView;//是否来自外部提供的indicatorview
@property (nonatomic, copy) void (^touchBlock)(NSString *title);
@property (nonatomic, strong) UIColor *backColor;//点击、滑动时的背景色
@property (nonatomic, assign) BOOL isShowBackColor;//是否显示背景色
@end

@implementation NewIndexView

+ (instancetype)indexViewWithFrame:(CGRect)frame tableView:(UITableView *)tableView delegate:(id<NewIndexViewDelegate>)delegate {
    NewIndexView *view = [[NewIndexView alloc] init];
    view.frame = frame;
    view.delegate = delegate;
    view.tableView = tableView;
    [view reload];
    return view;
}

- (void)showIndicatorView:(BOOL)isShow {
    self.isShowIndicatorView = isShow;
}

- (void)showBackColor:(UIColor *)backColor {
    self.backColor = backColor;
    self.isShowBackColor = YES;
}

//显示自定义indicatorView；如果传入自定义indicatorView注意避免循环引用
- (void)configIndicatorView:(UIView *)indicatorView touchBlock:(void(^)(NSString *title))touchBlock {
    if (!indicatorView) {
        return;
    }
    self.isShowIndicatorView = YES;
    self.isOtherIndicatorView = YES;
    self.touchBlock = touchBlock;
    self.otherIndicatorView = indicatorView;
    [self.tableView.superview addSubview:self.otherIndicatorView];
    self.otherIndicatorView.hidden = YES;
    [self.indicatorView removeFromSuperview];
}
- (instancetype)init {
    if (self = [super init]) {
        [self attributeSettings];
    }
    return self;
}

- (void)dealloc {
    [self.indicatorView removeFromSuperview];
    [self.otherIndicatorView removeFromSuperview];
}
#pragma mark - 布局
- (void)reload {
    //获取标题组
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionIndexTitles)]) {
        self.indexItems = [self.delegate sectionIndexTitles];
        if (self.indexItems.count == 0) {
            return;
        }
    }else {
        return;
    }
    //初始化title
    [self initialiseAllTitles];
}

- (void)didMoveToSuperview {
    [self reload];
}

#pragma mark - 初始化属性设置
- (void)attributeSettings {
    self.isShowIndicatorView = NO;
    self.isShowBackColor = NO;
    self.selectedIndex = 0;
    self.offset = 30;
    //文字大小
    self.titleFontSize = 12;
    //字体颜色
    self.titleColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.f];
    //文字间距
    self.itemSpace = 4;
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - 初始化title
- (void)initialiseAllTitles {
    //清除缓存
    for (UIView *subview in self.itemsViewArray) {
        [subview removeFromSuperview];
    }
    [self.itemsViewArray removeAllObjects];
    [self.holderView removeFromSuperview];
    [self addSubview:self.holderView];
    //高度是否符合
    CGFloat totalHeight = (self.indexItems.count * self.titleFontSize) + ((self.indexItems.count + 1) * self.itemSpace);
    if (CGRectGetHeight(self.frame) < totalHeight) {
        NSLog(@"View height is not enough");
        return;
    }
    //宽度是否符合
    CGFloat margin = 4;
    CGFloat totalWidth = self.titleFontSize*1.5 + margin;
    if (CGRectGetWidth(self.frame) < totalWidth) {
        NSLog(@"View width is not enough");
        return;
    }
    //设置Y坐标
    CGFloat startY = self.itemSpace;
    //标题视图布局
    for (int i=0; i<self.indexItems.count; i++) {
        NSString *title = self.indexItems[i];
        CGSize itemMaxSize = [title boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:self.titleFontSize]} context:nil].size;
        CGFloat wdith = (itemMaxSize.width < itemMaxSize.height?itemMaxSize.height:itemMaxSize.width) + margin;
        CGFloat x = (CGRectGetWidth(self.frame) - wdith) * 0.5;
        UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(x, startY, wdith, itemMaxSize.height + margin)];
        item.userInteractionEnabled = NO;
        item.layer.cornerRadius = CGRectGetHeight(item.frame)*0.5;
        item.clipsToBounds = YES;
        item.titleLabel.adjustsFontSizeToFitWidth = YES;
        item.titleLabel.font = [UIFont boldSystemFontOfSize:self.titleFontSize];
        [item setTitle:title forState:UIControlStateNormal];
        [item setTitleColor:self.titleColor forState:UIControlStateNormal];
        [item setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [item setBackgroundImage:[self imageWithColor:[UIColor clearColor] size:item.frame.size] forState:UIControlStateNormal];
        [item setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:0 green:138.0/255.0 blue:203.0/255.0 alpha:1.0] size:item.frame.size] forState:UIControlStateSelected];
        [self.itemsViewArray addObject:item];
        [self.holderView addSubview:item];
        startY += CGRectGetHeight(item.frame) + self.itemSpace;
    }
    CGRect frame = (CGRect){0,self.offset,CGRectGetWidth(self.frame),startY};
    self.holderView.frame = frame;
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 事件处理
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    [self touchAction:touch];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    [self touchAction:touch];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isShowIndicatorView) {
        [self dismissIndicatorView];
    }
    if (self.isShowBackColor) {
        [self dismissBackViewColor];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isShowIndicatorView) {
        [self dismissIndicatorView];
    }
    if (self.isShowBackColor) {
        [self dismissBackViewColor];
    }
}

- (void)touchAction:(UITouch *)touch {
    CGPoint location = [touch locationInView:self.holderView];
    CGFloat rate = location.y / self.holderView.frame.size.height;
    NSUInteger newIndex = rate * self.itemsViewArray.count;
    if (newIndex != self.selectedIndex) {
        if (newIndex >= 0 && self.itemsViewArray.count > newIndex) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectedSectionIndexTitle:atIndex:)]) {
                [self.delegate selectedSectionIndexTitle:self.indexItems[newIndex] atIndex:newIndex];
            }
            //这句代码要放在后面，不然tableview滚动又会调用更新索引
            [self updateSelectedItem:newIndex];
            if (self.isShowIndicatorView) {
                [self showIndicatorViewTitle:self.indexItems[newIndex]];
            }
            [self showBackViewColor];
        }
    }
}

- (void)updateSelectedItem:(NSInteger)selectedIndex {
    self.selectedIndex = selectedIndex;
    for (NSInteger i = 0; i < self.itemsViewArray.count; i++) {
        UIButton *bt = self.itemsViewArray[i];
        bt.selected = (selectedIndex == i);
    }
}

/*
 tableview是按照整个手机屏幕来计算visibleCells，如果tableView的frame没有屏幕大的话，
 比如有导航栏，这部分也是visible的，会计算到cell
 如果取第一个visiblecell的话，如果这个cell高度比较小，小于导航栏高度，实际上是没有显示出来的
 因此，需要动态获取cell
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView navigationHeight:(CGFloat)height{
    UITableViewCell *cell = [self.tableView visibleCells].firstObject;
    CGFloat cellHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    NSInteger num = floor(height / cellHeight);
    NSIndexPath *indexPacth = [self.tableView indexPathsForVisibleRows][num];
    NSInteger index = indexPacth.section;
    if (index == 1) {
        NSInteger mm = [self.tableView numberOfRowsInSection:0];
        if (mm < num && scrollView.contentOffset.y < 30) {
            index = 0;
        }
    }
    [self updateSelectedItem:index];
}

- (void)showBackViewColor {
    if (self.isShowBackColor) {
        self.backgroundColor = self.backColor;
    }
}

- (void)dismissBackViewColor {
    self.backgroundColor = [UIColor clearColor];
}

- (void)showIndicatorViewTitle:(NSString *)title {
    if (self.isOtherIndicatorView) {
        self.otherIndicatorView.hidden = NO;
        self.otherIndicatorView.alpha = 1.0;
        if (self.touchBlock) {
            self.touchBlock(title);
        }
    }else {
        self.indicatorView.hidden = NO;
        self.indicatorView.text = title;
        self.indicatorView.alpha = 1.0;
    }
}

- (void)dismissIndicatorView {
    UIView *view = self.indicatorView;
    if (self.isOtherIndicatorView) {
        view = self.otherIndicatorView;
    }
    view.hidden = YES;
    [UIView animateWithDuration:0.25 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.alpha = 0.0;
    } completion:^(BOOL finished) {
        view.hidden = YES;
    }];
}

#pragma mark - getter
- (UIView *)holderView {
    if (!_holderView) {
        _holderView = [UIView new];
        _holderView.backgroundColor = [UIColor clearColor];
    }
    return _holderView;
}

- (NSMutableArray *)itemsViewArray {
    if (!_itemsViewArray) {
        _itemsViewArray = [NSMutableArray array];
    }
    return _itemsViewArray;
}

- (UILabel *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = ({
            UILabel *label = [UILabel new];
            CGRect frame = [UIScreen mainScreen].bounds;
            label.frame = CGRectMake((CGRectGetWidth(frame)-80)/2.0, (CGRectGetHeight(frame) - 64 - 40)/2.0, 80, 40);
            label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            label.layer.cornerRadius = 8.0;
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.masksToBounds = YES;
            label;
        });
        [self.tableView.superview addSubview:_indicatorView];
    }
    return _indicatorView;
}

@end
