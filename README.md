# PDF viewer for flutter

Android and iOS working pdf viewer!

# Use this package as a library

## 1. 添加依赖

在项目配置文件中添加 pubspec.yaml file:

```
dependencies:
  flutter_pdf_plugin: ^1.0.0
```


### 2. 加载依赖



```
$ flutter packages get
```


### 3. 导包

Now in your Dart code, you can use:

```
import 'package:flutter_pdf_plugin/flutter_pdf_plugin.dart';
```

### 4. 加载 网络地址 pdf文件

```
    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) { 
      return PdfNetScaffold(
          pdfUrl: "http://www.jinbangshichuang.com/20201209105650.pdf");
    }));

```

### 5. 加载pdf文件

```
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String pathPDF = "";

  @override
  void initState() {
    super.initState();
    createFileOfPdfUrl().then((f) {
      setState(() {
        pathPDF = f.path;
        print(pathPDF);
      });
    });
  }

  Future<File> createFileOfPdfUrl() async {
    final url = "http://africau.edu/images/default/sample.pdf";
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: Center(
        child: RaisedButton(
          child: Text("Open PDF"),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PDFScreen(pathPDF)),
          ),
        ),
      ),
    );
  }
}

class PDFScreen extends StatelessWidget {
  String pathPDF = "";
  PDFScreen(this.pathPDF);

  @override
  Widget build(BuildContext context) {
    return PdfScaffold(
        appBar: AppBar(
          title: Text("Document"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
        path: pathPDF);
  }
}


```