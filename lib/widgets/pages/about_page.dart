import 'package:alisthelper/widgets/pages/debug_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final _body = '''
          Alist Helper is an open source app to manage alist.
      
          Free. No tracking*. No ads.

          Currently, this app is available on Windows. 
          
          Adaptation plans for more platforms are in progress, if you need faster development speed, please consider donating to me.

          *The operating system may still gather usage data.
          '''
    .splitMapJoin(
  RegExp(r'^', multiLine: true),
  onMatch: (_) => '\n',
  onNonMatch: (n) => n.trim(),
);

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/alisthelper.png', height: 180, width: 180),
              const SizedBox(height: 20),
              const Text('Alist Helper',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20)
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '© ${DateTime.now().year} iiijam',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    await launchUrl(
                        Uri.parse('https://github.com/iiijam/alisthelper'),
                        mode: LaunchMode.externalApplication);
                  },
                  child: const Text('Source Code (Github)'),
                ),
                TextButton(
                  onPressed: () async {
                    await launchUrl(Uri.parse('https://alist.nn.ci/'));
                  },
                  child: const Text('Alist'),
                ),
                TextButton(
                  onPressed: () {
                    //jump to LicensePage() by flutter route
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LicensePage(
                                  applicationIcon: Image.asset(
                                      'assets/alisthelper.png',
                                      height: 100,
                                      width: 100),
                                )));
                  },
                  child: const Text('License'),
                ),
                TextButton(
                  onPressed: () {
                    //jump to LicensePage() by flutter route
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const DebugPage()));
                  },
                  child: const Text('Debug'),
                )
              ],
            ),
          ),
          Text(
            _body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
