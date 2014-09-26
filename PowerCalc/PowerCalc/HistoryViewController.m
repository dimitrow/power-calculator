//
//  HistoryViewController.m
//  PowerCalc
//
//  Created by Eugene Dimitrow on 9/20/14.
//  Copyright (c) 2014 Eugene Dimitrow. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
{
    NSInteger index;
}

@property (strong) NSMutableArray *records;

@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.navigationController.navigationBar.tintColor = [UIColor greenColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"History"];
    self.records = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)closeHistory
{

    [self performSegueWithIdentifier:@"closeHistory" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  ([self.records count] >= 1) ? [self.records count] : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.historyTable = tableView;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
    

    
    UILabel *expression = (UILabel *)[cell viewWithTag:1917];
    UILabel *result = (UILabel *)[cell viewWithTag:1984];
    UIView *cellView = (UIView *)[cell viewWithTag:1914];
    cellView.backgroundColor = [UIColor colorWithRed:0.909 green:0.939 blue:0.901 alpha:1.0];
    cellView.layer.borderColor = [UIColor grayColor].CGColor;
    cellView.layer.borderWidth = 1.0;
    cellView.layer.cornerRadius = 4.0;

    expression.text = [[self.records valueForKey:@"expression"] objectAtIndex:indexPath.row];
    result.text = [[self.records valueForKey:@"result"] objectAtIndex:indexPath.row];
    
    //cell.textLabel.text = @"cell";
 
 // Configure the cell...
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    index = indexPath.row;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Use Result",
                                                                      @"Use expression",
                                                                      @"Copy",
                                                                      @"Send an email",
                                                                      @"tweet", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"Use result");
    } else if (buttonIndex == 1) {
        NSLog(@"Use expression");
    } else if (buttonIndex == 2) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"%@%@",
                             [[self.records valueForKey:@"expression"] objectAtIndex:index],
                             [[self.records valueForKey:@"result"] objectAtIndex:index]];
    } else if (buttonIndex == 3) {
        NSString *mailSubject = @"Power Calculator email";
        NSString *mailBody = [self messageBody];

        NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"icon@2x"]);
        
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail addAttachmentData:imageData mimeType:@"image/png" fileName:@"icon@2x"];
        
        [mail setSubject:mailSubject];
        [mail setMessageBody:mailBody isHTML:NO];

        [self presentViewController:mail animated:YES completion:NULL];
        
    } else if (buttonIndex == 4) {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            NSString *tweetMessage = [self messageBody];
            [tweet setInitialText:tweetMessage];
            [tweet addImage:[UIImage imageNamed:@"icon@2x"]];
            [self presentViewController:tweet animated:YES completion:nil];
        }
    }
        
}

- (NSString *)messageBody
{
    NSString *message = [NSString stringWithFormat:@"Calculation performed by Power Calculator: %@%@",
                         [[self.records valueForKey:@"expression"] objectAtIndex:index],
                         [[self.records valueForKey:@"result"] objectAtIndex:index]];
    return message;

}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [context deleteObject:[self.records objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        
        [self.records removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
