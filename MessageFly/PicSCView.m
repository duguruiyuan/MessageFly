//
//  PicSCView.m
//  MessageFly
//
//  Created by xll on 15/2/9.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "PicSCView.h"
#import "LunBoTuViewController.h"
@implementation PicSCView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    page = 0;
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, vWIDTH, vHEIGHT)];
    mainSC.showsHorizontalScrollIndicator =NO;
    mainSC.showsVerticalScrollIndicator =NO;
    [self addSubview:mainSC];
}
-(void)loadPicArray:(NSMutableArray *)dataArray
{
    array = dataArray;
    float x = _rect.origin.x;
    float y = _rect.origin.y;
    float width =_rect.size.width;
    float height = _rect.size.height;
    mainSC.contentSize = CGSizeMake((width+_distance)*dataArray.count+x*2-_distance, height);
    for (int i =0; i<dataArray.count; i++) {
        UIImageView *imageView = [MyControll createImageViewWithFrame:CGRectMake(x+i*(width+_distance), y, width, height) imageName:nil];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:dataArray[i]] placeholderImage:[UIImage imageNamed:@"picdefault@2x"]];
        imageView.tag = 100+i;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
        [mainSC addSubview:imageView];
    }
}
-(void)tap:(UIGestureRecognizer *)sender
{
    LunBoTuViewController *vc = [[LunBoTuViewController alloc]init];
    [vc picShow:array atIndex:(int)sender.view.tag-100];
    [_delegate presentViewController:vc animated:NO completion:nil];
}
@end
