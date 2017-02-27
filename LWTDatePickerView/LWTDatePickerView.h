//
//  LWTDatePickerView.h
//  LWTProgressView
//
//  Created by liaowentao on 17/2/23.
//  Copyright © 2017年 Haochuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWTDatePickerView : UIView

typedef void(^clickCancelBtn)();

typedef void(^clickSureBtn)(NSInteger leftIndex,NSInteger rightIndex,NSString *leftAndRightString);

@property (copy,nonatomic) void(^clickCancelBtn)();
@property (copy,nonatomic) void (^clickSureBtn)(NSInteger leftIndex,NSInteger rightIndex,NSString *leftAndRightString);

- (instancetype)initWithPickerViewWithCenterTitle:(NSString *)title  LimitMaxIndex:(NSInteger)limitMaxIndex;

//按钮点击
- (void)pickerVIewClickCancelBtnBlock:(clickCancelBtn)cancelBlock
                          sureBtClcik:(clickSureBtn)sureBlock;
//滚动到特定行数
- (void)pickerViewDidSelectRowWithLeftIndex:(NSInteger)leftIndex andRightIndex:(NSInteger)rightIndex;
@end
