//
//  CustomOrdersViewController.m
//  MonsieurMaurice
//
//  Created by Sudip Pal on 30/08/13.
//  Copyright (c) 2013 Monsieur Maurice. All rights reserved.
//

#import "CustomOrdersViewController.h"

@interface CustomOrdersViewController ()

@end

@implementation CustomOrdersViewController

@synthesize contactButton=_contactButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    //self.contactButton.titleLabel.text = NSLocalizedString(@"Contact", nil);
    [self.contactButton setTitle:NSLocalizedString(@"Contact", nil) forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setContactButton:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[segue destinationViewController] setToolbarItems:self.toolbarItems];
}
@end
