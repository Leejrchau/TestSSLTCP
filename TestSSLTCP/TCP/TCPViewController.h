//
//  TCPViewController.h
//  TestSSLTCP
//
//  Created by lizhichao on 14-7-14.
//  Copyright (c) 2014年 LiZhiChao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"

@interface TCPViewController : UIViewController<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *asyncSocket;
    UILabel *stateLabel;
}
@end
