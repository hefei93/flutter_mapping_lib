import 'dart:async';
import 'dart:core';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import '../tiles/tilesource.dart';
import 'tile.dart';

class HttpTileSource extends TileSource
{
  HttpTileSource(String urlTemplate)
  {
    _urlTemplate = urlTemplate;
  }

  String _urlTemplate;

  @override
  Future<ui.Image> GetTileImage(Tile tile) async
  {
    String _url = _formatUrl(tile);
    Uint8List imgData = await _downloadImage(_url);
    return await _loadImage(imgData);
  }

  Future<ui.Image> _loadImage(List<int> imgData) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(imgData, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

    String _formatUrl(Tile tile)
  {
    String _url = _urlTemplate.replaceAll('##X##', tile.tileX.toString());
    _url = _url.replaceAll("##Y##", tile.tileY.toString());
    _url = _url.replaceAll('##Z##', tile.zoomLevel.floor().toString());
    return _url;
  }

  Future<Uint8List> _downloadImage(String url) async {
    http.Client client = new http.Client();
    var req = await client.get(Uri.parse(url));
    return req.bodyBytes;
  }
}