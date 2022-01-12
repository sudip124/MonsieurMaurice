//
//  MainPageViewController.h
//  MonsieurMaurice
//
//  Created by Sudip Pal on 17/08/13.
//  Copyright (c) 2013 Monsieur Maurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPageViewController : UIViewController <NSXMLParserDelegate>
//@property (weak, nonatomic) IBOutlet UILabel *textContent;
- (IBAction)invokeContact:(id)sender;
@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITextView *textContent;
@property (weak, nonatomic) IBOutlet UILabel *textHeader;
//@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end
