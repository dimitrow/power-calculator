//
//  HistoryViewController.h
//  PowerCalc
//
//  Created by Eugene Dimitrow on 9/20/14.
//  Copyright (c) 2014 Eugene Dimitrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface HistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *historyTable;


- (IBAction)closeHistory;

@end
