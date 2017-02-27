//
//  LWTDatePickerView.m
//  LWTProgressView
//
//  Created by liaowentao on 17/2/23.
//  Copyright © 2017年 Haochuang. All rights reserved.
//

#import "LWTDatePickerView.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define TopViewHeight 40
#define BottomHeight 40
#define ContainerWidth SCREEN_WIDTH * 0.7
#define ContainerHeight SCREEN_WIDTH * 0.7
#define PickerViewBackGroundColor [UIColor orangeColor]
#define LineWidth 0.5f
#define LineColor [UIColor blackColor]
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

@interface LWTDatePickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic)NSMutableArray *dateArray;
@property (nonatomic,strong)UIPickerView *datePickView;
@property (nonatomic,strong)UIView *topView;
//组合view
@property (nonatomic,strong) UIView *containerView;
//选择的左边和右边索引
@property (copy, nonatomic) NSString *string1;
@property (copy, nonatomic) NSString *string2;
@property (assign, nonatomic)NSInteger index1;
@property (assign, nonatomic)NSInteger index2;
//弹框标题
@property (copy,nonatomic)NSString *titleString;
//最大选择期限
@property (assign,nonatomic)NSInteger maxLimitIndex;
@end

@implementation  LWTDatePickerView

- (NSMutableArray *)dateArray {
    
    if (_dateArray == nil) {
        _dateArray = [NSMutableArray array];
        for (int i = 0; i <= self.maxLimitIndex; i ++) {
            NSString *motnthDate = [NSString stringWithFormat:@"%d天",i];
            [_dateArray addObject:motnthDate];
        }
    }
    return _dateArray;
}


- (UIPickerView *)pickerViewLoanLine {
    
    if (_datePickView == nil) {
        _datePickView = [[UIPickerView alloc] init];
        _datePickView.backgroundColor=[UIColor whiteColor];
        _datePickView.delegate = self;
        _datePickView.dataSource = self;
        _datePickView.frame = CGRectMake(0, TopViewHeight, ContainerWidth, ContainerHeight - TopViewHeight - BottomHeight);
        
    }
    return _datePickView;
}

- (UIView *)topView {
    
    if (_topView == nil) {
        
        _topView =[[UIView alloc] init];
        _topView.frame = CGRectMake(0, 0, ContainerWidth, TopViewHeight);
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,ContainerWidth, TopViewHeight)];
        lable.backgroundColor = [UIColor orangeColor];
        lable.text = _titleString;
        lable.textAlignment = 1;
        lable.textColor = [UIColor whiteColor];
        lable.numberOfLines = 1;
        lable.font = [UIFont systemFontOfSize:15];
        [_topView addSubview:lable];
        
    }
    
    return _topView;
}

- (UIView *)containerView {
    
    if (_containerView == nil) {
        
        _containerView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - ContainerWidth)/2.0, SCREEN_HEIGHT * 0.26, ContainerWidth,ContainerHeight)];
        _containerView.backgroundColor = [UIColor whiteColor];
        
        [_containerView addSubview:self.topView];
        [_containerView addSubview:self.pickerViewLoanLine];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0,ContainerHeight - BottomHeight - LineWidth,ContainerWidth, LineWidth)];
        lineView1.backgroundColor = PickerViewBackGroundColor;
        [_containerView addSubview:lineView1];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(ContainerWidth * 0.5 - LineWidth,  ContainerHeight - BottomHeight, LineWidth, BottomHeight)];
        lineView2.backgroundColor = PickerViewBackGroundColor;
        [_containerView addSubview:lineView2];
        
        //取消按钮
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.backgroundColor = [UIColor clearColor];
        cancelBtn.frame = CGRectMake(0, ContainerHeight - BottomHeight, ContainerWidth * 0.5, BottomHeight);
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        cancelBtn.layer.cornerRadius = 2;
        cancelBtn.backgroundColor = [UIColor clearColor];
        cancelBtn.layer.masksToBounds = YES;
        [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:cancelBtn];
        
        //确定按钮
        UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseBtn.backgroundColor = [UIColor clearColor];
        chooseBtn.frame = CGRectMake(ContainerWidth * 0.5, ContainerHeight - BottomHeight, ContainerWidth * 0.5, BottomHeight);
        chooseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        chooseBtn.layer.cornerRadius = 2;
        chooseBtn.layer.masksToBounds = YES;
        [chooseBtn setTitleColor:PickerViewBackGroundColor forState:UIControlStateNormal];
        [chooseBtn setTitle:@"确定" forState:UIControlStateNormal];
        [chooseBtn addTarget:self action:@selector(doneItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:chooseBtn];
    }
    return _containerView;
    
}

