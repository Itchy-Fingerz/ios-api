#import "IndoorControlViewController.h"
#import "IndoorControl.h"
#import "IndoorControlDelegate.h"
@import Wrld;


@interface IndoorControlViewController () <IndoorControlDelegate>

@property (nonatomic) IBOutlet WRLDMapView *mapView;
@property (nonatomic, retain) IndoorControl* pIndoorControl;

- (void) onCancelButtonPressed;

@end

@implementation IndoorControlViewController

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.backgroundColor = [UIColor clearColor];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat pixelScale = [[UIScreen mainScreen] scale];
    self.pIndoorControl = [[IndoorControl alloc] initWithParams: screenSize.width : screenSize.height : pixelScale andDelegate: self];
    [self addSubview:self.pIndoorControl];
    
    return self;
}

- (UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* hitView = [super hitTest:point withEvent:event];
    
    if (hitView == self)
    {
        [self dummyUpdate];
        return nil;
    }
    
    return hitView;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
}

- (void) dummyUpdate
{
    if (_mapView.isIndoors)
    {
        [self.pIndoorControl setFullyOnScreen];
        [self.pIndoorControl setTouchEnabled:YES];
    }
    else
    {
        [self.pIndoorControl setTouchEnabled:NO];
        [self.pIndoorControl setFullyOffScreen];
    }
}

- (void) onCancelButtonPressed
{
    [_mapView exitIndoorMap];
}

- (void) onFloorSliderReleased:(int)floorIndex
{
    [_mapView setFloorByIndex:floorIndex];
}

@end