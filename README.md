# CBMailTest
MFMailComposeViewController的使用

       在APP中发送邮件，是一个很普遍的应用场景，譬如对于APP的用户反馈，就可以通过在APP中直接编辑邮件或者打开iOS自带的Mail来实现邮件反馈。下面先回顾一下在APP中使用邮件的两种方式，然后再和大家分享一个项目中遇到的问题。

       iOS系统框架提供的两种发送Email的方法：openURL 和 MFMailComposeViewController: