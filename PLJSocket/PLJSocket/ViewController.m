//
//  ViewController.m
//  PLJSocket
//
//  Created by Edward on 17/3/30.
//  Copyright © 2017年 coolpeng. All rights reserved.
//
/*
 socket 服务端
 */


#import "ViewController.h"
#import "GCDAsyncSocket.h"

@interface ViewController ()<GCDAsyncSocketDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITextField *portTextField;
@property (nonatomic,strong) UITextField *msgTextField;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic, strong) GCDAsyncSocket *clientSocket;// 客户端socket
@property (nonatomic, strong) GCDAsyncSocket *serverSocket;// 服务器socket

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 1、初始化服务器socket，在主线程里回调
    self.serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self loadSubviews];
}

#pragma mark UI
- (void)loadSubviews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.portTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 50, 150, 40)];
    self.portTextField.textColor = [UIColor blackColor];
    self.portTextField.backgroundColor = [UIColor whiteColor];
    self.portTextField.placeholder = @"端口号";
    self.portTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.portTextField.delegate = self;
    self.portTextField.borderStyle = UITextBorderStyleLine;
    self.portTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.portTextField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(CGRectGetMaxX(self.portTextField.frame)+10, 50, 50, 40 );
    [btn setTitle:@"监听" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    btn.layer.cornerRadius = 3.f;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    [btn addTarget:self action:@selector(listenAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.msgTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.portTextField.frame)+20, 150, 40)];
    self.msgTextField.textColor = [UIColor blackColor];
    self.msgTextField.backgroundColor = [UIColor whiteColor];
    self.msgTextField.placeholder = @"发送内容";
    self.msgTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.msgTextField.delegate = self;
    self.msgTextField.borderStyle = UITextBorderStyleLine;
    self.msgTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.msgTextField];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(CGRectGetMaxX(self.msgTextField.frame)+10, CGRectGetMaxY(btn.frame)+20, 50, 40 );
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    sendBtn.layer.cornerRadius = 3.f;
    sendBtn.layer.borderWidth = 1;
    sendBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(sendBtn.frame)+20, 250, 250)];
    self.textView.backgroundColor = [UIColor orangeColor];
    self.textView.textAlignment = NSTextAlignmentLeft;
    self.textView.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.textView];
}

#pragma mark Events
// 开始监听
- (void)listenAction {
    
    // 1. 开放哪些端口
    NSError *error = nil;
    BOOL result = [self.serverSocket acceptOnPort:self.portTextField.text.integerValue error:&error];
    
    // 2. 判断端口号是否开放成功
    if (result) {
        [self showMsg:@"端口开放成功"];
    } else {
        [self showMsg:@"端口开放失败"];
    }
}

// 发送消息
- (void)sendAction {
    NSData *data = [self.msgTextField.text dataUsingEncoding:NSUTF8StringEncoding];
    [self.clientSocket writeData:data withTimeout:-1 tag:0];
}

- (void)showMsg:(NSString *)msg {
    self.textView.text = [self.textView.text stringByAppendingFormat:@"%@\n",msg];
}

#pragma mark - GCDAsyncSocketDelegate
// 当客户端连接服务器端的socket, 为客户端生成一个socket
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    [self showMsg:@"链接成功"];
    //IP: newSocket.connectedHost
    //端口号: newSocket.connectedPort
    
    // 保存客户端的socket
    self.clientSocket = newSocket;
    [self showMsg:[NSString stringWithFormat:@"连接地址: %@", newSocket.connectedHost]];
    [self showMsg:[NSString stringWithFormat:@"端口号: %hu", newSocket.connectedPort]];
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}

// 收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self showMsg:message];
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
