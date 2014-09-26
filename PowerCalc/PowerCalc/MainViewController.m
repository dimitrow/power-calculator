//
//  MainViewController.m
//  PowerCalc
//
//  Created by Eugene Dimitrow on 9/17/14.
//  Copyright (c) 2014 Eugene Dimitrow. All rights reserved.
//

#define GAP 2
#define ROWS_OF_KEYS 4
#define COLUMNS_OF_KEYS 3
#define BUTTON_COLOR [UIColor colorWithRed:0.940 green:0.940 blue:0.940 alpha:1.0];
#define FBUTTON_COLOR [UIColor colorWithRed:0.880 green:0.880 blue:0.880 alpha:1.0];
#define SCR_COLOR [UIColor colorWithRed:0.909 green:0.939 blue:0.901 alpha:1.0];



#import "MainViewController.h"
#import "HistoryViewController.h"

@interface MainViewController ()
{
    NSMutableArray *keyboards;
    
    BOOL isStilTyping;
    BOOL equalPressed;
    
}

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self constructUserInterface];
    self.resultLabel.text = @"0";
    self.expressionLabel.text = @"";
    
}

- (void)constructUserInterface
{
    
    self.screenView.frame = CGRectMake(self.view.frame.origin.x + 2, self.view.frame.origin.y + 20, self.view.frame.size.width - 4, self.view.frame.size.height/6);
    self.screenView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.screenView.layer.borderWidth = 1.0;
    self.screenView.layer.cornerRadius = 4.0;
    self.screenView.backgroundColor = SCR_COLOR;
    
    self.resultLabel.frame = CGRectMake(self.screenView.frame.origin.x + 10, self.screenView.frame.origin.y + 20, self.screenView.frame.size.width - 20, self.screenView.frame.size.height/2);
    self.resultLabel.adjustsFontSizeToFitWidth = YES;
    self.resultLabel.backgroundColor = [UIColor clearColor];
    
    self.expressionLabel.frame = CGRectMake(self.screenView.frame.origin.x + 10, self.screenView.frame.origin.y - 10, self.screenView.frame.size.width - 20, self.screenView.frame.size.height/4);
    self.expressionLabel.adjustsFontSizeToFitWidth = YES;
    
    self.functionView.frame = CGRectMake(self.view.frame.origin.x, self.screenView.frame.size.height + self.screenView.frame.origin.y, self.view.frame.size.width, 48);
    self.functionView.backgroundColor = [UIColor clearColor];
    
    float scrollHeight = self.view.frame.size.height - self.screenView.frame.size.height - self.functionView.frame.size.height - 40;
    self.keyboardView.frame = CGRectMake(self.view.frame.origin.x, self.functionView.frame.origin.y + self.functionView.frame.size.height, self.view.frame.size.width, scrollHeight);
    self.keyboardView.delegate = self;
    self.keyboardView.backgroundColor = [UIColor clearColor];
    self.keyboardView.pagingEnabled = YES;
    self.keyboardView.contentSize = CGSizeMake(self.view.frame.size.width *2, self.keyboardView.frame.size.height);

    self.keyboardIndicator.frame = CGRectMake(self.view.frame.origin.x, self.keyboardView.frame.origin.y + self.keyboardView.frame.size.height, self.view.frame.size.width, 20);
    self.keyboardIndicator.backgroundColor = [UIColor clearColor];
    
    UIView *basicKeyboard = [[UIView alloc] initWithFrame:self.keyboardView.bounds];
    UIView *advancedKeyboard = [[UIView alloc] initWithFrame:CGRectMake(self.keyboardView.frame.size.width, basicKeyboard.frame.origin.y, self.keyboardView.contentSize.width/2, self.keyboardView.contentSize.height)];
    
    
    basicKeyboard.backgroundColor = [UIColor clearColor];
    advancedKeyboard.backgroundColor = [UIColor darkGrayColor];
    
    [self.keyboardView addSubview:basicKeyboard];
    [self.keyboardView addSubview:advancedKeyboard];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpCatcher:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.keyboardView addGestureRecognizer:swipeDown];
    
    NSString *funcTitlesString = @"+ − × ÷ ← C";
    NSArray *funcTitles = [funcTitlesString componentsSeparatedByString:@" "];
    
    for (int i = 0; i < 6; i++) {
        NSInteger funcButtonWidht = (self.functionView.frame.size.width - GAP*([funcTitles count] + 1))/([funcTitles count]);
        UIButton *funcButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        funcButton.backgroundColor = FBUTTON_COLOR;
        funcButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        funcButton.layer.borderWidth = 1.0;
        funcButton.layer.cornerRadius = 4.0;
        [funcButton setTitle:[funcTitles objectAtIndex:i] forState:UIControlStateNormal];
        [funcButton setFrame:CGRectMake(GAP+((funcButtonWidht + GAP) * i), GAP , funcButtonWidht, self.functionView.frame.size.height-GAP)];
        [funcButton addTarget:self action:@selector(functionButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.functionView addSubview:funcButton];
    }
    
    
    
    NSInteger buttonWidth = (self.view.frame.size.width - GAP*(COLUMNS_OF_KEYS + 1))/COLUMNS_OF_KEYS;
    //NSInteger rows = 12/columns;
    NSInteger buttonHeight = (self.keyboardView.frame.size.height - GAP*(ROWS_OF_KEYS))/ROWS_OF_KEYS;
    
    NSString *titleBasicString = @"7 8 9 4 5 6 1 2 3 . 0 =";
    NSArray *titlesBasic = [titleBasicString componentsSeparatedByString:@" "];
    
    for(int i = 0; i < 12; i++)
    {
        UIButton *calcButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        calcButton.backgroundColor = BUTTON_COLOR;
        calcButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        calcButton.layer.borderWidth = 1.0;
        calcButton.layer.cornerRadius = 4.0;
        calcButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight"  size:32.0];
        calcButton.tintColor = [UIColor blackColor];
        [calcButton setTitle:[titlesBasic objectAtIndex:i] forState:UIControlStateNormal];
        [calcButton setFrame:CGRectMake(GAP+((buttonWidth + GAP) * (i%COLUMNS_OF_KEYS)), GAP + (buttonHeight + GAP)*(i/COLUMNS_OF_KEYS), buttonWidth, buttonHeight)];
        
        [calcButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        [_keyboardView addSubview:calcButton];
    }
}

#pragma mark calculations

- (void)clearData
{
    [[self calculator] clear];
    self.expressionLabel.text = @"";
}

- (void)functionButtonTouched:(UIButton *)sender
{
    //[[self calculator] choosenOperation:sender.currentTitle];
    
    if ([sender.currentTitle isEqual:@"C"]) {
        
        [self clearData];
        self.resultLabel.text = @"0";
        isStilTyping = NO;
        
    } else if ([sender.currentTitle isEqual:@"←"]) {
        
        if ([self.resultLabel.text length]>1) {
            
            self.resultLabel.text = [self.resultLabel.text substringToIndex:[self.resultLabel.text length] - 1];
            isStilTyping = YES;
            
        } else {
            
            self.resultLabel.text = @"0";
            
        }
        
    } else {
        
        // get rid of zero in the beginning:
        NSNumber *checkNumber = [NSNumber numberWithDouble:[self.resultLabel.text doubleValue]];
        NSString *checkedString = [NSString stringWithFormat:@"%@", checkNumber];
        
        isStilTyping = NO;

        self.expressionLabel.text = [self.expressionLabel.text stringByAppendingString:checkedString];
        self.expressionLabel.text = [self.expressionLabel.text stringByAppendingString:[sender currentTitle]];
        
        [[self calculator] choosenOperation:[sender currentTitle] withNumber:checkedString];
        
        self.resultLabel.text = [NSString stringWithFormat:@"%@", [self calculator].mathResult];
    }
    
}

- (void)buttonTouched:(UIButton *)sender
{
    if (equalPressed) {
        [self clearData];
        equalPressed = NO;
    }
    
    NSString *symbol = [sender currentTitle];
    if (isStilTyping) {
        
        if (![symbol isEqual:@"="] && ![symbol isEqual:@"."]) {
            self.resultLabel.text = [self.resultLabel.text stringByAppendingString:symbol];
        }
        
    } else {
        self.resultLabel.text = symbol;
        isStilTyping = YES;
    }
    if ([[sender currentTitle] isEqual:@"="]) {
        if ([self calculator].mathResult) {
            
            self.expressionLabel.text = [self.expressionLabel.text stringByAppendingString:self.resultLabel.text];
            self.expressionLabel.text = [self.expressionLabel.text stringByAppendingString:@"="];
            [[self calculator] choosenOperation:@"" withNumber:self.resultLabel.text];
            
            self.resultLabel.text = [NSString stringWithFormat:@"%@", [self calculator].mathResult];
            
            isStilTyping = NO;
            equalPressed = YES;
            
            NSManagedObjectContext *context = [self managedObjectContext];
            
            NSManagedObject *historyRecord = [NSEntityDescription insertNewObjectForEntityForName:@"History" inManagedObjectContext:context];
            [historyRecord setValue:self.resultLabel.text forKey:@"result"];
            [historyRecord setValue:self.expressionLabel.text forKey:@"expression"];
            
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
            
            
        } else {
            
            self.resultLabel.text = @"0";
            self.expressionLabel.text = @"";
            return;
            
        }
    }
    if ([[sender currentTitle] isEqual:@"."]) {
        if (![self isString:self.resultLabel.text hasPoint:[sender currentTitle]]) {
            self.resultLabel.text = [self.resultLabel.text stringByAppendingString:@"."];
        }
    }
    if ([symbol isEqual:@"0"]) {
        if (![self isString:self.resultLabel.text hasPoint:[sender currentTitle]]) {
            self.resultLabel.text = [self.resultLabel.text stringByAppendingString:@"."];
        };
    }

}

- (BOOL)isString:(NSString *)string hasPoint:(NSString *)point
{
    if ([string rangeOfString:point].location != NSNotFound) {
        return YES;
    } else {
        return NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.keyboardIndicator.currentPage = scrollView.contentOffset.x/self.view.frame.size.width;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)swipeUpCatcher:(UISwipeGestureRecognizer *)sender
{

    [self performSegueWithIdentifier:@"historySwipe" sender:self];

}

- (IBAction)returnToStepOne:(UIStoryboardSegue *)segue
{

}

- (CalculatorMath *)calculator
{
    if (!calculator) {
        calculator = [[CalculatorMath alloc] init];
    }
    return calculator;
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
