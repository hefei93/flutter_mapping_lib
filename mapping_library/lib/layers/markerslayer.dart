import 'dart:developer';
import 'dart:ui';
import '../core/viewport.dart';
import 'Markers/markerbase.dart';
import '../utils/mapposition.dart';
import 'Markers/markers.dart';
import 'layer.dart';
import '../utils/geopoint.dart';

class MarkersLayer extends Layer {
  MarkersLayer() {
    _markers = new Markers();
  }

  Markers _markers;
  void AddMarker(MarkerBase marker) {
    _markers.add(marker);
    marker.setUpdateListener(_markerUpdated);
    fireUpdatedLayer();
  }

  void _markerUpdated(MarkerBase marker) {
    _setupMarkersForViewport();
  }

  void paint(Canvas canvas, Size size) {
    for (MarkerBase marker in _markers) {
      if (marker.WithinViewport(_viewport)) {
        //log("Draw marker: " + marker.Name);
        marker.paint(canvas);
      }
    }
  }

  @override
  void notifyLayer(MapPosition mapPosition, Viewport viewport) {
    // Calculate the position if the Markers for the current viewport and mapPosition
    _mapPosition = mapPosition;
    _viewport = viewport;
    _setupMarkersForViewport();
  }

  @override
  void doTabCheck(GeoPoint clickedPosition, Offset screenPos){
    for (MarkerBase marker in _markers) {
      if (marker.MarkerSelectedByScreenPos(screenPos)) {
        _fireMarkerSelected(marker);
      }
    }
  }

  Function(MarkerBase marker) MarkerSelected;
  void _fireMarkerSelected(MarkerBase marker) {
    if (MarkerSelected != null) {
      MarkerSelected(marker);
    }
  }

  void _setupMarkersForViewport() {
    for (MarkerBase marker in _markers) {
      marker.CalculatePixelPosition(_viewport, _mapPosition);
      marker.doDraw().then(_imageRetrieved);
    }
  }

  void _imageRetrieved(Image image) {
    fireUpdatedLayer();
  }

  MapPosition _mapPosition;
  Viewport _viewport;
}