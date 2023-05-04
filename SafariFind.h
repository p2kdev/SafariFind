@interface BrowserController
- (void)findKeyPressed;
@end

@interface _SFBarManager : NSObject
@end

@interface SFBarRegistration: NSObject
@end

@interface BrowserToolbar: UIToolbar
    @property SFBarRegistration *barRegistration;
@end

@interface BrowserRootViewController: UIViewController
    @property BrowserController *delegate;
    @property BrowserToolbar *bottomToolbar;
    @property BrowserToolbar *primaryBar;
    - (void)safariFind_addGestureRecognizer;
    - (void)safariFind_gestureRecognizerDidFire;
@end

@interface SFBarButtonItemLongPressGestureRecognizer : UILongPressGestureRecognizer
    - (void)safariFind_gestureRecognizerDidFire;
@end

@interface UIBarButtonItem (SafariFind)
    @property BOOL _sf_longPressEnabled;
    @property NSArray* _gestureRecognizers;
@end