
#import "CSManagerTest.h"
#import <objc/runtime.h>
#import <objc/objc.h>
#import <UIKit/UIKit.h>

#define kPhoneX ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)
#define kNavigationBarAndStatusBar_HEIGHT (kPhoneX ? 88 : 64)

#define viewRowHeight 30

@interface CSManagerTest ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic, assign) CGFloat rightMargin;
@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat topMargin;
@property (nonatomic, assign) CGFloat bottomMargin;
@property (nonatomic, assign) CGMutablePathRef pathRef;
@property (nonatomic, strong) UIButton *toolButton;

@property(nonatomic, strong) UITableView *tableview;
@property(nonatomic, strong) NSDictionary *dataSource;
@property(nonatomic, assign) BOOL isShow;
@end

@implementation CSManagerTest

+ (void)load {
    if (!CSManagerTestIsOpen) {
        return;
    }
    
#ifdef DEBUG
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunchingNotification:) name:UIApplicationDidFinishLaunchingNotification object:nil];
#endif
}

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (NSDictionary *)dataSource {
    NSDictionary *dic = @{@"国内乘机人":@"yudingliuDomPassanger"};
    return dic;
}

+ (void)actions {
        //    [self yudingliuDomPassanger];
        //    [self yudingliuIntPassanger];
        //    [self passenger];
    [[self sharedInstance] actionshow];
}

- (void)actionshow {
    if (!self.isShow) {
        [self dismissTableView];
        return;
    }
    [self showTableView];
}

- (void)dismissTableView {
    [self.tableview removeFromSuperview];
    self.isShow = !self.isShow;
}

- (void)showTableView {
    self.isShow = !self.isShow;
    CGRect bframe = self.toolButton.frame;
    bframe.origin.y += CGRectGetHeight(bframe);
    bframe.size.height = viewRowHeight * self.dataSource.count;
    self.tableview.frame = bframe;
    [[UIApplication sharedApplication].keyWindow addSubview:self.tableview];
    [self.tableview reloadData];
}

//弹出
+ (void)showRegisterViewController {
    UIViewController *currentvc = [self getCurrentViewController];
//    [currentvc.navigationController pushViewController:vc animated:YES];
}


+ (UIViewController *)getCurrentViewController {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        //app默认windowLevel是UIWindowLevelNormal，如果不是，找到它
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    id nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
        //1、通过present弹出VC，appRootVC.presentedViewController不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
            //2、通过navigationcontroller弹出VC
        NSLog(@"subviews == %@",[window subviews]);
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
        //1、tabBarController
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
            //或者 UINavigationController * nav = tabbar.selectedViewController;
        result = nav.childViewControllers.lastObject;
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
            //2、navigationController
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{//3、viewControler
        result = nextResponder;
    }
    return result;
}

+ (void)applicationDidFinishLaunchingNotification:(NSNotification *)notice{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 70 - 20, kNavigationBarAndStatusBar_HEIGHT + 20, 86, viewRowHeight-5)];
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:11];
    [btn setTitle:@"功能测试入口" forState:UIControlStateNormal];
    [[UIApplication sharedApplication].keyWindow addSubview:btn];
    
    [btn addTarget:self action:@selector(actions) forControlEvents:UIControlEventTouchUpInside];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:[self sharedInstance] action:@selector(handlePan:)];
    [btn addGestureRecognizer:pan];
    CSManagerTest *test = [self sharedInstance];
    test.toolButton = btn;
    test.rightMargin = [UIScreen mainScreen].bounds.size.width-30;
    test.leftMargin = 30;
    test.bottomMargin = [UIScreen mainScreen].bounds.size.height-30-50;
    test.topMargin = 30+64;
}

- (void)dealloc {
#ifdef DEBUG
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#endif
}

+ (void)classMethodList:(Class)aClass {
    u_int count;
    
    Method * methods = class_copyMethodList(aClass,&count);
    
    for(int i = 0;i < count; i++) {
        Method method = methods[i];
        
        NSString *methodName = [NSString stringWithUTF8String:sel_getName(method_getName(method))];
        NSString *methodType = [NSString stringWithUTF8String:method_getTypeEncoding(method)];
        NSString *methodArgs = @(method_getNumberOfArguments(method)).stringValue;
        
        NSLog(@"[%d]methodName : %@", i, methodName);
        
//        IMP imp = method_getImplementation(method);
//        imp();
    }
    free(methods);
}

#pragma mark - 手势
- (void)handlePan:(UIPanGestureRecognizer *)pan {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        self.beginPoint = [pan locationInView:window];
    }else if (pan.state == UIGestureRecognizerStateChanged){
        
        CGPoint nowPoint = [pan locationInView:window];
        
        float offsetX = nowPoint.x - self.beginPoint.x;
        float offsetY = nowPoint.y - self.beginPoint.y;
        CGPoint centerPoint = CGPointMake(self.beginPoint.x + offsetX, self.beginPoint.y + offsetY);
        
        if (CGPathContainsPoint(self.pathRef, NULL, centerPoint, NO)) {
            self.toolButton.center = centerPoint;
        }else {
            if (centerPoint.y > self.bottomMargin) {
                if (centerPoint.x < self.rightMargin && centerPoint.x > self.leftMargin) {
                    self.toolButton.center = CGPointMake(self.beginPoint.x + offsetX, self.bottomMargin);
                }
            } else if (centerPoint.y < self.topMargin) {
                if (centerPoint.x < self.rightMargin && centerPoint.x>self.leftMargin) {
                    self.toolButton.center = CGPointMake(self.beginPoint.x + offsetX, self.topMargin);
                }
            } else if (centerPoint.x>self.rightMargin) {
                self.toolButton.center = CGPointMake(self.rightMargin, self.beginPoint.y + offsetY);
            } else if (centerPoint.x<self.leftMargin) {
                self.toolButton.center = CGPointMake(self.leftMargin, self.beginPoint.y + offsetY);
            }else {
                self.toolButton.center = centerPoint;
            }
        }
    }else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateFailed){
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    NSArray *titlearray = [self.dataSource allKeys];
    cell.textLabel.text = titlearray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:11];
    cell.textLabel.textColor = [UIColor darkTextColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key = [self.dataSource allKeys][indexPath.row];
    NSString *method = [self.dataSource objectForKey:key];
    SEL selection = NSSelectorFromString(method);
    if ([self respondsToSelector:selection]) {
        [self performSelector:selection];
        [self dismissTableView];
    }else if ([[self class] respondsToSelector:selection]) {
        [[self class] performSelector:selection];
        [self dismissTableView];
    }
    
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [UITableView new];
        _tableview.backgroundColor = [UIColor whiteColor];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableHeaderView = [UIView new];
        _tableview.tableFooterView = [UIView new];
        [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
        _tableview.rowHeight = viewRowHeight;
    }
    return _tableview;
}

@end
