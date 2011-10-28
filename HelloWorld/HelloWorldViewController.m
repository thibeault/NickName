//
//  HelloWorldViewController.m
//  HelloWorld
//
//  Created by Eric Thibeault on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldViewController.h"
#import "JSON.h"
#import <stdlib.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define debug(format, ...) CFShow([NSString stringWithFormat:format, ## __VA_ARGS__]);

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Private interface definitions
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
@interface HelloWorldViewController(private)
- (BOOL)greekAction:(id)sender;
- (BOOL)copyToClipboard:(id)sender;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)sendNickName:(NSString *)text;
- (void)loadToClipboard:(NSString *)text;
@end


@implementation HelloWorldViewController
@synthesize nameTextField;
@synthesize copyToClipBoardButton;
@synthesize greekLabel;
@synthesize activityIndicator;
@synthesize email;

- (void)dealloc
{
    [nameTextField release];
    [greekLabel release];
    [activityIndicator release];
    [email release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.*/
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setGreekLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return interfaceOrientation !=UIInterfaceOrientationPortraitUpsideDown; // right for iphone but ipad we can return true
}



- (IBAction)greekAction:(id)sender {
    
    [nameTextField resignFirstResponder];

    
    // get the nickname from the name Text Field
    nickname = [nameTextField text];
    
    // remove the text from the text field
    [nameTextField setText: @""];
    // add the entered nickname into the placeholder (shadow text)
    [nameTextField setPlaceholder: nickname];

    [copyToClipBoardButton setHidden:TRUE];
    [activityIndicator startAnimating];

    NSLog(@"My nickname:%@ ",nickname);


    [self sendNickName: nickname];
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
-(void)sendNickName:(NSString *)text
{
    // Build the string to call the Flickr API
    // http://hack2011.com/hack2011/Default/CreateNickname?nickname=test

    //NSString *urlString = [NSString stringWithFormat:@"http://hack2011.com/hack2011/Default/CreateNickname?nickname=%@",text];
    // 10.52.78.125
    NSString *urlString = [NSString stringWithFormat:@"http://10.52.78.125/hack2011/Default/CreateNickname?nickname=%@&secret=p@ssword",text];
    
    // Create NSURL string from formatted string, by calling the Flickr API
	NSURL *url = [NSURL URLWithString:urlString];
    
    debug(@"%@", url);  
    
    // Setup and start async download
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    [request setHTTPMethod: @"POST"];
    
    //NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    [connection release];
    [request release];
    
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    // Store incoming data into a string
	NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    debug(@"CALLING:%@", jsonString);  
    
    // Create a dictionary from the JSON string
	NSDictionary *results = [jsonString JSONValue];
	
    NSString *status = [results objectForKey:@"status"];
    NSString *success = [results objectForKey:@"success"];
    self.email = [results objectForKey:@"email"];
    
    if (![status caseInsensitiveCompare:@""]) {
        [greekLabel setText: [NSString stringWithFormat: @"Oops, please try again!"]];
    } else {
        [greekLabel setText: [NSString stringWithFormat: @"%@",status]];
    }
    NSLog(@"email: %@",email);
    NSLog(@"Status: %@",status);
    NSLog(@"Success: %@",success);
    
    if (![email caseInsensitiveCompare:@""]) {
        NSLog(@"email is nil:%@",email);
        [copyToClipBoardButton setHidden:TRUE];
    } else {
        [copyToClipBoardButton setHidden:FALSE]; 
    }
    
    // Stop the activity indicator
    [activityIndicator stopAnimating];
    
	[jsonString release];  
}

/**************************************************************************
 *
 * Private implementation section
 *
 **************************************************************************/

- (IBAction)copyToClipboard:(id)sender {
    NSLog(@"trying to set the email to the clipboard: %@", self.email);

    [self loadToClipboard: email];
    
     NSLog(@"Setting the email to the clipboard:%@", self.email);
}

- (void)loadToClipboard:(NSString *) text {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = text;    
}

/*-------------------------------------------------------------
 *
 *------------------------------------------------------------*/
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//	[textField resignFirstResponder];
//    
//    [photoTitles removeAllObjects];
//    [photoSmallImageData removeAllObjects];
//    [photoURLsLargeImage removeAllObjects];
//    
//    [self sendNickName:searchTextField.text];
//    
//    [activityIndicator startAnimating];
    
//	return YES;
//}


@end
