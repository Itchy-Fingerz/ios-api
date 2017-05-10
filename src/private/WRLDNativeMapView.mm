#import <Foundation/Foundation.h>

#import "WRLDNativeMapView.h"
#import "WRLDMapView+Private.h"
#include "EegeoMapApi.h"
#include "EegeoMarkersApi.h"
#include "EegeoIndoorsApi.h"
#include "EegeoApiHostModule.h"
#include "iOSApiRunner.h"



WRLDNativeMapView::WRLDNativeMapView(WRLDMapView* mapView, Eegeo::ApiHost::iOS::iOSApiRunner& apiRunner)
: m_mapView(mapView)
, m_apiRunner(apiRunner)
, m_initialStreamingCompleteHandler(this, &WRLDNativeMapView::OnInitialStreamingComplete)
, m_markerTappedHandler(this, &WRLDNativeMapView::OnMarkerTapped)
, m_enteredIndoorMapHandler(this, &WRLDNativeMapView::OnEnteredIndoorMap)
, m_exitedIndoorMapHandler(this, &WRLDNativeMapView::OnExitedIndoorMap)
{
    Eegeo::Api::EegeoMapApi& mapApi = GetMapApi();
    
    mapApi.RegisterInitialStreamingCompleteCallback(m_initialStreamingCompleteHandler);
    mapApi.GetMarkersApi().RegisterMarkerPickedCallback(m_markerTappedHandler);
    mapApi.GetIndoorsApi().RegisterIndoorMapEnteredCallback(m_enteredIndoorMapHandler);
    mapApi.GetIndoorsApi().RegisterIndoorMapExitedCallback(m_exitedIndoorMapHandler);
}

WRLDNativeMapView::~WRLDNativeMapView()
{
    Eegeo::Api::EegeoMapApi& mapApi = GetMapApi();
    
    mapApi.GetIndoorsApi().UnregisterIndoorMapExitedCallback(m_exitedIndoorMapHandler);
    mapApi.GetIndoorsApi().UnregisterIndoorMapEnteredCallback(m_enteredIndoorMapHandler);
    mapApi.UnregisterInitialStreamingCompleteCallback(m_initialStreamingCompleteHandler);
    mapApi.GetMarkersApi().UnregisterMarkerPickedCallback(m_markerTappedHandler);
}

void WRLDNativeMapView::OnInitialStreamingComplete()
{
    [m_mapView notifyInitialStreamingCompleted];
}

void WRLDNativeMapView::OnMarkerTapped(const Eegeo::Markers::IMarker& marker)
{
    [m_mapView notifyMarkerTapped:marker.GetId()];
}

void WRLDNativeMapView::OnEnteredIndoorMap()
{
    [m_mapView notifyEnteredIndoorMap];
}

void WRLDNativeMapView::OnExitedIndoorMap()
{
    [m_mapView notifyExitedIndoorMap];
}

Eegeo::Api::EegeoMapApi& WRLDNativeMapView::GetMapApi()
{
    return m_apiRunner.GetEegeoApiHostModule()->GetEegeoMapApi();
}
