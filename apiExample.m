// Here's an example of using the Mattermost API from Cocoa on iOS (or macOS)
// If you're writing in S***ft, look up "URL Loading System" in the Apple iOS docs.
// This posts "Signed in John Smith" to a channel

- (void)notifySignIn:(ItemUse *)itemUse isIn:(BOOL)isIn
{
	NSString *msg = @"Signed in John Doe"
	// To get the channel_id, you're supposed to be able to use the Mattermost command line.
	// https://docs.mattermost.com/administration/command-line-tools.html
	// But I gave up and got it directly by browsing the SQL database on the server.
	NSDictionary *jsonDict = @{@"channel_id":@"3xiahsdfthisisnotrealxihaofe", @"message" : msg };
	
	NSData *json = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:nil];
	NSAssert(json, @"json not encoded");
	
	// If you use a nonstandard port, include it (":8888") in the url
	NSURL *url = [NSURL URLWithString:@"https://mattermost.example.com/api/v4/posts"];
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
	req.HTTPMethod = @"POST";
	req.HTTPBody = json;
	[req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[req setValue:@"Bearer 9adoijfoaethisisnotreal" forHTTPHeaderField:@"Authorization"];
	
	NSURLSession *sess = [NSURLSession sharedSession];
	NSURLSessionDataTask *task = [sess dataTaskWithRequest:req completionHandler:
		^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		// log the response (for debugging)
		NSLog(@"Task completed with %ld response: %@", (long)[(NSHTTPURLResponse *)response statusCode],
			[(NSHTTPURLResponse *)response allHeaderFields]);
	}];
	// Run the task:
	[task resume];
