//
//  SearchView.h
//  MessageFly
//
//  Created by xll on 15/2/11.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchView;
@protocol SearchDelegate <NSObject>

-(void)selectView:(SearchView *)searchView Index:(int)buttonIndex;

@end


@interface SearchView : UIView
{
    UIImageView *xialaView;
}
@property(nonatomic,assign)id<SearchDelegate>delegate;
@end
