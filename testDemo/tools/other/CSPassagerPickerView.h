//


#import <UIKit/UIKit.h>



@interface CSPassagerPickerView : UIView

//@property (nonatomic,copy) PassagerNumberBlock numberBlock;

//+(instancetype)pickerView;

/**
 弹出pickerview
 */
//-(void)showPickerView;

+ passagerPickerViewSelectBlock:(void(^)(NSMutableArray *numberArrs))selectBlock;

@end
