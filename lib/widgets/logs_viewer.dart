import 'package:alisthelper/provider/alist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogListTile extends StatelessWidget {
  final String logText;

  const LogListTile({super.key, required this.logText});

  @override
  Widget build(BuildContext context) {
    bool isWarning = logText.contains('WARN') ||
        logText.contains('ERR') ||
        logText.contains('FATA');
    return ListTile(
        leading: Icon(isWarning ? Icons.warning : Icons.info,
            color: isWarning ? Colors.amber : Colors.teal),
        title: Text(logText),
        trailing: IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () => Clipboard.setData(ClipboardData(text: logText))));
  }
}


class LogsViewer extends ConsumerWidget {
  final ScrollController scrollController = ScrollController();

  LogsViewer({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> output = ref.watch(alistProvider).output;
    void scrollDown() {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollDown());
    return ListView.builder(
      shrinkWrap: true,
      controller: scrollController,
      itemCount: output.length,
      itemBuilder: (context, index) {
        return LogListTile(logText: output[index]);
      }
    );
  }
}