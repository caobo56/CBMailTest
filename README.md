# CBMailTest
MFMailComposeViewController的使用

在APP中发送邮件，是一个很普遍的应用场景，譬如对于APP的用户反馈，就可以通过在APP中直接编辑邮件或者打开iOS自带的Mail来实现邮件反馈。下面先回顾一下在APP中使用邮件的两种方式，然后再和大家分享一个项目中遇到的问题。

iOS系统框架提供的两种发送Email的方法：openURL 和 MFMailComposeViewController

Type 1：openURL

       openURL调用系统Mail客户端 是我们在iOS3之前实现发邮件功能的主要方法。效果是，从A应用切换到Mail，实际是在Mail中编辑发送邮件，这种方法是很不友好的。

       下面是详细代码：


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
