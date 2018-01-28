//
//  ViewController.m
//  CBMailTest
//
//  Created by caobo56 on 2018/1/27.
//  Copyright © 2018年 caobo56. All rights reserved.
//

#import "ViewController.h"

@import MessageUI;

@interface ViewController () <MFMailComposeViewControllerDelegate>

@end
@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mailTitle = @"邮件主题";
        _mailText = @"邮件内容";
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _mailTitle = @"邮件主题";
    _mailText = @"邮件内容";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMailBlock:^(NSString *text) {
        
    }];
//    [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:0.01];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)delayMethod{
    [self sendMailAction:nil];
}

- (IBAction)sendMailAction:(id)sender {
    // 1.初始化编写邮件的控制器
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    if (!mailViewController) {
        // 在设备还没有添加邮件账户的时候mailViewController为空，
        // 下面的present view controller会导致程序崩溃，这里要作出判断
        if (_mailBlock) {
            _mailBlock(@"设备还没有添加邮件账户");
        }
        return;
    }
    
    mailViewController.mailComposeDelegate = self;
    
    // 2.设置邮件主题
    if (_mailTitle) {
        [mailViewController setSubject:_mailTitle];
    }
    
    if (_mailText) {
        // 3.设置邮件主体内容
        [mailViewController setMessageBody:_mailText isHTML:NO];
    }
    
    // 5.呼出发送视图
    [self presentViewController:mailViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultFailed) {
        if (_mailBlock) {
            _mailBlock(NSLocalizedString(@"SendEmailFail", @""));
        }
    } else if (result == MFMailComposeResultSent) {
        if (_mailBlock) {
            _mailBlock(NSLocalizedString(@"SendEmailSuccess", @""));
        }
    }
    //关闭邮件发送窗口
    
    [controller dismissViewControllerAnimated:YES completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

@end

