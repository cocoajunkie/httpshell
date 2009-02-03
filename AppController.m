//
//  AppController.m
//  HttpShell
//
//  Created by Paul Litvak on 2/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"


@implementation AppController

- (void)awakeFromNib {
	responseBody = [NSMutableData dataWithLength:0];
	responseHeaderNames = [NSMutableArray array];
	responseHeaderValues = [NSMutableArray array];
	requestHeaderNames = [NSMutableArray array];
	requestHeaderValues = [NSMutableArray array];
}

- (void)_setCancelUI {
	[sendButton setAction:@selector(cancelRequest:)];
	[sendButton setTitle:@"Cancel"];
	[progress startAnimation:self];	
}

- (void)_setSendUI {
	[sendButton setAction:@selector(sendRequest:)];
	[sendButton setTitle:@"Send"];
	[progress stopAnimation:self];	
}

- (IBAction)sendRequest:(id)sender {
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URL objectValue]]];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
	[request setHTTPMethod:[method objectValue]];
	connection = [NSURLConnection connectionWithRequest:request delegate:self];
	[connection start];
	[self _setCancelUI];
	[status setObjectValue:@""];
	[[[responseBodyView textStorage] mutableString] setString:@""]; 
	[responseBody setLength:0];
	[responseHeaderNames removeAllObjects];
	[responseHeaderValues removeAllObjects];
	[responseHeadersView reloadData];
}

- (IBAction)cancelRequest:(id)sender; {
	[connection cancel];
	[self _setSendUI];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[self _setSendUI];			
	NSString* text = [[NSString alloc] initWithData:responseBody encoding:responseEncoding];
	[[[responseBodyView textStorage] mutableString] appendString:text]; 	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;

	NSString* statusString = [NSString stringWithFormat:@"%d %@", [httpResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]];
	[status setObjectValue:statusString];

	for (NSString* name in [httpResponse allHeaderFields]) {
		[responseHeaderNames addObject:name];
		[responseHeaderValues addObject:[[httpResponse allHeaderFields] objectForKey:name]];
	}
	[responseHeadersView reloadData];	
	
	NSString* encodingName = [httpResponse textEncodingName];
	if (!encodingName)
		encodingName = @"iso-8859-1";
	responseEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((CFStringRef)encodingName));
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseBody appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[self _setSendUI];	
	[NSApp presentError:error];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	if (aTableView == responseHeadersView)
		return [responseHeaderNames count];
	else
		return [requestHeaderNames count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	NSMutableArray* names;
	NSMutableArray* values;
	if (aTableView == responseHeadersView) {
		names = responseHeaderNames;
		values = responseHeaderValues;
	}
	else {
		names = requestHeaderNames;
		values = requestHeaderValues;
	}
	
	if ([[aTableColumn identifier] isEqualTo:@"name"])
		return [names objectAtIndex:rowIndex];
	else if ([[aTableColumn identifier] isEqualTo:@"value"])
		return [values objectAtIndex:rowIndex];
	else
		return nil;
}

@end



