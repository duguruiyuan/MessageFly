//
//  SelectCityView.m
//  MessageFly
//
//  Created by xll on 15/3/30.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "SelectCityView.h"
#import "pinyin.h"
@implementation SelectCityView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)dealloc
{
    self.mDownManager.delegate = nil;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _tableView.delegate = self;
        _tableView.backgroundColor= [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.82f alpha:1.00f];
        [self addSubview:_tableView];
    }
    return self;
}
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@citylist?pid=0",SERVER_URL];
    self.mDownManager= [[ImageDownManager alloc]init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    [_mDownManager GetImageByStr:urlstr];
}
-(void)OnLoadFinish:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSArray *array = [resStr JSONValue];
    [self Cancel];
    if (array && [array isKindOfClass:[NSArray class]] && array.count>0) {
        NSLog(@"%@", array);
        [self letterArray:array];
//        self.dataArray = [NSMutableArray arrayWithArray:array];
        [_tableView reloadData];
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
    [self showMsg:@"请检查你的网络"];
}
- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *keys = [self GetSortKeys:self.mDict];
    NSString *key = [keys objectAtIndex:section];
    NSArray *array = [self.mDict objectForKey:key];
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mDict.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *keys = [self GetSortKeys:self.mDict];
    NSString *key = [keys objectAtIndex:section];
    return key;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    NSArray *keys = [self GetSortKeys:self.mDict];
    NSString *key = [keys objectAtIndex:indexPath.section];
    NSArray *array = [self.mDict objectForKey:key];
    cell.textLabel.text =array[indexPath.row][@"value"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *keys = [self GetSortKeys:self.mDict];
    NSString *key = [keys objectAtIndex:indexPath.section];
    NSArray *array = [self.mDict objectForKey:key];
    NSDictionary *dict = [array objectAtIndex:indexPath.row];
    [_delegate selectCity:dict[@"value"] ID:dict[@"id"]];
    [self removeFromSuperview];
}

-(void)letterArray:(NSArray *)array
{
    
    NSMutableDictionary *letterDic = [[NSMutableDictionary alloc]init];
    NSMutableArray *letterArray = [NSMutableArray arrayWithCapacity:26];
    for (NSDictionary *dic in array) {
        NSString *letter =  [NSString stringWithFormat:@"%c",[ChinesePinyin GetFirstLetter:dic[@"2"]]];
        if (letterArray == nil) {
            [letterArray addObject:letter];
        }
        else
        {
            int count = 0;
            for (NSString *str in letterArray) {
                if (![str isEqualToString:letter]) {
                    count ++;
                }
            }
            if (count == letterArray.count) {
                [letterArray addObject:letter];
            }
        }
    }
    self.titleArray = [self sort:letterArray];
    for (NSString *str in letterArray) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in array) {
            NSString *letter =  [NSString stringWithFormat:@"%c",[ChinesePinyin GetFirstLetter:dic[@"2"]]];
            if ([letter isEqualToString:str]) {
                [tempArray addObject:dic];
            }
        }
        [letterDic setObject:tempArray forKey:str];
    }
    self.mDict = [NSMutableDictionary dictionaryWithDictionary:letterDic];
}
-(NSMutableArray *)sort:(NSMutableArray *)marr
{
    for(int i = 0; i < marr.count - 1; i++)
    {
        for( int j = 0 ; j < marr.count - 1 - i; j++ )
        {
            int prev = j;
            int next = j + 1;
            NSString * str_prev = marr[prev];
            NSString * str_next = marr[next];
            if([str_prev compare:str_next] == NSOrderedDescending)
            {
                [marr exchangeObjectAtIndex:prev withObjectAtIndex:next];
            }
        }
    }
    return marr;
}
- (NSArray *)GetSortKeys:(NSDictionary *)dict {
    return [dict.allKeys sortedArrayUsingSelector:@selector(compare:)];
}
@end
