//
//  ViewController.m
//  LWTDatePickerView
//
//  Created by liaowentao on 17/2/27.
//  Copyright © 2017年 Haochuang. All rights reserved.
//

#import "ViewController.h"
#import "LWTDatePickerView.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@property (assign,nonatomic)NSInteger minIndex;
@property (assign,nonatomic)NSInteger maxIndex;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _minIndex = 10;
    _maxIndex = 10;

    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)datePickShow:(UIButton *)sender {
    
    LWTDatePickerView *pickerView = [[LWTDatePickerView alloc] initWithPickerViewWithCenterTitle:@"选择期限" LimitMaxIndex:50];
    
    [pickerView pickerViewDidSelectRowWithLeftIndex:_minIndex andRightIndex:_maxIndex];
    
    [pickerView pickerVIewClickCancelBtnBlock:^{
        
        NSLog(@"取消");
        
    } sureBtClcik:^(NSInteger leftIndex, NSInteger rightIndex, NSString *leftAndRightString) {
        
        _dateLabel.text = leftAndRightString;
        _minIndex = leftIndex;
        _maxIndex = rightIndex;
        //
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
