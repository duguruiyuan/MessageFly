//
//  SelectCityViewController.m
//  MessageFly
//
//  Created by xll on 15/4/2.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "SelectCityViewController.h"
#import "pinyin.h"
@interface SelectCityViewController ()

@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选取城市";
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    _tableView.delegate = self;
    _tableView.backgroundColor= [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.82f alpha:1.00f];
    [self.view addSubview:_tableView];

    NSString *name = [NSString stringWithFormat:@"city.plist"];
    NSString *path = [[NSBundle mainBundle] resourcePath];
    path = [path stringByAppendingPathComponent:name];
    NSMutableArray *tempArray = [NSMutableArray arrayWithContentsOfFile:path];
    [self letterArray:tempArray];
    [_tableView reloadData];
    // Do any additional setup after loading the view.
}
//-(void)dealloc
//{
//    self.mDownManager.delegate = nil;
//}
//-(void)loadData
//{
//    if (_mDownManager) {
//        return;
//    }
//    [self StartLoading];
//    NSString *urlstr = [NSString stringWithFormat:@"%@citylist?pid=0",SERVER_URL];
//    self.mDownManager= [[ImageDownManager alloc]init];
//    _mDownManager.delegate = self;
//    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
//    _mDownManager.OnImageFail = @selector(OnLoadFail:);
//    [_mDownManager GetImageByStr:urlstr];
//}
//-(void)OnLoadFinish:(ImageDownManager *)sender
//{
//    NSString *resStr = sender.mWebStr;
//    NSArray *array = [resStr JSONValue];
//    [self Cancel];
//    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
//    if (array && [array isKindOfClass:[NSArray class]] && array.count>0) {
//        [tempArray removeAllObjects];
//        [tempArray addObjectsFromArray:array];
//               
//        [self letterArray:tempArray];
//        [_tableView reloadData];
//    }
//}
//- (void)OnLoadFail:(ImageDownManager *)sender {
//    [self Cancel];
//    [self showMsg:@"请检查你的网络"];
//}
//- (void)Cancel {
//    [self StopLoading];
//    SAFE_CANCEL_ARC(self.mDownManager);
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *keys = [self GetSortKeys:self.mDict];
    NSString *key = [keys objectAtIndex:section];
    NSArray *array = [self.mDict objectForKey:key];
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mDict.count;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.titleArray;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *keys = [self GetSortKeys:self.mDict];
    NSString *key = [keys objectAtIndex:section];
    return key;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
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
    [_cDelegate selectCity:dict[@"value"] ID:dict[@"id"]];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)letterArray:(NSArray *)array
{
    NSMutableDictionary *letterDic = [[NSMutableDictionary alloc]init];
    NSMutableArray *letterArray = [NSMutableArray arrayWithCapacity:26];
    for (NSDictionary *dic in array) {
        NSString *letter =  [NSString stringWithFormat:@"%c",[ChinesePinyin GetFirstLetter:dic[@"value"]]];
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
    self.titleArray = [NSMutableArray arrayWithCapacity:0];
    self.titleArray = [self sort:letterArray];
    for (NSString *str in letterArray) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in array) {
            NSString *letter =  [NSString stringWithFormat:@"%c",[ChinesePinyin GetFirstLetter:dic[@"value"]]];
            if ([letter isEqualToString:str]) {
                [tempArray addObject:dic];
            }
        }
        [letterDic setObject:tempArray forKey:str];
    }
    self.mDict = [NSMutableDictionary dictionaryWithDictionary:letterDic];
}
- (NSArray *)GetSortKeys:(NSDictionary *)dict {
    return [dict.allKeys sortedArrayUsingSelector:@selector(compare:)];
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
