#import <UIKit/UIKit.h>
#import "SafariFind.h"

%hook BrowserRootViewController

	- (void)viewDidLoad {
		%orig;
		[self safariFind_addGestureRecognizer];
	}

	%new
	- (void)safariFind_addGestureRecognizer {				
		
		UILongPressGestureRecognizer *safariFindGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(safariFind_gestureRecognizerDidFire)];
		if (@available(iOS 15, *))
			[[[[[self primaryBar] barRegistration] valueForKey:@"_shareItem"] valueForKey:@"_view"] addGestureRecognizer:safariFindGestureRecognizer];
		else
			[[[[[self bottomToolbar] barRegistration] valueForKey:@"_shareItem"] valueForKey:@"_view"] addGestureRecognizer:safariFindGestureRecognizer];			
	}

	%new
	- (void)safariFind_gestureRecognizerDidFire {
		if (@available(iOS 16, *))
			[[self delegate] find:nil];
		else
			[[self delegate] findKeyPressed];
	}

%end

%group iOS15Only 

	%hook _UIButtonBarButton

		-(void)setHighlighted:(BOOL)arg1
		{
			%orig;
			for(UIView *view in [self subviews])
			{
				if ([view isKindOfClass:%c(_UIModernBarButton)])
				{
					if ([(UIButton*)view currentImage] && [[[(UIButton*)view currentImage] description] containsString:@"symbol(system: square.and.arrow.up)"])
					{
						self.contextMenuEnabled = NO; //This is needed post iOS 15.2 or 15.3 for the gesture to fire
						break;
					}
				}
			}
		}
	%end

%end

%ctor
{
	if (@available(iOS 15, *))
		%init(iOS15Only);

	%init;
}