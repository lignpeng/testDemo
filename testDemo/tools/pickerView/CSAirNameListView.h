//
//  CSAirNameListView.h
//
//  Created by lignpeng on 2017/7/26.
//

#import <UIKit/UIKit.h>

typedef void(^AirNameListBlock)(NSInteger index, NSString *name);

@interface CSAirNameListView : UIView

@property(nonatomic, copy) AirNameListBlock complishBlock;

@property (nonatomic, assign) NSInteger selectRow;

+ (instancetype)airNameListView;

+ (instancetype)airNameListView:(void(^)(NSInteger index, NSString *name))complishBlock;

+ (instancetype)airNameListView:(NSArray *)dataSource complish:(void(^)(NSInteger index, NSString *name))complishBlock;

+ (instancetype)airNameListView:(NSArray *)dataSource selectedIndex:(NSInteger )selectedIndex complish:(void(^)(NSInteger index, NSString *name))complishBlock;

//用于字典数据，key：表示要显示数据的key名称
+ (instancetype)airNameListView:(NSArray *)dataSource key:(NSString *)key selectedIndex:(NSInteger )selectedIndex complish:(void(^)(NSInteger index, NSString *name))complishBlock;

+ (void)dissmiss;

@end
