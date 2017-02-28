# LWTDatePickerView
simpleness pickerView   
![img](http://ok841h9gr.bkt.clouddn.com/%E6%97%A5%E6%9C%9F%E9%80%89%E6%8B%A9%E5%99%A8.gif)
### show The PickerView
```
    LWTDatePickerView *pickerView = [[LWTDatePickerView alloc] initWithPickerViewWithCenterTitle:@"选择期限" LimitMaxIndex:50];
```
### select The date
```    
    [pickerView pickerViewDidSelectRowWithLeftIndex:_minIndex andRightIndex:_maxIndex];
```
### pickerView click   
```
    [pickerView pickerVIewClickCancelBtnBlock:^{
        
        NSLog(@"=====clickTheCancel=======");
        
    } sureBtClcik:^(NSInteger leftIndex, NSInteger rightIndex, NSString *leftAndRightString) {
        
        _dateLabel.text = leftAndRightString;
        _minIndex = leftIndex;
        _maxIndex = rightIndex;
        //
    }];
```
