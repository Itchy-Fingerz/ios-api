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
        
        NSMutableArray<NSString*>* floorNames = [NSMutableArray array];
        WRLDIndoorMap* indoorMap = [_mapView activeIndoorMap];
        for (WRLDIndoorMapFloor* floor in indoorMap.floors)
        {
            [floorNames addObject:floor.name];
        }
        
        [self.pIndoorControl updateFloors:floorNames withCurrentFloor:0];
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

- (void) onFloorSliderPressed
{
    [_mapView expandIndoorMapView];
}

- (void) onFloorSliderReleased:(int)floorIndex
{
    [_mapView setFloorByIndex:floorIndex];
    [_mapView collapseIndoorMapView];
}

- (void) onFloorSliderDragged:(float)floorInterpolation
{
    int numberOfFloors = [[_mapView activeIndoorMap].floors count];
    float interpolation = floorInterpolation * (numberOfFloors - 1);
    [_mapView setFloorInterpolation:interpolation];
}

@end
