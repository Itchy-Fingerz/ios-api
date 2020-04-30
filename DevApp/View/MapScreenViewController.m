#import "MapScreenViewController.h"
#import "GlobalState.h"
#import "MapScreenViewModel.h"

@import Wrld;
@import WrldNavWidget;
@import WrldNavWrld;
@import WrldNavSearch;
@import WrldWidgets;

@interface MapScreenViewController ()<WRLDMapViewDelegate>
{
   MapScreenViewModel *m_mapScreenVM;
}
@property (nonatomic) WRLDIndoorControlView *indoorControlView;
@property (weak, nonatomic) IBOutlet WRLDMapView *mapView;
@property (weak, nonatomic) IBOutlet WRLDNavWidgetBase *navWidget;
@end

@implementation MapScreenViewController

#pragma mark: View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_mapScreenVM = [[MapScreenViewModel alloc] initWith:_mapView];
    [_navWidget disableNavigationExitOption];
    [[_navWidget observer] setNavModel:[GlobalState instance].navModel];
    [self.view addSubview:[[m_mapScreenVM getNavSearchWidget] getSearchWidgetView]];
    _indoorControlView = [[WRLDIndoorControlView alloc] initWithFrame:self.view.bounds];
    
    [_indoorControlView setMapView:_mapView];
    
    [self.view addSubview:_indoorControlView];
    
}
@end

