# CBMailTest
MFMailComposeViewController的使用

在APP中发送邮件，是一个很普遍的应用场景，譬如对于APP的用户反馈，就可以通过在APP中直接编辑邮件或者打开iOS自带的Mail来实现邮件反馈。下面先回顾一下在APP中使用邮件的两种方式，然后再和大家分享一个项目中遇到的问题。

iOS系统框架提供的两种发送Email的方法：openURL 和 MFMailComposeViewController

Type 1：openURL

openURL调用系统Mail客户端 是我们在iOS3之前实现发邮件功能的主要方法。效果是，从A应用切换到Mail，实际是在Mail中编辑发送邮件，这种方法是很不友好的。

下面是详细代码：

```
-(void)launchMailApp     
{       
    NSMutableString *mailUrl = [[[NSMutableString alloc]init]autorelease];     
    //添加收件人     
    NSArray *toRecipients = [NSArray arrayWithObject: @"first@example.com"];     
    [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];     
    //添加抄送     
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];       
    [mailUrl appendFormat:@"?cc=%@", [ccRecipients componentsJoinedByString:@","]];     
    //添加密送     
    NSArray *bccRecipients = [NSArray arrayWithObjects:@"fourth@example.com", nil];       
    [mailUrl appendFormat:@"&bcc=%@", [bccRecipients componentsJoinedByString:@","]];     
    //添加主题     
    [mailUrl appendString:@"&subject=my email"];     
    //添加邮件内容     
    [mailUrl appendString:@"&body=<b>email</b> body!"];     
    NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];       
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];       
}   
```

Type 2：MFMailComposeViewController

MFMailComposeViewController是iOS3之后新增的，源于MessageUI.framework。显而易见，我们通过MFMailComposeViewController这个控制器，可以在我们自己的APP中展现一个邮件编辑页面，这样发送邮件就不需要离开当前的APP了。前提是设备中的Mail要添加了账户，或者iCloud设置了邮件账户。所以需要MFMailComposeViewController提供的canSendMail判断是否已绑定账户。

MFMailComposeViewController使用前的准备：

       1、项目中引入MessageUI.framework

       2、导入MFMailComposeViewController.h

       3、遵循MFMailComposeViewControllerDelegate，并实现代理方法来处理发送


```
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


```

