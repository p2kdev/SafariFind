#import <UIKit/UIKit.h>
#import "SafariFind.h"

%hook BrowserRootViewController

	- (void)viewDidAppear:(BOOL)arg1 {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			[self safariFind_addGestureRecognizer];
		});
		%orig;
	}

	%new
	- (void)safariFind_addGestureRecognizer {

		UIBarButtonItem *shareItem;
		if (@available(iOS 15, *))
			shareItem = [[[self primaryBar] barRegistration] valueForKey:@"_shareItem"];
		else
			shareItem = [[[self bottomToolbar] barRegistration] valueForKey:@"_shareItem"];		
		
		UILongPressGestureRecognizer *safariFindGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(safariFind_gestureRecognizerDidFire)];
		[[shareItem valueForKey:@"_view"] addGestureRecognizer:safariFindGestureRecognizer];		
	}

	%new
	- (void)safariFind_gestureRecognizerDidFire {
		[[self delegate] findKeyPressed];
	}

%end