//
//  IDViewController.m
//  testDemo
//
//  Created by genpeng on 16/11/28.
//  Copyright © 2016年 genpeng. All rights reserved.
//

#import "IDViewController.h"
#import "NSString+CSSafeAccess.h"
#import "GPTools.h"
#define  Return_Message_common  CustomLocalizedString(@"服务器繁忙，请您稍后再试", nil)

@interface IDViewController ()

@property(nonatomic, strong) UITextField *textField;

@end

@implementation IDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat comm = 16;
    CGRect tframe = (CGRect){comm,64 + comm ,CGRectGetWidth(frame) - comm * 2,comm * 2};
    self.textField = ({
        UITextField *textField = [[UITextField alloc] initWithFrame:tframe];
        textField.font = [UIFont systemFontOfSize:14];
        textField.layer.borderWidth = 1;
        textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textField.placeholder = @"身份证";
        textField.layer.cornerRadius = 3.0;
        textField.clipsToBounds = YES;
        [self.view addSubview:textField];
        textField;
    });
    CGFloat buttonWidth = 120;
    CGFloat buttonHigth = 42;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(frame) - buttonWidth) * 0.5, CGRectGetHeight(tframe) + CGRectGetMinY(tframe) + comm, buttonWidth, buttonHigth)];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"验证" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5.0;
    btn.clipsToBounds = YES;
}


- (void)string {
//    NSInteger statusCode = 200;
//    NSString *str = @"服务器繁忙，请您稍后再试";
////    NSString *userInfoValue = [str stringByAppendingFormat:@"[00%ld]",(long)statusCode];
//    NSString *ss = [Return_Message_common stringByAppendingFormat:@"[00%d]",statusCode];
//    NSLog(@"%@", userInfoValue);
}

- (BOOL)isPureNumbersWithString:(NSString *)string {
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    return string.length <= 0;
}

- (void)action {
    [GPTools ShowAlert:@""];
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

//----------------
/**
 校验身份证
 
 @param sPaperId 身份证
 @return true 校验通过 false 校验失败
 */
BOOL checkIDCard(NSString *sPaperId){
    //判断位数
    if (sPaperId.length != 15 && sPaperId.length != 18) {
        return false;
    }
    NSString *carid = sPaperId;
    
    long lSumQT = 0 ;
    //加权因子
    int R[] = {7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2};
    //校验码
    unsigned char sChecker[11] = {'1','0','X','9','8','7','6','5','4','3','2'};
    //将15位身份证号转换为18位
    NSMutableString *mString = [NSMutableString stringWithString:sPaperId];
    if (sPaperId.length == 15) {
        [mString insertString:@"19" atIndex:6];
        long p =0;
        for (int i =0; i<17; i++){
            NSString * s = [mString substringWithRange:NSMakeRange(i, 1)];
            p += [s intValue] * R[i];
        }
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
    }
    
    //判断地区码
    NSString *sProvince = [carid substringToIndex:2];
    NSInteger provinceNum = sProvince.integerValue;
    
    if (!isAreaCode([NSNumber numberWithInteger:provinceNum])) {
        //        [MBProgressHUD showError:@"证件号开头不正确"];
        return false ;
    }
    //判断年月日是否有效
    //年份
    int strYear = getStringWithRange(carid,6,4);
    //月份
    int strMonth = getStringWithRange(carid,10,2);
    //日
    int strDay = getStringWithRange(carid,12,2);
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    if (date == nil) {
        //        [MBProgressHUD showError:@"出生日期不正确"];
        return false;
    }
    const char *PaperId = [carid UTF8String];
    //检验长度
    if (18!=strlen(PaperId)) {
        //        [MBProgressHUD showError:@"请输入正确的证件号"];
        return false;
    }
    //校验数字
    NSString * lst = [carid substringFromIndex:carid.length-1];
    char di = [carid characterAtIndex:carid.length-1];
    if (!isdigit(di)) {
        if ([lst isEqualToString:@"X"]) {
        }else{
            //            [MBProgressHUD showError:@"请输入正确的证件号"];
            return false;
        }
    }
    //验证最末的校验码
    lSumQT = 0;
    for (int i = 0; i<17; i++){
        NSString * s = [carid substringWithRange:NSMakeRange(i, 1)];
        NSLog(@"%d",[s intValue]);
        lSumQT += [s intValue] * R[i];
    }
    if (sChecker[lSumQT%11] != PaperId[17]) {
        //        [MBProgressHUD showError:@"请输入正确的证件号"];
        return false;
    }
    return true;
}
/**
 截取身份证数字
 
 @param cardId 待截取字符串
 @param startLocation 开始截取位置
 @param length 截取长度
 @return 截取到的身份证数字
 */
int getStringWithRange(NSString *cardId,int startLocation, int length){
    return [[cardId substringWithRange:NSMakeRange(startLocation, length)] intValue];
}

/**
 检验身份证上面地区
 
 @param province 省份
 @return true 校验通过 false 校验失败
 */
BOOL isAreaCode(NSNumber *province){
    //在provinceArr中找
    NSDictionary * dict = provinceDict();
    NSArray *arr = [dict allKeys];
    int a = 0;
    for (NSNumber * pr in arr) {
        if ([pr isEqualToNumber:province]) {
            a ++;
        }
    }
    if (a == 0) {
        return false;
    } else {
        return true;
    }
}

/**
省份信息
*/
NSDictionary *provinceDict(){
    NSDictionary *pDict = @{
                            @11:@"北京市",//|110000，
                            @12:@"天津市",//|120000，
                            @13:@"河北省",//|130000，
                            @14:@"山西省",//|140000，
                            @15:@"内蒙古自治区",//|150000，
                            @21:@"辽宁省",//|210000，
                            @22:@"吉林省",//|220000，
                            @23:@"黑龙江省",//|230000，
                            @31:@"上海市",//|310000，
                            @32:@"江苏省",//|320000，
                            @33:@"浙江省",//|330000，
                            @34:@"安徽省",//|340000，
                            @35:@"福建省",//|350000，
                            @36:@"江西省",//|360000，
                            @37:@"山东省",//|370000，
                            @41:@"河南省",//|410000，
                            @42:@"湖北省",//|420000，
                            @43:@"湖南省",//430000，
                            @44:@"广东省",//440000，
                            @45:@"广西壮族自治区",//450000，
                            @46:@"海南省",//460000，
                            @50:@"重庆市",//500000，
                            @51:@"四川省",//510000，
                            @52:@"贵州省",//520000，
                            @53:@"云南省",//530000，
                            @54:@"西藏自治区",//540000，
                            @61:@"陕西省",//610000，
                            @62:@"甘肃省",//620000，
                            @63:@"青海省",//630000，
                            @64:@"宁夏回族自治区",//640000，
                            @65:@"新疆维吾尔自治区",//650000，
                            @71:@"台湾省（886)",//710000,
                            @81:@"香港特别行政区（852)",//810000，
                            @82:@"澳门特别行政区（853)",//820000
                            @91:@"国外"
                            };
    return pDict;
}



@end
