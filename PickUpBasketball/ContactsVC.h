/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/



#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

//#import "REFrostedViewController.h"

UILabel *pullToRefreshLabel;


@interface ContactsVC : UIViewController
<
UIActionSheetDelegate,
MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *usersTable;

- (IBAction)menuButton:(id)sender;

@end
