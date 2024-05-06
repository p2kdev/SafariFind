#import <UIKit/UIKit.h>
#import "SafariFind.h"

UIBarButtonItem *findItem;

%hook BrowserToolbar
	-(void)setItems:(id)toolbarItems {
		NSMutableArray<UIBarButtonItem *> *itemsArray;
		itemsArray = [toolbarItems mutableCopy];

		findItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(findOnPage)];
		[itemsArray insertObject:findItem atIndex:[itemsArray count] - 2];


		UIBarButtonItem *addTabButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openNewTab)];
		[itemsArray insertObject:addTabButton atIndex:[itemsArray count] - 1];		

		%orig(itemsArray);
	}

	%new
	-(void)findOnPage {
		[self sf_performAction:0];
	}

	%new
	-(void)openNewTab {
		[self sf_performAction:1];
	}

	%new
	-(void)sf_performAction:(int)action {
		CapsuleNavigationBarViewController *capsuleViewController = [self _viewControllerForAncestor];

		if (capsuleViewController) {

			BrowserController *controller = [capsuleViewController customNextResponder];

			if (controller) {
				if (action == 0) {
					if (@available(iOS 16, *))
						[controller find:nil];
					else
						[controller findKeyPressed];
				}
				else
					[controller openNewTab:nil];
			}
		}
	}		

%end

%hook SFBarRegistration

	-(void)setBarItem:(long long)arg1 enabled:(BOOL)arg2 {
		%orig;
		if (arg1 == 6)
			findItem.enabled = arg2;
	}

%end