//
//  MyQIanDanViewController.m
//  MessageFly
//
//  Created by xll on 15/4/7.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "MyQIanDanViewController.h"
#import "NearbyTableViewCell.h"
#import "OrderDetailOnViewController.h"
#import "SubOrderViewController.h"
@interface MyQIanDanViewController ()<UIScrollViewDelegate>
{
    UIImageView *navImageView;
    
    UIScrollView *mainSC;
    UIView *leftView;
    UIView *midView;
    UIView *rightView;
    
    SubOrderViewController * vc1;
    SubOrderViewController * vc2;
    SubOrderViewController * vc3;
}


@end

@implementation MyQIanDanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    // Do any additional setup after loading the view.
}
-(void)createNav
{
    navImageView = [MyControll createImageViewWithFrame:CGRectMake(0, 0, WIDTH, 40) imageName:@"o2@2x"];
    navImageView.userInteractionEnabled = YES;
    [self.view addSubview:navImageView];
    
    NSArray *nameArray = @[@"已抢单",@"已失效",@"已成交"];
    for (int i = 0; i<3; i++) {
        UIButton *btn =[MyControll createButtonWithFrame:CGRectMake(WIDTH/3*i, 0, WIDTH/3, 40) bgImageName:nil imageName:nil title:nameArray[i] selector:@selector(navClick:) target:self];
        btn.tag = 100+i;
        if (i==0) {
            btn.selected = YES;
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor colorWithRed:0.16f green:0.72f blue:0.93f alpha:1.00f] forState:UIControlStateSelected];
        [navImageView addSubview:btn];
    }
    
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake((WIDTH/3-(WIDTH/3-20))/2+0*WIDTH/3, 38, WIDTH/3-20, 2)];
    bottomLine.tag = 103;
    bottomLine.backgroundColor = [UIColor colorWithRed:0.16f green:0.72f blue:0.93f alpha:1.00f];
    [navImageView addSubview:bottomLine];
}
-(void)navClick:(UIButton *)sender
{
    int index = (int)sender.tag-100;
    for (int i=0; i<3; i++) {
        UIButton *btn = (UIButton *)[navImageView viewWithTag:100+i];
        if (btn.tag == sender.tag) {
            btn.selected = YES;
        }
        else
        {
            btn.selected = NO;
        }
    }
    UIView *bottomLine = [navImageView viewWithTag:103];
    [UIView animateWithDuration:0.2 animations:^{
        bottomLine.frame =CGRectMake((WIDTH/3-(WIDTH/3-20))/2+index*WIDTH/3, 38, WIDTH/3-20, 2);
        mainSC.contentOffset = CGPointMake(WIDTH*index, 0);
    }];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIView *bottomLine = [navImageView viewWithTag:103];
    
    CGPoint point = scrollView.contentOffset;
    bottomLine.frame = CGRectMake((WIDTH/3-(WIDTH/3-20))/2+point.x/3, 38, WIDTH/3-20, 2);
    UIButton *btn1 = (UIButton *)[navImageView viewWithTag:100+0];
    UIButton *btn2 = (UIButton *)[navImageView viewWithTag:100+1];
    UIButton *btn3 = (UIButton *)[navImageView viewWithTag:100+2];
    if (point.x>WIDTH/2&&point.x<WIDTH/2*3) {
        btn2.selected = YES;
        btn1.selected = NO;
        btn3.selected = NO;
    }
    else if(point.x<WIDTH/2)
    {
        btn2.selected = NO;
        btn1.selected = YES;
        btn3.selected = NO;
    }
    else if(point.x>WIDTH/2*3)
    {
        btn2.selected = NO;
        btn1.selected = NO;
        btn3.selected = YES;
    }
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, WIDTH, HEIGHT-64-50-40)];
    mainSC.showsHorizontalScrollIndicator = NO;
    mainSC.bounces = NO;
    mainSC.pagingEnabled = YES;
    mainSC.delegate = self;
    mainSC.contentSize = CGSizeMake(3*WIDTH, HEIGHT-40-64-50);
    [self.view addSubview:mainSC];
    
    leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, mainSC.frame.size.height)];
    [mainSC addSubview:leftView];
    
    midView= [[UIView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH, mainSC.frame.size.height)];
    [mainSC addSubview:midView];
    
    rightView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH*2, 0, WIDTH, mainSC.frame.size.height)];
    [mainSC addSubview:rightView];
    
    vc1 = [[SubOrderViewController alloc]init];
    vc1.state = 3;
    vc1.type = 2;
    [self addChildViewController:vc1];
    CGRect rect = vc1.view.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = WIDTH;
    rect.size.height =mainSC.frame.size.height;
    vc1.view.frame = rect;
    [leftView addSubview:vc1.view];
    
    vc2 = [[SubOrderViewController alloc]init];
    vc2.state = 4;
    vc2.type = 2;
    [self addChildViewController:vc2];
    CGRect rect2 = vc2.view.frame;
    rect2.origin.x = 0;
    rect2.origin.y = 0;
    rect2.size.width = WIDTH;
    rect2.size.height =mainSC.frame.size.height;
    vc2.view.frame = rect2;
    [midView addSubview:vc2.view];
    
    vc3 = [[SubOrderViewController alloc]init];
    vc3.state = 5;
    vc3.type = 2;
    [self addChildViewController:vc3];
    CGRect rect3 = vc3.view.frame;
    rect3.origin.x = 0;
    rect3.origin.y = 0;
    rect3.size.width = WIDTH;
    rect3.size.height =mainSC.frame.size.height;
    vc3.view.frame = rect3;
    [rightView addSubview:vc3.view];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadSubViewcontroll) name:MyQRELOADVC object:nil];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)reloadSubViewcontroll
{
    [vc1 controllerRefresh];
    [vc2 controllerRefresh];
    [vc3 controllerRefresh];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
