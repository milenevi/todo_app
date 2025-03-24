import 'package:flutter/material.dart';
import '../widgets/about/about_app_bar.dart';
import '../widgets/about/info_section.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AboutAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            InfoSection(
              title: 'Desenvolvido por:',
              content: 'Milene Vieira Lopes',
            ),
            SizedBox(height: 24),
            InfoSection(
              title: 'Versão do app:',
              content: '1.0.0',
            ),
          ],
        ),
      ),
    );
  }
}
