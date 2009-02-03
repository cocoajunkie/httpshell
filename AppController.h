//
//  AppController.h
//  HttpShell
//
//  Created by Paul Litvak on 2/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppController : NSObject {
	IBOutlet NSComboBox* method;
	IBOutlet NSTextField* URL;
	IBOutlet NSTableView* requestHeadersView;
	NSMutableArray* requestHeaderNames;
	NSMutableArray* requestHeaderValues;
	IBOutlet NSTextView* requestBodyView;
	IBOutlet NSButton* sendButton;
	
	IBOutlet NSProgressIndicator* progress;
	IBOutlet NSTextField* status;
	IBOutlet NSTableView* responseHeadersView;
	NSMutableArray* responseHeaderNames;
	NSMutableArray* responseHeaderValues;
	IBOutlet NSTextView* responseBodyView;	
	NSMutableData* responseBody;
	NSStringEncoding responseEncoding;
	
	NSURLConnection* connection;
}
- (IBAction)sendRequest:(id)sender;
- (IBAction)cancelRequest:(id)sender;
@end
