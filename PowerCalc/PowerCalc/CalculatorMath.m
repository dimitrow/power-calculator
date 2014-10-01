//
//  CalculatorMath.m
//  PowerCalc
//
//  Created by Eugene Dimitrow on 9/24/14.
//  Copyright (c) 2014 Eugene Dimitrow. All rights reserved.
//

#import "CalculatorMath.h"

@implementation CalculatorMath

#pragma mark math 

- (double)mathOperation:(NSString *)operation withValue:(NSString *)value
{
    double result = 0;
    double number = value.doubleValue;
    double rads = (value.doubleValue * M_PI)/180;
    
    if ([operation isEqualToString:@"squareRoot"]) {
        result = sqrt(number);
    }
    else if ([operation isEqualToString:@"sin"]) {
        result = sin(rads);
    }
    else if ([operation isEqualToString:@"cos"]) {
        result = cos(rads);
    }
    else if ([operation isEqualToString:@"tan"]) {
        result = tan(rads);
    }
    else if ([operation isEqualToString:@"ln"]) {
        result = log10(number);
    }
    else if ([operation isEqualToString:@"log"]) {
        result = log(number);
    }
    else if ([operation isEqualToString:@"e"]) {
        result = exp(number);
    }
    else if ([operation isEqualToString:@"1x"]) {
        result = 1/number;
    }
//    else if ([operation isEqualToString:@"pow"]) {
//        result = tan(rads);
//    }
    
    self.mathResult = [NSString stringWithFormat:@"%g", result];
    [[self operations] removeAllObjects];
    [[self numbers] removeAllObjects];

    NSLog(@"math:%@ with:%@", operation, value);
    return result;
}

- (double)choosenOperation:(NSString *)operation withNumber:(NSString *)number
{
    double result = 0;
    
    [[self operations] addObject:operation];
    [[self numbers] addObject:number];
    NSString *action = [[self operations] firstObject];
    
    double firstOperator = [[[self numbers] firstObject] doubleValue];
    double secondOperator = [[[self numbers] lastObject] doubleValue];
    
    
    if ([[self numbers] count] == 1) {
        
        result = [[[self numbers] lastObject] doubleValue];
        
    } else {
        
        if ([action isEqualToString:@"squareRoot"]) {
            result = sqrt(secondOperator);
            
        }
        if ([action isEqual:@"+"]) {
            
            result = firstOperator + secondOperator;
            
        }
        else if ([action isEqual:@"−"]) {
            
            result = firstOperator - secondOperator;
            
        }
        else if ([action isEqual:@"×"]) {
            
            result = firstOperator * secondOperator;
            
        }
        else if ([action isEqual:@"÷"]) {
            
            result = firstOperator / secondOperator;
            
        }
        else if ([action isEqual:@"^"]) {
            
            result = pow(firstOperator, secondOperator);
            
        }
        else if ([action isEqual:@"x√Y"]) {
            
            result = pow(firstOperator, secondOperator);
            
        }

        [[self numbers] removeAllObjects];
        [[self numbers] addObject:[NSString stringWithFormat:@"%g", result]];
        [[self operations] removeAllObjects];
        [[self operations] addObject:operation];
        
    }

    self.mathResult = [NSString stringWithFormat:@"%@", [[self numbers] firstObject]];
    return result;
}

- (void)clear
{
    [numbers removeAllObjects];
    [operations removeAllObjects];
    self.mathResult = nil;
}

#pragma mark lazy initialization of arrays

- (NSMutableArray *)operations
{
    if (!operations) {
        operations = [[NSMutableArray alloc] init];
    }
    return operations;
}

- (NSMutableArray *)numbers
{
    if (!numbers) {
        numbers = [[NSMutableArray alloc] init];
    }
    return numbers;
}
@end
