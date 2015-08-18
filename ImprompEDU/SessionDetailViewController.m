//
//  ViewController.m
//  Firechat
//
//  Copyright (c) 2012 Firebase.
//
//  No part of this project may be copied, modified, propagated, or distributed
//  except according to terms in the accompanying LICENSE file.
//

#import "SessionDetailViewController.h"
//session id here
#define kFirechatNS @"https://iedusessionchat.firebaseio.com/courses/ANTH25/"

@interface SessionDetailViewController ()
@property (nonatomic) BOOL newMessagesOnTop;
@property (weak, nonatomic) IBOutlet UILabel *sessionTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *sessionLocationLabel;

@property (weak, nonatomic) IBOutlet UILabel *sessionBeginTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *sessionEndTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *sessionDetailsLabel;
@end

@implementation SessionDetailViewController

@synthesize nameField;
@synthesize textField;
@synthesize tableView;
@synthesize newMessagesOnTop;

#pragma mark - Setup

// Assumes input like "#00FF00" (#RRGGBB).
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

// Initialization.
- (void)viewDidLoad
{
    //3b79ad
    [super viewDidLoad];
    self.view.backgroundColor = [self colorFromHexString:@"#3B79AD"];
    self.tableView.backgroundColor = [self colorFromHexString:@"#3B79AD"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Initialize array that will store chat messages.
    self.chat = [[NSMutableArray alloc] init];
    
    // Initialize the root of our Firebase namespace.
    self.firebase = [[Firebase alloc] initWithUrl:kFirechatNS];

    
    // Pick a random number between 1-1000 for our username.
    self.name = [NSString stringWithFormat:@"Guest%d", arc4random() % 1000];
    //[nameField setTitle:self.name forState:UIControlStateNormal];

    // Decide whether or not to reverse the messages
    newMessagesOnTop = NO;
    
    // This allows us to check if these were messages already stored on the server
    // when we booted up (YES) or if they are new messages since we've started the app.
    // This is so that we can batch together the initial messages' reloadData for a perf gain.
    __block BOOL initialAdds = YES;
    
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        if (newMessagesOnTop) {
            [self.chat insertObject:snapshot.value atIndex:0];
        } else {
            [self.chat addObject:snapshot.value];
        }
        
        
        
        // Reload the table view so the new message will show up.
        if (!initialAdds) {
            [self.tableView reloadData];
        }
        /*
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.chat count] -1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
        */
        
    }];
    
    
    
    // Value event fires right after we get the events already stored in the Firebase repo.
    // We've gotten the initial messages stored on the server, and we want to run reloadData on the batch.
    // Also set initialAdds=NO so that we'll reload after each additional childAdded event.
    [self.firebase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        // Reload the table view so that the intial messages show up
        [self.tableView reloadData];
        initialAdds = NO;
    }];
    NSLog(@"hey we got here 1");
    NSLog(_sessionstring);
    NSLog(@"hey we got here 2");
    Firebase *courseDetails = [[Firebase alloc]initWithUrl:@"https://impromptedu.firebaseio.com/Sessions/Calc%201"];
    [courseDetails observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
     {
         self.sessionBeginTimeLabel.text = snapshot.value[@"Begin Time"];
         self.sessionDetailsLabel.text = snapshot.value[@"Details"];
         self.sessionEndTimeLabel.text = snapshot.value[@"End Time"];
         self.sessionLocationLabel.text = snapshot.value[@"Location"];
         self.sessionTitleLabel.text = snapshot.value[@"Session Name"];
         
     }];
     
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Text field handling

// This method is called when the user enters text in the text field.
// We add the chat message to our Firebase.
- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [aTextField resignFirstResponder];

    // This will also add the message to our local array self.chat because
    // the FEventTypeChildAdded event will be immediately fired.
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"];
    
    
    NSString *stringFromDate = [formatter stringFromDate:now];
    [[self.firebase childByAutoId] setValue:@{@"name" : self.name, @"text": aTextField.text, @"time": stringFromDate}];

    [aTextField setText:@""];
    
    
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    // We only have one section in our table view.
    return 1;
}

- (NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
    // This is the number of chat messages.
    return [self.chat count];
}

// This method changes the height of the text boxes based on how much text there is.


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* chatMessage = [self.chat objectAtIndex:indexPath.row];
    
    NSString *text = chatMessage[@"text"];
    
    // typical textLabel.frame = {{10, 30}, {260, 22}}
    const CGFloat TEXT_LABEL_WIDTH = 260;
    CGSize constraint = CGSizeMake(TEXT_LABEL_WIDTH, 20000);
    
    // typical textLabel.font = font-family: "Helvetica"; font-weight: bold; font-style: normal; font-size: 18px
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping]; // requires iOS 6+
    const CGFloat CELL_CONTENT_MARGIN = 22;
    CGFloat height = MAX(CELL_CONTENT_MARGIN + size.height, 44);
    

    return height;
}
 
- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)index
{
    static NSString *CellIdentifier = @"message";
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];

    NSDictionary* chatMessage = [self.chat objectAtIndex:index.row];

    cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //cell.textLabel.font = [UIFont systemFontOfSize:18];
        //cell.textLabel.numberOfLines = 0;
    }
    UILabel *messageLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *userName = (UILabel *)[cell viewWithTag:101];
    UILabel *time = (UILabel *)[cell viewWithTag:102];
    time.text = chatMessage[@"time"];
    userName.text = chatMessage[@"name"];
    messageLabel.text = chatMessage[@"text"];
    //cell.detailTextLabel.text = chatMessage[@"name"];
    
    
   
    [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return cell;
}




#pragma mark - Keyboard handling

// Subscribe to keyboard show/hide notifications.
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
        addObserver:self selector:@selector(keyboardWillShow:)
        name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter]
        addObserver:self selector:@selector(keyboardWillHide:)
        name:UIKeyboardWillHideNotification object:nil];
}

// Unsubscribe from keyboard show/hide notifications.
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
        removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
        removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// Setup keyboard handlers to slide the view containing the table view and
// text field upwards when the keyboard shows, and downwards when it hides.
- (void)keyboardWillShow:(NSNotification*)notification
{
    [self moveView:[notification userInfo] up:YES];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    [self moveView:[notification userInfo] up:NO];
}

- (void)moveView:(NSDictionary*)userInfo up:(BOOL)up
{
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
     getValue:&keyboardEndFrame];
    
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]
     getValue:&animationCurve];
    
    NSTimeInterval animationDuration;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]
     getValue:&animationDuration];
    
    // Get the correct keyboard size to we slide the right amount.
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    int y = keyboardFrame.size.height * (up ? -1 : 1);
    self.view.frame = CGRectOffset(self.view.frame, 0, y);
    
    [UIView commitAnimations];
}

// This method will be called when the user touches on the tableView, at
// which point we will hide the keyboard (if open). This method is called
// because UITouchTableView.m calls nextResponder in its touch handler.
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
}

@end
