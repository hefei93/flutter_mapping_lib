import 'dart:async';
import 'package:flutter/widgets.dart';
import '../utils/geopoint.dart';
import '../utils/mapposition.dart';
import '../core/mapviewport.dart' as viewPort;
import 'layer.dart';
import 'layers.dart';

class LayerPainter extends ChangeNotifier implements CustomPainter {
  LayerPainter() {
    _layers = new Layers();
    _startPaintFps();
  }

  Layers _layers;
  bool _repaint = false;

  void addLayer(Layer layer) {
    layer.setUpdateListener(_layerUpdated);
    _layers.add(layer);
  }

  void notifyLayers(MapPosition mapPosition, viewPort.MapViewport viewport) {
    // TODO: implement notifyLayer
    for (Layer l in _layers) {
      l.notifyLayer(mapPosition, viewport);
    }
  }

  void doLayerTabCheck(GeoPoint clickedPosition, Offset screenPos) {
    for (Layer l in _layers) {
      l.doTabCheck(clickedPosition, screenPos);
    }
  }

  void _layerUpdated(Layer layer) {
    //if (_updateMapView != null) _updateMapView();
    //notifyListeners();
    _repaint = true;
  }

  void _startPaintFps() {
    Timer.periodic(new Duration(milliseconds: 20), _frameDraw);
  }

  void _frameDraw(Timer timer) {
    if (_repaint) {
      _repaint = false;
      notifyListeners();
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    for (Layer l in _layers) {
      l.paint(canvas, size);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

  @override
  bool hitTest(Offset position) {
    // TODO: implement hitTest
    return null;
  }

  @override
  // TODO: implement semanticsBuilder
  get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    // TODO: implement shouldRebuildSemantics
    return true;
  }
}