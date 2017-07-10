//
//  ViewController.m
//  WPTest
//
//  Created by wupeng on 16/3/9.
//  Copyright © 2016年 wupeng. All rights reserved.
//

#import "ViewController.h"
#import "AsyncUdpSocket.h"


@interface ViewController ()<AsyncUdpSocketDelegate>
{
    
    AsyncUdpSocket *_clientSocket;//创建支持upd协议的socket
}

@property (weak, nonatomic) IBOutlet UITextField *ipTextfield;

@property (weak, nonatomic) IBOutlet UITextField *portTextfield;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;

@property (weak, nonatomic) IBOutlet UITextView *receivedMessage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //创建socket
    _clientSocket = [[AsyncUdpSocket alloc]initWithDelegate:self];
    //绑定当前的端口号 2024以内是系统自定义的
    [_clientSocket bindToPort:2222 error:nil];
    
    //开启 准备接受消息
    [_clientSocket receiveWithTimeout:-1 tag:0];
    
    
    
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"diaole");
//}
- (IBAction)sendMessage:(id)sender {
    
    //消息
    NSData *message = [self.messageTextField.text dataUsingEncoding:NSUTF8StringEncoding];
    //向指定的ip port发送消息
    [_clientSocket sendData:message toHost:_ipTextfield.text port:[_portTextfield.text integerValue] withTimeout:10 tag:0];
    
}

#pragma mark - 已经接收到了消息
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"收到了来自 ip:%@ 端口号：%d 的消息！",host,port);
    NSLog(@"消息是：%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    //显示收到的消息
    self.receivedMessage.text = [self.receivedMessage.text stringByAppendingFormat:@"\n收到了来着 ip%@ 端口为%d的消息%@",host,port,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    //收到消息，让textView向上偏移
    self.receivedMessage.contentOffset = CGPointMake(0, self.receivedMessage.contentSize.height - 100);
    
    //继续接受消息
    [_clientSocket receiveWithTimeout:-1 tag:0];
    
    
    return YES;
}

#pragma mark - 发送消息
- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"发送成功");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
