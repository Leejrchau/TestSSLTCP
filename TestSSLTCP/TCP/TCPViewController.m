//
//  TCPViewController.m
//  TestSSLTCP
//
//  Created by lizhichao on 14-7-14.
//  Copyright (c) 2014年 LiZhiChao. All rights reserved.
//

#import "TCPViewController.h"
#import "GCDAsyncSocket.h"


@interface TCPViewController ()

@end

@implementation TCPViewController

-(void)dealloc
{
    stateLabel = nil;
    asyncSocket = nil;
    NSLog(@"%s",__FUNCTION__);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"TCP";

    stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 100, 120, 44)];
    [self.view addSubview:stateLabel];

    //创建socket
    [self createAsyncSocket];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createAsyncSocket
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];

    asyncSocket.delegate = self;
    NSString *host = HOST;
    uint16_t port = PORT;
    stateLabel.text = @"连接中";
    NSError *error = nil;
    if(![asyncSocket connectToHost:host onPort:port error:&error]){

        stateLabel.text = @"没有与服务器建立连接";
    }

}

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    stateLabel.text = @"与服务器建立连接";

    // Configure SSL/TLS settings
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithCapacity:3];
    //创建的 socket连接 采用SSL加密
    [settings setObject:HOST
                 forKey:(NSString *)kCFStreamSSLPeerName];
    [sock startTLS:settings];//启动SSL连接请求

}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    stateLabel.text = @"建立了SSL加密连接";
    NSString *requestStr = [NSString stringWithFormat:@"GET / HTTP/1.1\r\nHost: %@\r\n\r\n", HOST];

    NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    //写入数据
	[sock writeData:requestData withTimeout:-1 tag:0];
	[sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"数据已经写入");
}

//在这里读取数据的 回调方法
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSString *httpResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSLog(@"shujushi %@",httpResponse);
}

//断开连接的回调方法
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	stateLabel.text = @"Disconnected";
}



@end
