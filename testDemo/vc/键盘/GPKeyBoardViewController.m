

#import "GPKeyBoardViewController.h"
#import "GPKeyBoardHeaderTableView.h"
#import "GPKeyBoardTableViewCell.h"
#define cellIdentify @"cellReuse"

@interface GPKeyBoardViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UILabel *orderInfoLabel;
@property(nonatomic, strong) GPKeyBoardHeaderTableView *headerView;
@property(nonatomic, assign) BOOL allSelected;
@property(nonatomic, strong) UITextField *inputPasswordTextField;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) NSArray *dataSource;

@end

@implementation GPKeyBoardViewController

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@"",@"",@"",@"",@""];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self addNoticeForKeyboard];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHiden:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}
#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat offset =  CGRectGetHeight(self.view.frame) - (CGRectGetMinY(self.scrollView.frame) + CGRectGetHeight(self.scrollView.frame)) - kbHeight;
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if(offset > 0) {
        return;
    }
    [UIView animateWithDuration:duration animations:^{
        self.scrollView.contentOffset = CGPointMake(0, -offset + 18);
    }];
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
}

- (void)keyboardHiden:(UITapGestureRecognizer*)tap {
    [self.view endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"PAY", @"支付");
    self.allSelected = NO;//默认不选择
    CGRect frame = [UIScreen mainScreen].bounds;
    
    //订单号
    NSString *orderNoString = @"xxxxxxx";
    self.orderInfoLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(frame), 45)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14.0];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentLeft;
        label.text = orderNoString;
        label.backgroundColor = [UIColor colorWithRed:77.0/255.0 green:176.0/255.0 blue:252.0/255.0 alpha:1.0];
        label;
    });
    [self.view addSubview:self.orderInfoLabel];
    
    frame.origin.y += CGRectGetHeight(self.orderInfoLabel.frame) + CGRectGetMinY(self.orderInfoLabel.frame);
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    [self.view addSubview:self.scrollView];
    
    CGRect hframe = CGRectMake(0, 0, CGRectGetWidth(frame), 0);
//    self.headerView = [GPKeyBoardHeaderTableView createWalletHeaderTableView];
//    self.headerView.frame = hframe;

//    [self.scrollView addSubview:self.headerView];
    
    CGFloat commonYGap = 16;
    CGFloat commonXGap = 32;
    CGFloat labelHeight = 30; // label高度
    CGFloat labelWidth = 100;
    CGFloat buttonHeight = 42;//支付按钮的高度
    CGFloat tableViewHieght = CGRectGetHeight(frame) - CGRectGetMinY(frame) - CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) - CGRectGetHeight(self.navigationController.navigationBar.frame) - CGRectGetHeight(hframe)- labelHeight - buttonHeight - commonYGap *(1 + 1 + 1);//120 * 2;//展示两条代金券
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(hframe) + CGRectGetHeight(hframe), CGRectGetWidth(frame), tableViewHieght)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    [self.tableView registerNib:[UINib  nibWithNibName:@"GPKeyBoardTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentify];
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//不要下划线
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 126;
    self.tableView.tableHeaderView = [GPKeyBoardHeaderTableView createWalletHeaderTableView];;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 10)];
    [self.scrollView addSubview:self.tableView];
    
    CGRect labelFrame = CGRectMake(commonXGap, CGRectGetMinY(self.tableView.frame) + CGRectGetHeight(self.tableView.frame) + commonYGap, labelWidth, labelHeight);
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:labelFrame];
    moneyLabel.text = @"钱包支付密码：";
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:moneyLabel];
    
    labelFrame.origin.x += labelWidth;
    labelFrame.size.width = CGRectGetWidth(frame) - CGRectGetMinX(labelFrame) - commonXGap;
    //密码输入框
    self.inputPasswordTextField = ({
        UITextField *textField = [[UITextField alloc] initWithFrame:labelFrame];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.placeholder = @"请输入支付密码";
        textField.delegate = self;
        textField.font = [UIFont systemFontOfSize:14];
        textField.contentMode = UIViewContentModeCenter;
        textField.secureTextEntry = YES;
        textField.backgroundColor = [UIColor clearColor];
        textField.layer.borderWidth = 1;
        textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textField.layer.cornerRadius = 3.0;
        textField.clipsToBounds = YES;
        textField;
    });

    [self.scrollView addSubview:self.inputPasswordTextField];
    
    //支付按钮
    UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(commonYGap * 0.5, CGRectGetMinY(labelFrame) + labelHeight + commonYGap, CGRectGetWidth(frame) - commonYGap, buttonHeight)];
    [payButton setTitle:@"支付" forState:UIControlStateNormal];
    payButton.backgroundColor = [UIColor colorWithRed:253.0/255.0 green:153.0/255.0 blue:46.0/255.0 alpha:1.0];
    payButton.titleLabel.textColor = [UIColor whiteColor];
    payButton.layer.cornerRadius = 3.0;
    payButton.clipsToBounds = YES;
    [payButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:payButton];
    CGRect sframe = self.scrollView.frame;
    sframe.size.height = CGRectGetMinY(payButton.frame) + CGRectGetHeight(payButton.frame);
    self.scrollView.frame = sframe;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(frame), CGRectGetMinY(payButton.frame) + CGRectGetHeight(payButton.frame));
}

#pragma mark - 支付操作
- (void)payAction:(UIButton *)button {
    [self.view endEditing:YES];
    if (self.inputPasswordTextField.text.length <= 0) {
//        CSAlert(@"请输入支付密码");
        return;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GPKeyBoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if(!cell){
        cell = [[NSBundle mainBundle] loadNibNamed:@"GPKeyBoardTableViewCell" owner:nil options:nil].firstObject;
    }

//    [cell configCashCouponsCellWithCashCouponModel:self.cashCoupons[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
