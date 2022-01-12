//
//  RSSFeedListViewController
//  MonsieurMaurice
//
//  Created by Sudip Pal on 15/08/13.
//  Copyright (c) 2013 Monsieur Maurice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface RSSFeedListViewController : UITableViewController <NSXMLParserDelegate, MFMailComposeViewControllerDelegate, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
