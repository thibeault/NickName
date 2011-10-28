//
//  HelloWorldViewController.h
//  HelloWorld
//
//  Created by Eric Thibeault on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface HelloWorldViewController : UIViewController <UITextFieldDelegate> {
    
    UITextField *nameTextField;
    UILabel *greekLabel;
    UIButton *copyToClipBoardButton;
    NSString *nickname;
    NSString *email;
    UIActivityIndicatorView *activityIndicator;   
}

@property (nonatomic, copy) NSString *email;
@property (nonatomic, retain) IBOutlet UIButton *copyToClipBoardButton;
@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UILabel *greekLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;


- (IBAction)greekAction:(id)sender;
- (IBAction)copyToClipboard:(id)sender;


@end
