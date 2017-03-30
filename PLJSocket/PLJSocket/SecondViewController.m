//
//  SecondViewController.m
//  PLJSocket
//
//  Created by Edward on 17/3/30.
//  Copyright © 2017年 coolpeng. All rights reserved.
//
/*
 socket 客户端
 */


#import "SecondViewController.h"
#import "GCDAsyncSocket.h"

@interface SecondViewController ()<GCDAsyncSocketDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITextField *ipTextField;
@property (nonatomic,strong) UITextField *portTextField;
@property (nonatomic,strong) UITextField *msgTextField;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic, strong) GCDAsyncSocket *socket;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubviews];
    
    // 1. 创建socket
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark UI
- (void)loadSubviews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.ipTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 50, 150, 40)];
    self.ipTextField.textColor = [UIColor blackColor];
    self.ipTextField.backgroundColor = [UIColor whiteColor];
    self.ipTextField.placeholder = @"IP";
    self.ipTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.ipTextField.delegate = self;
    self.ipTextField.borderStyle = UITextBorderStyleLine;
    self.ipTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.ipTextField];
    
    self.portTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.ipTextField.frame)+10, 150, 40)];
    self.portTextField.textColor = [UIColor blackColor];
    self.portTextField.backgroundColor = [UIColor whiteColor];
    self.portTextField.placeholder = @"端口号";
    self.portTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.portTextField.delegate = self;
    self.portTextField.borderStyle = UITextBorderStyleLine;
    self.portTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.portTextField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(CGRectGetMaxX(self.ipTextField.frame)+10, CGRectGetMinY(self.portTextField.frame), 50, 40 );
    [btn setTitle:@"连接" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    btn.layer.cornerRadius = 3.f;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    [btn addTarget:self action:@selector(connectAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.msgTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.portTextField.frame)+10, 150, 40)];
    self.msgTextField.textColor = [UIColor blackColor];
    self.msgTextField.backgroundColor = [UIColor whiteColor];
    self.msgTextField.placeholder = @"发送内容";
    self.msgTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.msgTextField.delegate = self;
    self.msgTextField.borderStyle = UITextBorderStyleLine;
    self.msgTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.msgTextField];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(CGRectGetMaxX(self.msgTextField.frame)+10, CGRectGetMinY(self.msgTextField.frame), 50, 40 );
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    sendBtn.layer.cornerRadius = 3.f;
    sendBtn.layer.borderWidth = 1;
    sendBtn.layer.borderColor = [UIColor blueColor].CGColor;
    [sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.msgTextField.frame)+20, 250, 250)];
    self.textView.backgroundColor = [UIColor orangeColor];
    self.textView.textAlignment = NSTextAlignmentLeft;
    self.textView.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.textView];
}

#pragma mark Events
// 连接服务器
- (void)connectAction {
    
    // 1. 与服务器的socket链接起来
    NSError *error = nil;
    BOOL result = [self.socket connectToHost:self.ipTextField.text onPort:[self.portTextField.text integerValue] error:&error];
    
    // 2. 判断链接是否成功
    if (result) {
        [self showMsg:@"客户端链接服务器成功"];
    } else {
        [self showMsg:@"客户端链接服务器失败"];
    }
}

// 发送消息
- (void)sendAction {
    [self.socket writeData:[self.msgTextField.text dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}

- (void)showMsg:(NSString *)msg {
    NSLog(@"客户端接收到的数据 %@",msg);
    self.textView.text = [self.textView.text stringByAppendingFormat:@"%@\n",msg];
}


#pragma mark - GCDAsyncSocketDelegate
// 客户端连接服务器端成功, 客户端获取地址和端口号
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    [self showMsg:[NSString stringWithFormat:@"连接服务器成功IP: %@", host]];
    [self.socket readDataWithTimeout:-1 tag:0];
}

// 发送完数据
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"%s",__func__);
    //发送完数据手动读取，-1不设置超时
    [_socket readDataWithTimeout:-1 tag:0];
}

// 客户端已经获取到内容
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self showMsg:content];
    [self.socket readDataWithTimeout:-1 tag:0];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
