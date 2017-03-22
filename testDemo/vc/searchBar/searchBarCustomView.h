//
//  searchBarCustomView.h
//  airport
//
//  Created by jinchangwang on 15/7/28.
//  Copyright (c) 2015年 jinchangwang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum: NSUInteger {
    SearchBuild,
    SearchPOI,
} SearchType;

@protocol searchBarCustomViewDelegate;

@interface searchBarCustomView : NSObject

//@property (nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic, strong) UISearchController *searchController;
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) UIViewController *ctl;
@property (nonatomic,strong) NSString *placeholder;
@property (nonatomic,weak) id<searchBarCustomViewDelegate>delegate;

@end

@protocol searchBarCustomViewDelegate <NSObject>

- (void) selectBuild:(NSString*)str;
@optional
@end
