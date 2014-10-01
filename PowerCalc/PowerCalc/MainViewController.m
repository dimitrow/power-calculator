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
#define MATH_KEYS 12
#define BUTTON_COLOR [UIColor colorWithRed:0.940 green:0.940 blue:0.940 alpha:1.0];
#define FBUTTON_COLOR [UIColor colorWithRed:0.880 green:0.880 blue:0.880 alpha:1.0];
#define SCR_COLOR [UIColor colorWithRed:0.909 green:0.939 blue:0.901 alpha:1.0];


#import "MainViewController.h"
#import "HistoryViewController.h"

@interface MainViewController ()
{
    NSMutableArray *keyboards;
    
    BOOL isMath;
    BOOL isStilTyping;
    BOOL equalPressed;
    
}
@property (retain,nonatomic) UIView *basicKeyboard;
@property (retain,nonatomic) UIView *advancedKeyboard;


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
    
    self.basicKeyboard = [[[UIView alloc] initWithFrame:self.keyboardView.bounds] autorelease];
    self.advancedKeyboard = [[[UIView alloc] initWithFrame:CGRectMake(self.keyboardView.frame.size.width, self.basicKeyboard.frame.origin.y, self.keyboardView.contentSize.width/2, self.keyboardView.contentSize.height)] autorelease];
    
    
    self.basicKeyboard.backgroundColor = [UIColor clearColor];
    self.advancedKeyboard.backgroundColor = [UIColor clearColor];
    
    [self.keyboardView addSubview:self.basicKeyboard];
    [self.keyboardView addSubview:self.advancedKeyboard];
    
    UISwipeGestureRecognizer *swipeDown = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpCatcher:)] autorelease];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.keyboardView addGestureRecognizer:swipeDown];
    
    NSString *funcTitlesString = @"+ − × ÷ ← C";
    NSArray *funcTitles = [funcTitlesString componentsSeparatedByString:@" "];
    
    for (int i = 0; i < [funcTitles count]; i++) {
        NSInteger funcButtonWidht = (self.functionView.frame.size.width - GAP*([funcTitles count] + 1))/([funcTitles count]);
        UIButton *funcButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        funcButton.backgroundColor = [UIColor colorWithRed:0.545 green:0.563 blue:0.541 alpha:0.6];
        funcButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        funcButton.layer.borderWidth = 1.0;
        funcButton.layer.cornerRadius = 4.0;
        funcButton.tintColor = [UIColor whiteColor];
        [funcButton setTitle:[funcTitles objectAtIndex:i] forState:UIControlStateNormal];
        [funcButton setFrame:CGRectMake(GAP+((funcButtonWidht + GAP) * i), GAP , funcButtonWidht, self.functionView.frame.size.height-GAP)];
        [funcButton addTarget:self action:@selector(functionButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.functionView addSubview:funcButton];
    }
    
    
    
    NSInteger buttonWidth = (self.view.frame.size.width - GAP*(COLUMNS_OF_KEYS + 1))/COLUMNS_OF_KEYS;
    NSInteger buttonHeight = (self.keyboardView.frame.size.height - GAP*(ROWS_OF_KEYS))/ROWS_OF_KEYS;
    
    NSString *titleBasicString = @"7 8 9 4 5 6 1 2 3 . 0 =";
    NSArray *titlesBasic = [titleBasicString componentsSeparatedByString:@" "];
    
    for(int i = 0; i < [titlesBasic count]; i++)
    {
        UIButton *calcButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        calcButton.backgroundColor = BUTTON_COLOR;
        calcButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        calcButton.layer.borderWidth = 1.0;
        calcButton.layer.cornerRadius = 4.0;
        calcButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light"  size:32.0];
        calcButton.tintColor = [UIColor blackColor];
        [calcButton setTitle:[titlesBasic objectAtIndex:i] forState:UIControlStateNormal];
        if ([calcButton.titleLabel.text isEqualToString:@"="]) {
            calcButton.backgroundColor = [UIColor colorWithRed:0.545 green:0.563 blue:0.541 alpha:0.6];
            calcButton.tintColor = [UIColor whiteColor];
        }
        [calcButton setFrame:CGRectMake(GAP+((buttonWidth + GAP) * (i%COLUMNS_OF_KEYS)), GAP + (buttonHeight + GAP)*(i/COLUMNS_OF_KEYS), buttonWidth, buttonHeight)];
        
        [calcButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.basicKeyboard addSubview:calcButton];
    }
    
    for(int i = 0; i < MATH_KEYS; i++)
    {
        NSMutableArray *buttonTiles = [[[NSMutableArray alloc] init] autorelease];
        NSString *tileImageName = [NSString stringWithFormat:@"a%i", i];
        [buttonTiles addObject:tileImageName];
        
        UIButton *mathButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        mathButton.backgroundColor = BUTTON_COLOR;
        mathButton.tag = i;
        mathButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        mathButton.layer.borderWidth = 1.0;
        mathButton.layer.cornerRadius = 4.0;
        mathButton.tintColor = [UIColor blackColor];
        
        [mathButton setImage:[UIImage imageNamed:[buttonTiles objectAtIndex:0]] forState:UIControlStateNormal];
        [mathButton setFrame:CGRectMake(GAP+((buttonWidth + GAP) * (i%COLUMNS_OF_KEYS)), GAP + (buttonHeight + GAP)*(i/COLUMNS_OF_KEYS), buttonWidth, buttonHeight)];
        
        [mathButton addTarget:self action:@selector(advancedButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.advancedKeyboard addSubview:mathButton];
        
        
    }
}

#pragma mark calculations

- (void)clearData
{
    [calculator clear];
    self.expressionLabel.text = @"";
}

- (void)mathOperation:(NSString *)selectedOperation toDisplay:(NSString *)symbol
{
    NSString *mathArg = nil;
    NSNumber *checkNumber = [NSNumber numberWithDouble:[self.resultLabel.text doubleValue]];
    NSString *checkedString = [NSString stringWithFormat:@"%@", checkNumber];
    
    if (![self calculator].mathResult) {
        [[self calculator] mathOperation:selectedOperation withValue:self.resultLabel.text];
        mathArg = self.resultLabel.text;
    } else {
        
        self.expressionLabel.text = [self.expressionLabel.text stringByAppendingString:checkedString];
        
        [[self calculator] choosenOperation:@"" withNumber:self.resultLabel.text];
        mathArg = [self calculator].mathResult;
        [[self calculator] mathOperation:selectedOperation withValue:[self calculator].mathResult];
        
    }
    
    self.expressionLabel.text = [self.expressionLabel.text stringByAppendingString:symbol];
    self.expressionLabel.text = [self.expressionLabel.text stringByAppendingString:mathArg];
    self.resultLabel.text = [NSString stringWithFormat:@"%@", [self calculator].mathResult];
}

- (void)advancedButtonTouched:(UIButton *)sender
{
    NSString *operation = nil;//[[[NSString alloc] init] autorelease];
    UIButton *temp = [[[UIButton alloc] init] autorelease];
    isStilTyping = NO;
    isMath = YES;
    
    switch (sender.tag) {
        case 0:
            operation = @"√";
            [self mathOperation:@"squareRoot" toDisplay:operation];
            break;
        case 1:
            isMath = NO;
            temp.titleLabel.text = @"x√Y";
            [self functionButtonTouched:temp];
            break;
        case 2:
            isMath = NO;
            temp.titleLabel.text = @"^";
            [self functionButtonTouched:temp];
            break;
        case 3:
            operation = @"sin";
            [self mathOperation:@"sin" toDisplay:operation];
            break;
        case 4:
            operation = @"cos";
            [self mathOperation:@"cos" toDisplay:operation];
            break;
        case 5:
            operation = @"tan";
            [self mathOperation:@"tan" toDisplay:operation];
            break;
        case 6:
            operation = @"ln";
            [self mathOperation:@"ln" toDisplay:operation];
            break;
        case 7:
            operation = @"log";
            [self mathOperation:@"log" toDisplay:operation];
            break;
        case 8:
            operation = @"e";
            [self mathOperation:@"e" toDisplay:operation];
            break;
        case 9:
            isMath = NO;
            temp.titleLabel.text = [NSString stringWithFormat:@"%g", M_PI];
            [self buttonTouched:temp];
            break;
        case 10:
            isMath = NO;
            double randomNumber = arc4random_uniform(1000);
            temp.titleLabel.text = [NSString stringWithFormat:@"%g", randomNumber];
            [self buttonTouched:temp];
            break;
        case 11:
            operation = @"1x";
            [self mathOperation:operation toDisplay:@"(1/x)"];
            break;
        default:
            break;
    }
    
}

- (void)functionButtonTouched:(UIButton *)sender
{
    
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
        
        NSNumber *checkNumber = [NSNumber numberWithDouble:[self.resultLabel.text doubleValue]];
        NSString *checkedString = [NSString stringWithFormat:@"%@", checkNumber];
        
        isStilTyping = NO;
        if (!isMath) {
            self.expressionLabel.text = [self.expressionLabel.text stringByAppendingString:checkedString];
            self.expressionLabel.text = [self.expressionLabel.text stringByAppendingString:sender.titleLabel.text];
        } else {
            self.expressionLabel.text = [self.expressionLabel.text stringByAppendingString:sender.titleLabel.text];
            isMath = NO;

        }
        
        [[self calculator] choosenOperation:sender.titleLabel.text withNumber:checkedString];
        
        self.resultLabel.text = [NSString stringWithFormat:@"%@", [self calculator].mathResult];
    }
    
}

- (void)buttonTouched:(UIButton *)sender
{
    if (equalPressed) {
        [self clearData];
        equalPressed = NO;
    }
    
    NSString *symbol = sender.titleLabel.text;
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
            
            if (!isMath) {
                self.expressionLabel.text = [self.expressionLabel.text stringByAppendingString:self.resultLabel.text];
                self.expressionLabel.text = [self.expressionLabel.text stringByAppendingString:@"="];
                [[self calculator] choosenOperation:@"" withNumber:self.resultLabel.text];
                
            } else {
                self.expressionLabel.text = [self.expressionLabel.text stringByAppendingString:@"="];
            }
            
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
        calculator = [[[CalculatorMath alloc] init] retain];
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

- (void)dealloc
{
    self.basicKeyboard = nil;
    self.advancedKeyboard = nil;
    self.advancedKeyboard = nil;
    self.keyboardView = nil;
    self.keyboardIndicator = nil;
    
    self.screenView = nil;
    self.resultLabel = nil;
    self.expressionLabel = nil;
    self.functionView = nil;
    calculator = nil;
    [calculator release];
    [super dealloc];
}

@end