- (instancetype)initWithPickerViewWithCenterTitle:(NSString *)title  LimitMaxIndex:(NSInteger)limitMaxIndex{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.titleString = title;
        self.string1 = [NSString stringWithFormat:@"%d天",0];
        self.string2 = [NSString stringWithFormat:@"%d天",0];
        self.maxLimitIndex = limitMaxIndex;
        [self addSubview:self.containerView];
        UIWindow *currentWindows = [UIApplication sharedApplication].keyWindow;
        self.backgroundColor = UIColorFromRGBWithAlpha(0x111111, 0.7);
        [currentWindows addSubview:self];
    }
    
    return self;
}

- (void)pickerVIewClickCancelBtnBlock:(clickCancelBtn)cancelBlock
                          sureBtClcik:(clickSureBtn)sureBlock {
    
    self.clickCancelBtn = cancelBlock;
    
    self.clickSureBtn = sureBlock;
    
}

//滚动到特定行数
- (void)pickerViewDidSelectRowWithLeftIndex:(NSInteger)leftIndex andRightIndex:(NSInteger)rightIndex
{
    self.string1 = [NSString stringWithFormat:@"%ld天",leftIndex];
    self.string2 = [NSString stringWithFormat:@"%ld天",rightIndex];
    self.index1 = leftIndex;
    self.index2 = rightIndex;
    [self.pickerViewLoanLine selectRow:self.index1 inComponent:0 animated:YES];
    [self.pickerViewLoanLine selectRow:self.index2 inComponent:2 animated:YES];
}

//点击取消按钮
- (void)remove:(UIButton *) btn {
    
    if (self.clickCancelBtn) {
        
        self.clickCancelBtn();
        
    }
    [self dissMissView];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dissMissView];
}
- (void)dissMissView{
    
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.containerView.frame = CGRectMake((SCREEN_WIDTH - SCREEN_WIDTH * 0.7)/2.0, SCREEN_HEIGHT, SCREEN_WIDTH * 0.7,  SCREEN_WIDTH * 0.7);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//点击确定按钮
- (void)doneItemClick:(UIButton *) btn {
    
    NSString *leftAndRightString = nil;
    
    if (self.index1 > self.index2) {
        
        
    } else if (self.index1 == self.index2 ) {
        
        leftAndRightString = [NSString stringWithFormat:@"%@",self.string2];
        
    }else {
        
        leftAndRightString = [NSString stringWithFormat:@"%@~%@",self.string1,self.string2];
        
    }
    
    if (self.clickSureBtn) {
        
        self.clickSureBtn(_index1,_index2,leftAndRightString);
        
    }
    
    [self dissMissView];
}



#pragma pickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        
        return self.dateArray.count;
        
    } else if (component == 1) {
        
        return 1;
        
    } else {
        
        return self.dateArray.count;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            
            return  self.dateArray[row];
            
            break;
            
        case 1:
            
            return  @"~";
            
            break;
        case 2:
            
            return  self.dateArray[row];
            
            break;
            
        default:
            return nil;
    }
    
}

// 选中某一组中的某一行时调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *selStr = self.dateArray[row];
    
    switch(component) {
        case 0:
            
            self.string1 = selStr;
            
            self.index1 = [self.dateArray indexOfObject:selStr];
            
            if (self.index1 < self.index2) {
                
            } else {
                
                [self.pickerViewLoanLine selectRow:row inComponent:2 animated:YES];
                self.index2 = self.index1;
                
                self.string2 = self.string1;
            }
            
            break;
            
        case 2:
            
            self.string2 = selStr;
            
            self.index2 = [self.dateArray indexOfObject:selStr];
            
            if (self.index2 < self.index1) {
                
                [self.pickerViewLoanLine selectRow:self.index1 inComponent:2 animated:YES];
                
                self.string2 = self.dateArray[self.index1];
                
                self.index2 = self.index1;
                
            } else {
                
                self.string2 = self.dateArray[self.index2];
                
            }
            
        default:
            break;
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    //隐藏中间的上下两条线
//    if (_datePickView.subviews.count >= 2) {
//        ((UIView *)[_pickerViewLoanLine.subviews objectAtIndex:1]).hidden = YES;
//        ((UIView *)[_pickerViewLoanLine.subviews objectAtIndex:2]).hidden = YES;
//    }
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.font = [UIFont systemFontOfSize:16];
        pickerLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
    }
    switch (component) {
        case 0:
            [pickerLabel setTextAlignment:NSTextAlignmentRight];
            break;
        case 1:
            [pickerLabel setTextAlignment:NSTextAlignmentCenter];
            break;
        case 2:
            [pickerLabel setTextAlignment:NSTextAlignmentLeft];
            break;
        default:
            break;
    }    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
