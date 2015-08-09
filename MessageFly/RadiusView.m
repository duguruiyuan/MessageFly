//
//  RadiusView.m
//  MessageFly
//
//  Created by xll on 15/3/26.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "RadiusView.h"

@implementation RadiusView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    dataArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    self.backgroundColor = [UIColor clearColor];
    
    UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, vWIDTH, vHEIGHT)];
    shadowView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self addSubview:shadowView];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, vHEIGHT, vWIDTH, 30)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    UIButton *confirmBtn = [MyControll createButtonWithFrame:CGRectMake(vWIDTH-50, 0, 40, 30) bgImageName:nil imageName:nil title:@"确认" selector:@selector(btnClick:) target:self];
    confirmBtn.tag = 100;
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [bgView addSubview:confirmBtn];
    
    UIButton *concelBtn = [MyControll createButtonWithFrame:CGRectMake(10, 0, 40, 30) bgImageName:nil imageName:nil title:@"取消" selector:@selector(btnClick:) target:self];
    concelBtn.tag = 101;
    concelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [bgView addSubview:concelBtn];
    
    
    UIPickerView *pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, vHEIGHT+30, vWIDTH, 216)];
    [UIView animateWithDuration:0.5 animations:^{
        bgView.frame =CGRectMake(0, vHEIGHT-246, vWIDTH, 30);
        pickView.frame = CGRectMake(0, vHEIGHT-216, vWIDTH, 216);
    }];
    pickView.backgroundColor = [UIColor whiteColor];
    pickView.delegate = self;
    pickView.dataSource = self;
    [self addSubview:pickView];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return dataArray.count;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [MyControll createLabelWithFrame:CGRectMake(0, 0, vWIDTH, 40) title:dataArray[row] font:18];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectNum = dataArray[row];
}
-(void)btnClick:(UIButton *)sender
{
    if (sender.tag == 100) {
        if (selectNum) {
            self.myBlock([NSString stringWithFormat:@"%@km",selectNum]);
        }
        else
        {
            self.myBlock(@"1km");
        }
    }
    else
    {
        self.myBlock(@"");
    }
    [self removeFromSuperview];
}
@end
