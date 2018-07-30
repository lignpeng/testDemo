//
//  GGPredicateViewController.m
//  testDemo
//
//  Created by lignpeng on 2017/7/24.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import "GGPredicateViewController.h"
#import "DataTools.h"
#import "HexColor.h"

@interface User : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, assign) NSInteger score;
@end

@implementation User

+ (instancetype)user:(NSString *)name type:(NSInteger )type {
    User *user = [User new];
    user.name = name;
    user.type = type;
    user.score = arc4random()%100;
    return user;
}

@end

@interface GGPredicateViewController ()

@property(nonatomic, strong) UITextView *textView;

@end

@implementation GGPredicateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat margin = 32;
    CGRect sframe = [UIScreen mainScreen].bounds;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(margin, margin * 3, CGRectGetWidth(sframe) - margin * 2, 42)];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"action" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWith8BitRedN:arc4random()%256 green:arc4random()%256 blue:arc4random()%256];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [self.view addSubview:button];
    CGRect bframe = button.frame;
    CGFloat y = CGRectGetHeight(bframe) + CGRectGetMinY(bframe) + margin * 0.25;
    self.textView.frame = (CGRect){margin * 0.5,y,CGRectGetWidth(sframe) - margin,CGRectGetHeight(sframe) - y - margin};
    [self.view addSubview:self.textView];
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.editable = NO;
        _textView.textAlignment = NSTextAlignmentLeft;
    }
    return _textView;
}

- (void)action {
//    [self objects];
//    [self strings];
    [self newAction];
}

- (void)newAction {
    NSMutableArray *array = [NSMutableArray array];
    NSUInteger index = 6;
    while (index > 0) {
        User *user =[User user:[NSString stringWithFormat:@"00%lu",(unsigned long)index] type:index];
        if (index % 2 == 0) {
            user.name = @"aa";
        }else {
            user.name = @"bb";
        }
        [array addObject:user];
        index--;
    }
    NSArray *sarray = [DataTools filterMaxItemsArray:array isStringObj:NO filterKey:@"name"];
    NSLog(@"%@",sarray);
    
    
    
    NSArray *array1 = @[@"2018-7-01",@"2018-7-02",@"2018-7-03",
                        @"2018-7-01",@"2018-7-02",@"2018-7-03",
                        @"2018-7-01",@"2018-7-02",@"2018-7-03",
                        @"2018-7-01",@"2018-7-02",@"2018-7-03",
                        @"2018-7-01",@"2018-7-02",@"2018-7-03",
                        @"2018-7-01",@"2018-7-02",@"2018-7-03",
                        @"2018-7-04",@"2018-7-06",@"2018-7-08",
                        @"2018-7-05",@"2018-7-07",@"2018-7-09"];
    NSArray *darray = [DataTools filterMaxItemsArray:array1 isStringObj:YES filterKey:nil];
    NSLog(@"%@",darray);
    self.textView.text = [sarray.description stringByAppendingFormat:@"\n%@", darray.description];
}

- (void)objects{
    NSMutableArray *array = [NSMutableArray array];
    NSUInteger index = 6;
    while (index > 0) {
        [array addObject:[User user:[NSString stringWithFormat:@"00%lu",(unsigned long)index] type:index]];
        index--;
    }
    
    User *user = nil;
    if ([user.name isEqualToString:@""]) {
        
    }
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type >= 3 or score >= 80"];
    //po predicate.predicateFormat: type >= 3 OR score >= 80
    NSArray *predicateArray = [array filteredArrayUsingPredicate:predicate];
    NSString *name = @"name";
    NSString *str = @"005";
    NSPredicate *predicate0 = [NSPredicate predicateWithFormat:@"%@ == %@",name,str];
    //po predicate1.predicateFormat:"name" == "005"，零个结果
    NSArray *predicateArray0 = [array filteredArrayUsingPredicate:predicate0];
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"self.%@ == %@",name,str];
    //po predicate1.predicateFormat:SELF."name" == "005"，1个结果
    NSArray *predicateArray1 = [array filteredArrayUsingPredicate:predicate1];
    
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"name == %@",str];
    //po predicate2.predicateFormat: name == "005"，有一个结果
    NSArray *predicateArray2 = [array filteredArrayUsingPredicate:predicate2];
    
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"name == \'005\'"];
    //po predicate3.predicateFormat: name == "005"，有一个结果
    NSArray *predicateArray3 = [array filteredArrayUsingPredicate:predicate3];
}

- (void)strings {
    NSArray *array = @[@"willback",@"backhome",@"goodmonring",@"gooDbyd"];
    NSString *str = @"good";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains[c] %@",str];
    NSArray *predicateArray = [array filteredArrayUsingPredicate:predicate];
    
    str = @"gooDbyd";
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"self == %@",str];
    //po predicate1 SELF == "gooDbyd"，有一个结果
    NSArray *predicateArray1 = [array filteredArrayUsingPredicate:predicate1];
}

@end
