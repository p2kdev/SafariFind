#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "SafariFind.h"

//Credit to opa334 https://github.com/opa334/SafariPlus/blob/master/MobileSafari/Hooks/SFBarRegistration.xm

extern "C" {
	id objc_msgSendSuper2(struct objc_super *super, SEL op, ...);
}

void configureBarButtonItem(UIBarButtonItem* item, NSString* accessibilityIdentifier, NSString* title, id target, SEL longPressAction, SEL touchDownAction) {
	[item setAccessibilityIdentifier: accessibilityIdentifier];
	[item setTitle: title];
	if(touchDownAction) [item _sf_setTarget: target touchDownAction: touchDownAction longPressAction: longPressAction];
	else [item _sf_setTarget: target longPressAction: longPressAction];
}

%hook SFBarRegistration
%property (nonatomic, retain) UIBarButtonItem *findOnPageItem;

	- (instancetype)initWithBar: (_SFToolbar*)bar barManager: (id)barManager layout: (NSInteger)layout persona: (NSUInteger)persona
	{
		if(persona == 0 && layout == 2)
		{
			objc_super super;
			super.receiver = self;
			super.super_class = [self class];

			self = objc_msgSendSuper2(&super, @selector(init));

			[self setValue: bar forKey: @"_bar"];
			[self setValue: barManager forKey: @"_barManager"];
			[self setValue: @(layout) forKey: @"_layout"];

			NSMutableArray* barButtonItems = [NSMutableArray new];
			[barButtonItems addObject: @0];
			[barButtonItems addObject: @1];
			[barButtonItems addObject: @3];
			[barButtonItems addObject: @6];
			[barButtonItems addObject: @777];
			[barButtonItems addObject: @7];
			[barButtonItems addObject: @8];

			[self setValue: [NSOrderedSet orderedSetWithArray: [barButtonItems copy]] forKey: @"_arrangedBarItems"];
			[self setValue: [[NSMutableSet alloc] init] forKey: @"_hiddenBarItems"];

			// 0: back 1: forward 2: bookmarks 3: share 4: add tab 5: tabs

			UIBarButtonItem* backItem = [self _newBarButtonItemForSFBarItem: 0];
			configureBarButtonItem(backItem, @"BackButton", @"Back (toolbar accessibility title)", self, @selector(_itemReceivedLongPress:), nil);
			[self setValue: backItem forKey: @"_backItem"];

			UIBarButtonItem* forwardItem = [self _newBarButtonItemForSFBarItem: 1];
			configureBarButtonItem(forwardItem, @"ForwardButton", @"Forward (toolbar accessibility title)", self, @selector(_itemReceivedLongPress:), nil);
			[self setValue: forwardItem forKey: @"_forwardItem"];

			UIBarButtonItem* bookmarksItem = [self _newBarButtonItemForSFBarItem: 3];
			configureBarButtonItem(bookmarksItem, @"BookmarksButton", @"Bookmarks (toolbar accessibility title)", self, @selector(_itemReceivedLongPress:), nil);
			bookmarksItem._additionalSelectionInsets = UIEdgeInsetsMake(2, 0, 3, 0);
			[self setValue: bookmarksItem forKey: @"_bookmarksItem"];

			UIBarButtonItem* shareItem = [self _newBarButtonItemForSFBarItem: 6];
			configureBarButtonItem(shareItem, @"ShareButton", @"Share (toolbar accessibility title)", self, @selector(_itemReceivedLongPress:), @selector(_itemReceivedTouchDown:));
			[self setValue: shareItem forKey: @"_shareItem"];

			UIBarButtonItem* findItem = [self _newBarButtonItemForSFBarItem: 777];
			[self setValue: findItem forKey: @"findOnPageItem"];			

			UIBarButtonItem* newTabItem = [self _newBarButtonItemForSFBarItem: 7];
			configureBarButtonItem(newTabItem, @"NewTabButton", @"New Tab (toolbar accessibility title)", self, @selector(_itemReceivedLongPress:), nil);
			[self setValue: newTabItem forKey: @"_newTabItem"];

			UIBarButtonItem* tabExposeItem = [self _newBarButtonItemForSFBarItem: 8];
			configureBarButtonItem(tabExposeItem, @"TabsButton", @"Tabs (toolbar accessibility title)", self, @selector(_itemReceivedLongPress:), nil);
			[self setValue: tabExposeItem forKey: @"_tabExposeItem"];	

			//5 //elipsis circle

			//9 //open in safari

			//11 //Download

			//13 Aa

			//14 x

			//15 refresh

			//16 person

			return self;
		}
		else
			return %orig;
	}

	-(void)setBarItem:(long long)arg1 enabled:(BOOL)arg2 {
		%orig;
		if (arg1 == 6) //Disable/Enable based on the status of the share button
			self.findOnPageItem.enabled = arg2;
	}

	-(id)_newBarButtonItemForSFBarItem:(long long)arg1 {
        if(arg1 == 777)
            return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(findOnPage)];
		return %orig;
	}

	-(id)_UIBarButtonItemForBarItem:(long long)arg1 {
		if (arg1 == 777)
			return self.findOnPageItem;

		return %orig;
	}

	- (NSInteger)_barItemForUIBarButtonItem:(UIBarButtonItem*)item {
		if (item == self.findOnPageItem)
			return 777;

		return %orig;
	}

	%new
	-(void)findOnPage {
		if (@available(iOS 16, *))
			[[MSHookIvar<_SFBarManager*>(self,"_barManager") delegate] find:nil];
		else
			[[MSHookIvar<_SFBarManager*>(self,"_barManager") delegate] findKeyPressed];
	}

%end