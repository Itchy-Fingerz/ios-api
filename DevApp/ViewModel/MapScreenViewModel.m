#import <UIKit/UIKit.h>
#import "MapScreenViewModel.h"
#import "GlobalState.h"

//(56.45649, -2.970336)
#define START_POS_LAT 56.45649//31.496774//56.45649 //
#define START_POS_LON -2.970336//74.422272 //-2.970336
@interface MapScreenViewModel() <WRLDMapViewDelegate>
{
    WRLDNavWrldRoutingService *m_routeDirectionsController;
    WRLDNavWrldRouteDrawing *m_routeDrawingController;
    WRLDMapsceneService *service;
    WrldPoiSearchService *poiSearchService;
    WRLDNavSearchWidget *wrldNavSearchWidget;
    WRLDMapNavigation *wrldMapNavigationModule;

}

@end
@implementation MapScreenViewModel

-(instancetype) initWith:(WRLDMapView *) mapView
{
    self = [super init];
    if (self) {
        
        mapView.delegate = self;
        [mapView setCenterCoordinate:CLLocationCoordinate2DMake(START_POS_LAT, START_POS_LON)
                            zoomLevel:14
                             animated:NO];
        __auto_type navModel = [[GlobalState instance] navModel];

        wrldNavSearchWidget = [[WRLDNavSearchWidget alloc] initWith:navModel];

        poiSearchService = [[WrldPoiSearchService alloc] initWithWrldPoiService:[mapView createPoiService] wrldNavSearchProvider:[wrldNavSearchWidget getNavSearchProvider] wrldNavSuggestionProvider:[wrldNavSearchWidget getNavSuggestionProvider]];

        wrldMapNavigationModule = [[WRLDMapNavigation alloc] initWithWrldMap:mapView wrldNavModel:navModel];
        m_routeDirectionsController = [wrldMapNavigationModule getNavWrldRoutingService];
        m_routeDrawingController = [wrldMapNavigationModule getNavWrldRouteDrawingService];
        
    }
    
    return self;
}
#pragma mark - interface implementation methods

-(WrldPoiSearchService*)getMapSearchProvider
{
    return poiSearchService;
}
-(WRLDNavSearchWidget*)getNavSearchWidget
{
    return wrldNavSearchWidget;
}
#pragma mark - MapViewDelegate

- (void) mapView:(WRLDMapView *)mapView routingQueryDidComplete:(int)routingQueryId routingQueryResponse:(WRLDRoutingQueryResponse *)routingQueryResponse
{
    __auto_type navModel = [[GlobalState instance] navModel];
    navModel.showRoutingPopUp = false;
    if (routingQueryResponse.succeeded)
    {
        if([routingQueryResponse.results count]<1)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No route found" message:@"No route was found for this start and end location" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
            [rootVC presentViewController:alert animated:YES completion:nil];
        }
        [m_routeDirectionsController mapView:mapView routingQueryDidComplete:routingQueryId routingQueryResponse:routingQueryResponse];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No route found" message:@"No route was found for this start and end location" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
        [rootVC presentViewController:alert animated:YES completion:nil];
    }
}

- (void)mapView:(WRLDMapView *)mapView didTapMap:(WRLDCoordinateWithAltitude)coordinateWithAltitude
{
    WRLDIndoorMap *currentIndoorMap = mapView.activeIndoorMap;
    NSArray<WRLDIndoorMapFloor*> *floors = currentIndoorMap.floors;
    NSInteger currentFloorID = 0;
    if (floors.count > 0 && mapView.currentFloorIndex < floors.count)
    {
        currentFloorID = [floors objectAtIndex:mapView.currentFloorIndex].floorNumber;
    }
    [[wrldNavSearchWidget getLocationPickerHandler] pickedWithLocation:coordinateWithAltitude.coordinate indoorID:mapView.activeIndoorMap.indoorId floorID:currentFloorID];
}

-(void) mapView:(WRLDMapView *)mapView poiSearchDidComplete:(int)poiSearchId poiSearchResponse:(WRLDPoiSearchResponse *)poiSearchResponse
{
    [poiSearchService UpdateResults:poiSearchId poiSearchResponse:poiSearchResponse];
}

@end
