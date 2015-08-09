//
//  SelectCityView.h
//  MessageFly
//
//  Created by xll on 15/3/30.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"

@protocol CitySelectDelegate <NSObject>

-(void)selectCity:(NSString *)cityName ID:(NSString *)id;

@end
@interface SelectCityView : BaseADView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic)id<CitySelectDelegate>delegate;
@property (nonatomic, strong) NSMutableDictionary *mDict;
@property (nonatomic, strong) NSMutableArray *titleArray;
-(void)loadData;
@end
