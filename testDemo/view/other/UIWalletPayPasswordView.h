//
//  UIWalletPayPasswordView.h
//
//  Created by lignpeng on 2018年12月12日.
//
/*
密码框
 
 */


#import <UIKit/UIKit.h>

typedef void(^WalletPayPasswordBlock)(NSString *string);

@interface UIWalletPayPasswordView : UIViewController

@property(nonatomic, assign) NSInteger inputTime;

@property(nonatomic, copy) WalletPayPasswordBlock complishBlock;

+ (instancetype)walletPayPasswordView;
+ (instancetype)walletPayPasswordView:(void(^)(NSString *string))complishBlock;

//+ (void)dissmiss;

+ (instancetype)walletPayPasswordView:(void(^)(NSString *string))complishBlock forgetPassword:(void(^)(void))forgetPasswordBlock;
- (void)updateView:(BOOL)hasError inputTime:(NSInteger)time;
- (void)updateView:(BOOL)hasError errorStr:(NSString *)errorStr;
- (void)dismiss;

@end
