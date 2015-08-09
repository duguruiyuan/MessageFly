//
//  SelectCityViewController.h
//  MessageFly
//
//  Created by xll on 15/4/2.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADViewController.h"
@protocol CitySelectDelegate <NSObject>

-(void)selectCity:(NSString *)cityName ID:(NSString *)id;

@end
@interface SelectCityViewController : BaseADViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property (nonatomic, strong) NSMutableDictionary *mDict;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic)id<CitySelectDelegate>cDelegate;
//-(void)loadData;


@end
