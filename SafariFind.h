@interface BrowserController
    - (void)findKeyPressed;
    - (void)find:(id)arg1;
    - (void)openNewTab:(id)arg1;
@end

@interface UIView (Private)
    -(id)_viewControllerForAncestor;
@end

@interface UIBarButtonItem (Safari)
    - (void)_sf_setTarget:(id)target longPressAction:(SEL)longPressAction;
    - (void)_sf_setTarget:(id)target touchDownAction:(SEL)touchDownAction longPressAction:(SEL)longPressAction;
@end

@interface UIBarButtonItem (Private)
    @property(assign, setter=_setAdditionalSelectionInsets:, nonatomic) UIEdgeInsets _additionalSelectionInsets;
@end

@interface CapsuleNavigationBarViewController : UIViewController
    -(BrowserController*)customNextResponder;
@end

@interface _SFBarManager : NSObject
    @property(nonatomic) BrowserController *delegate;
@end

@interface SFBarRegistration: UIResponder
    - (id)initWithBar:(id)arg1 barManager:(id)arg2 layout:(NSInteger)arg3 persona:(NSUInteger)arg4;
    - (UIBarButtonItem *)UIBarButtonItemForItem:(NSInteger)arg1;
    - (UIBarButtonItem *)_newBarButtonItemForSFBarItem:(NSInteger)barItem;
    - (BOOL)containsBarItem:(NSInteger)barItem;
    -(long long)_barItemForUIBarButtonItem:(id)arg1;
    @property (nonatomic,retain) UIBarButtonItem *findOnPageItem;
@end

@interface _SFToolbar: UIToolbar
@end

@interface BrowserToolbar: _SFToolbar
    @property SFBarRegistration *barRegistration;
@end

@interface BrowserRootViewController: UIViewController
    @property BrowserController *delegate;
    @property BrowserToolbar *bottomToolbar;
    @property BrowserToolbar *primaryBar;
@end