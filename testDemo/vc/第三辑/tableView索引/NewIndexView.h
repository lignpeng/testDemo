//
//  IndexView.h

#import <UIKit/UIKit.h>

//代理方法
@protocol NewIndexViewDelegate <NSObject>

@required
//当前选中下标
- (void)selectedSectionIndexTitle:(NSString *_Nullable)title atIndex:(NSInteger)index;
//组标题数组
- (NSArray<NSString *> *_Nullable)sectionIndexTitles;

@end

@interface NewIndexView : UIView
//这几个属性不设置，将采用默认值
@property (nonatomic, assign) CGFloat titleFontSize;  //字体大小
@property (nonatomic, strong) UIColor *titleColor;//字体颜色
@property (nonatomic, assign) CGFloat itemSpace;//文字间距
@property (nonatomic, assign) CGFloat offset;//索引距离top边的间距

+ (instancetype)indexViewWithFrame:(CGRect)frame tableView:(UITableView *)tableView delegate:(id<NewIndexViewDelegate>)delegate;
/*
 tableview是按照整个手机屏幕来计算visibleCells，如果tableView的frame没有屏幕大的话，
 比如有导航栏，这部分也是visible的，会计算到cell
 如果取第一个visiblecell的话，如果这个cell高度比较小，小于导航栏高度，实际上是没有显示出来的
 因此，需要动态获取cell
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView navigationHeight:(CGFloat)height;
- (void)reload;

//设置背景色，点击或滑动的时候显示，默认是透明的
- (void)showBackColor:(UIColor *)backColor;
//是否显示提示view，默认不显示，YES：显示默认的indicatorview
- (void)showIndicatorView:(BOOL)isShow;
//显示自定义indicatorView；如果传入自定义indicatorView注意避免循环引用
- (void)configIndicatorView:(UIView *)indicatorView touchBlock:(void(^)(NSString *title))touchBlock;

@end
