import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class pdfView extends StatefulWidget {
  final String url;
  pdfView({required this.url});

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<pdfView> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  TextEditingController searchController = TextEditingController();
  late PdfViewerController _pdfViewerController;
  late PdfTextSearchResult _searchResult;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    _searchResult = PdfTextSearchResult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        actions: <Widget>[
          SizedBox(
            width: 60,
            child: Center(
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'search .....',
                  hintStyle: TextStyle(color: Colors.black,),
                ),
                onChanged: (value) {
                  // Perform actions when text changes
                  print('Search query: $value');
                },
                onSubmitted: (value) {
                  // Perform actions when submitted
                  print('Submitted query: $value');
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              _searchResult = _pdfViewerController.searchText(
                  searchController.text,
                  searchOption: TextSearchOption.caseSensitive);
              if (kIsWeb) {
                setState(() {});
              } else {
                _searchResult.addListener(() {
                  if (_searchResult.hasResult) {
                    setState(() {});
                  }
                });
              }
            },
          ),
          Visibility(
            visible: _searchResult.hasResult,
            child: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_up,
                color: Colors.black,
              ),
              onPressed: () {
                _searchResult.previousInstance();
              },
            ),
          ),
          Visibility(
            visible: _searchResult.hasResult,
            child: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
              ),
              onPressed: () {
                _searchResult.nextInstance();
              },
            ),
          ),
          Visibility(
            visible: _searchResult.hasResult,
            child: IconButton(
              icon: const Icon(
                Icons.clear,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _searchResult.clear();
                });
              },
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.black,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(
        '${widget.url}',
        controller: _pdfViewerController,
        key: _pdfViewerKey,
      ),
    );
  }
}
