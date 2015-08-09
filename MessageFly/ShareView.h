//
//  ShareView.h
//  MessageFly
//
//  Created by xll on 15/4/15.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"

@interface ShareView : BaseADView<UMSocialDataDelegate,UMSocialUIDelegate>
{
    BOOL isAll;
}
@property(nonatomic,strong)UIViewController * delegate;
@end
