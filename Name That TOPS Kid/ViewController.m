//
//  ViewController.m
//  Name That TOPS Kid
//
//  Created by Weichen Zhou on 2019-01-15.
//  Copyright © 2019 Weichen Zhou. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property NSMutableDictionary *topsKidsNames;
@property NSTimer *timer;

@end

@implementation ViewController

const NSInteger START_X = 20;
const NSInteger PADDING = 5;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.delegate = self;
    self.topsKidsNames = [[NSMutableDictionary alloc] init];
    
    NSString * const path = [[NSBundle mainBundle] pathForResource:@"Names" ofType:@"plist"];
    NSDictionary * const names = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSInteger x = START_X;
    NSInteger y = _textField.frame.origin.y + _textField.frame.size.height + PADDING;
    for (NSString * const key in names) {
        UITextView * const label = [[UITextView alloc] initWithFrame:CGRectMake(x, y, 0, 0)];
        [label setEditable:false];
        [label setText:key];
        [label setTextColor:[UIColor blackColor]];
        [label setBackgroundColor:[UIColor lightGrayColor]];
        label.layer.cornerRadius = 8.0;
//        [label setHidden:YES];
        [label sizeToFit];

        if (x + label.frame.size.width > self.view.frame.size.width) {
            x = START_X;
            y += label.frame.size.height + PADDING;
            CGRect frame = label.frame;
            frame.origin.x = x;
            frame.origin.y = y;
            label.frame = frame;
        }
        
        [self.view addSubview:label];
        x += (label.bounds.size.width + PADDING);
        
        NSArray * const spellings = [names[key] componentsSeparatedByString:@","];
        for (NSString * const spelling in spellings) {
            [_topsKidsNames setValue:label forKey:spelling];
        }
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:900 repeats:false block:^(NSTimer * _Nonnull timer) {
        [self.textField setEnabled:false];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textField) {
        NSString * const enteredName = [[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
        if ([_topsKidsNames objectForKey:enteredName]) {
            UILabel * const label = [_topsKidsNames objectForKey:enteredName];
            [label setHidden:NO];
        }
        [textField resignFirstResponder];
        return YES;
    }
    
    return NO;
}

@end
