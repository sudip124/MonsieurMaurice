//
//  ContactsViewController.h
//  MonsieurMaurice
//
//  Created by Sudip Pal on 30/08/13.
//  Copyright (c) 2013 Monsieur Maurice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ContactsViewController : UIViewController <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *inswigoImage;
@property (weak, nonatomic) IBOutlet UILabel *mailIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *webTitle;
@property (weak, nonatomic) IBOutlet UILabel *websiteDetails;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberDetails;
@property (weak, nonatomic) IBOutlet UILabel *mailIDDetails;

@end
