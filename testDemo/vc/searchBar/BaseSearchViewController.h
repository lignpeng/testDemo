//
//  BaseSearchViewController.h
//  testDemo
//
//  Created by lignpeng on 17/1/11.
//  Copyright © 2017年 genpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseSearchViewController : UIViewController

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UISearchController *searchController;
@property(nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic,strong) UIButton *backgroundView;
@property(nonatomic, strong) NSString *placeHolder;

@end
