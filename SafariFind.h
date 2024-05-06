@interface BrowserController
    - (void)findKeyPressed;
    - (void)find:(id)arg1;
    - (void)createNewTab;
    - (void)openNewTab:(id)arg1;
@end

@interface UIView (Private)
-(id)_viewControllerForAncestor;
@end

@interface CapsuleNavigationBarViewController : UIViewController
    -(BrowserController*)customNextResponder;
@end

@interface _SFBarManager : NSObject
@end

@interface SFBarRegistration: NSObject
@end

@interface BrowserToolbar: UIToolbar
    @property SFBarRegistration *barRegistration;
    -(void)sf_performAction:(int)action;
    -(void)findOnPage;
    -(void)openNewTab;
@end

@interface BrowserRootViewController: UIViewController
    @property BrowserController *delegate;
    @property BrowserToolbar *bottomToolbar;
    @property BrowserToolbar *primaryBar;
@end