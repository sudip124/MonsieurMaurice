//
//  RSSFeedDetailsViewController
//  MonsieurMaurice
//
//  Created by Sudip Pal on 15/08/13.
//  Copyright (c) 2013 Monsieur Maurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSFeedDetailsViewController : UIViewController

@property (copy, nonatomic) NSString *url;
@property (strong, nonatomic) IBOutlet UIWebView *webView;


@end
