import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  //create a pdf document
  final pdf = pw.Document();

  writeOnPdf() async {
    //carregando a logo e convertendo pra imagem
    final img = await rootBundle.load('assets/images/logogeraliftm.png');
    final imageBytes = img.buffer.asUint8List();
    pw.Image image1 = pw.Image(pw.MemoryImage(imageBytes));

    //usando fonte do sistema
    final theme = pw.ThemeData.withFont(
        base: pw.Font.helvetica(), bold: pw.Font.helveticaBold());

    //hardcoded data
    const tableHeaders = ['', 'Nome', 'RA'];
    const dataTable = [
      [1, 'Nome Exemplo', 'RA Exemplo'],
      [2, 'Robin', '69696969969']
    ];

    //creating table
    final table = pw.TableHelper.fromTextArray(
        data: List<List<dynamic>>.generate(
          dataTable.length,
          (index) => <dynamic>[
            dataTable[index][0],
            dataTable[index][1],
            dataTable[index][2],
          ],
        ),
        headers: tableHeaders,
        headerDecoration: const pw.BoxDecoration(color: PdfColors.grey),
        headerStyle: pw.TextStyle(
            color: PdfColors.white, fontWeight: pw.FontWeight.bold),
        cellStyle: const pw.TextStyle(color: PdfColors.black));

    //configure the pdf model using widgets
    pdf.addPage(
      pw.Page(
        theme: theme,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Container(height: 60, child: image1),
                  pw.Text(
                    'Data Fictícia',
                    style: pw.TextStyle(
                        fontSize: 20.4, fontWeight: pw.FontWeight.bold),
                  ),
                ]),
            pw.SizedBox(height: 15),
            pw.Center(
              child: pw.Text('Relatório de Frequências',
                  style: pw.TextStyle(
                      fontSize: 20.4, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 15),
            pw.Text('Nome do Evento:',
                style: pw.TextStyle(
                    fontSize: 13.5, fontWeight: pw.FontWeight.bold)),
            pw.Text('Nome da Atividade:',
                style: pw.TextStyle(
                    fontSize: 13.5, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 7),
            pw.Divider(color: PdfColors.grey, thickness: 1),
            pw.SizedBox(height: 8),
            table,
          ],
        ),
      ),
    );
  }

  Future savePdf() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    File file = File("$documentPath/relatorio_de_frequencias.pdf");

    file.writeAsBytesSync(await pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter PDF Tutorial'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Criar PDF'),
          onPressed: () async {
            await writeOnPdf();
            await savePdf();

            print("PDF Criado!");
          },
        ),
      ),
    );
  }
}
