//
//  IDViewController.m
//  testDemo
//
//  Created by genpeng on 16/11/28.
//  Copyright © 2016年 genpeng. All rights reserved.
//

#import "IDViewController.h"
#import "NSString+CSSafeAccess.h"

#define  Return_Message_common  CustomLocalizedString(@"服务器繁忙，请您稍后再试", nil)

@interface IDViewController ()

@end

@implementation IDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(120, 100, 120, 42)];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"Ok" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(string) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5.0;
    btn.clipsToBounds = YES;
}


- (void)string {
    NSInteger statusCode = 200;
    NSString *str = @"服务器繁忙，请您稍后再试";
////    NSString *userInfoValue = [str stringByAppendingFormat:@"[00%ld]",(long)statusCode];
//    NSString *ss = [Return_Message_common stringByAppendingFormat:@"[00%d]",statusCode];
//    NSLog(@"%@", userInfoValue);
}

- (BOOL)isPureNumbersWithString:(NSString *)string {
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    return string.length <= 0;
}

- (void)action {
    NSString *idStr = @"53262819820314783X";
    BOOL flage = [self CheckIsIdentityCard:idStr];
    NSLog(@"正确的id：%d",flage);
    
    flage = [self isPureIntWithString:idStr];
    NSLog(@"纯数字：%d",flage);
    idStr = @"532628198203147830";
    flage = [self isPureIntWithString:idStr];
    
    NSLog(@"纯数字：%d",flage);
    
    
    flage = [self CheckIsIdentityCard:idStr];
    NSLog(@"不正确的id：%d",flage);
    
    NSLog(@"============================");
    idStr = @"53262819820314783X";
    
    flage = [self isIdCard:idStr];
    
    NSLog(@"正确id：%d",flage);
    idStr = @"532628198203147830";
    flage = [self isIdCard:idStr];
    
    NSLog(@"不正确id：%d",flage);
    
    
    
}

#pragma mark  - xxxx
//身份证号
- (BOOL)CheckIsIdentityCard: (NSString *)identityCard {
    //判断是否为空
    if (identityCard==nil||identityCard.length <= 0) {
        return NO;
    }
    //判断是否是18位，末尾是否是x
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if(![identityCardPredicate evaluateWithObject:identityCard]){
        return NO;
    }
    //判断生日是否合法
    NSRange range = NSMakeRange(6,8);
    NSString *datestr = [identityCard substringWithRange:range];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyyMMdd"];
    if([formatter dateFromString:datestr]==nil){
        return NO;
    }
    
    //判断校验位
    if(identityCard.length==18)
    {
        NSArray *idCardWi= @[ @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2" ]; //将前17位加权因子保存在数组里
        NSArray * idCardY=@[ @"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2" ]; //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        int idCardWiSum=0; //用来保存前17位各自乖以加权因子后的总和
        for(int i=0;i<17;i++){
            idCardWiSum+=[[identityCard substringWithRange:NSMakeRange(i,1)] intValue]*[idCardWi[i] intValue];
        }
        int idCardMod=idCardWiSum%11;//计算出校验码所在数组的位置
        NSString *idCardLast=[identityCard substringWithRange:NSMakeRange(17,1)];//得到最后一位身份证号码
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2){
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]){
                return YES;
            }else{
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast intValue]==[idCardY[idCardMod] intValue]){
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
}

-(BOOL)isIdCard:(NSString *)identityCard{
    if (identityCard.length != 18) {
        return FALSE;
    }
    
    if (identityCard.length == 18) {
        NSString *checkNum = [identityCard cs_substringWithRange:NSMakeRange(0, 17)];
        NSString *check = [identityCard cs_substringWithRange:NSMakeRange(17, 1)];
        if (![self isPureIntWithString:checkNum]){
            return FALSE;
        }
        if (![self isPureIntWithString:checkNum] && ![check isEqualToString:@"X"] && ![check isEqualToString:@"x"])
        {
            return FALSE;
        }
        //规则校验
        int iCheck[18];
        NSString *num;
        for(int i=0; i<17;i++)
        {
            num = [identityCard cs_substringWithRange:NSMakeRange(i, 1)];
            iCheck[i] = [num intValue];
        }
        int iYear = iCheck[6]*10 + iCheck[7];
        if (iYear < 19 || iYear >20)
        {
            return FALSE;
        }
        int iMonth = iCheck[10]*10 + iCheck[11];
        if (iMonth <= 0 || iMonth >12) {
            return FALSE;
        }
        int iDay = iCheck[12]*10 + iCheck[13];
        if (iDay <= 0 || iDay > 31) {
            return FALSE;
        }
    }
    //规则校验
    return YES;
}

-(BOOL)isPureIntWithString:(NSString *)str{
    /*
     NSScanner* scan = [NSScanner scannerWithString:string];
     int val;
     return[scan scanInt:&val] && [scan isAtEnd];
     
     char tmp[128];
     memset(tmp, 0, 128);
     strcpy(tmp, [self UTF8String]);
     */
    for (int i=0; i<str.length; i++) {
        unichar c = [str characterAtIndex:i];
        if (c<'0' || c > '9') {
            return NO;
        }
    }
    return YES;
}



@end
