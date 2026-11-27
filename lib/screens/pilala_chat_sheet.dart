import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/deteksi_sampah_service.dart';
import '../services/kebersihan_ai_service.dart';
import '../services/pilala_firebase.dart';

class PilalaChatSheet extends StatefulWidget {
  const PilalaChatSheet({super.key});

  @override
  State<PilalaChatSheet> createState() => _PilalaChatSheetState();
}

class _PilalaChatSheetState extends State<PilalaChatSheet> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _imagePicker = ImagePicker();
  final _chatService = KebersihanAIService();
  final _detectionService = DeteksiSampahService();
  final List<_PilalaMessage> _messages = [
    const _PilalaMessage(
      text:
          'Halo! Aku Pilala. Tanya aku tentang kebersihan, sampah, atau daur ulang.',
      fromUser: false,
    ),
  ];

  ChatSession? _chat;
  bool _isBusy = false;
  String? _setupError;

  @override
  void initState() {
    super.initState();
    _setupError = PilalaFirebase.initializationError;
    if (_setupError == null) {
      _startChat();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _startChat() async {
    try {
      final chat = await _chatService.startChat();
      if (!mounted) return;
      setState(() {
        _chat = chat;
        _setupError = null;
      });
    } on Exception catch (error) {
      if (!mounted) return;
      setState(() => _setupError = error.toString());
    }
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isBusy || _setupError != null) return;

    _textController.clear();
    setState(() {
      _messages.add(_PilalaMessage(text: text, fromUser: true));
      _isBusy = true;
    });
    _scrollToBottom();

    try {
      final chat = _chat ?? await _chatService.startChat();
      _chat = chat;
      final response = await _chatService.sendMessage(chat, text);
      if (!mounted) return;
      setState(() {
        _messages.add(_PilalaMessage(text: response, fromUser: false));
      });
    } on Exception catch (error) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          _PilalaMessage(
            text: 'Pesan belum dapat diproses: $error',
            fromUser: false,
            isError: true,
          ),
        );
      });
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
        _scrollToBottom();
      }
    }
  }

  Future<void> _showImageOptions() async {
    if (_isBusy || _setupError != null) return;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            if (defaultTargetPlatform == TargetPlatform.android ||
                defaultTargetPlatform == TargetPlatform.iOS)
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Ambil foto'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Pilih dari galeri'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source != null) {
      await _detectImage(source);
    }
  }

  Future<void> _detectImage(ImageSource source) async {
    try {
      final image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (image == null) return;

      final bytes = await image.readAsBytes();
      final mimeType = _mimeType(image.name);
      setState(() {
        _messages.add(
          _PilalaMessage(
            text: 'Mohon identifikasi sampah pada foto ini.',
            fromUser: true,
            imageBytes: bytes,
          ),
        );
        _isBusy = true;
      });
      _scrollToBottom();

      final result = await _detectionService.detectWaste(
        imageBytes: bytes,
        mimeType: mimeType,
      );
      if (!mounted) return;
      setState(() {
        _messages.add(
          _PilalaMessage(
            text: 'Nama: ${result.objectName}\n'
                'Kategori: ${result.category}\n'
                'Cara pengolahan: ${result.processingMethod}',
            fromUser: false,
          ),
        );
      });
    } on Exception catch (error) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          _PilalaMessage(
            text: 'Foto belum dapat dianalisis: $error',
            fromUser: false,
            isError: true,
          ),
        );
      });
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
        _scrollToBottom();
      }
    }
  }

  String _mimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return switch (extension) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFE7F4E8),
                    child: Icon(Icons.eco, color: Colors.green),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pilala',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Asisten kebersihan'),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Tutup',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            if (_setupError != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.orange.shade50,
                child: Text(
                  _setupError!,
                  style: TextStyle(color: Colors.orange.shade900),
                ),
              ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _MessageBubble(message: message);
                },
              ),
            ),
            if (_isBusy) const LinearProgressIndicator(minHeight: 2),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      tooltip: 'Kirim foto sampah',
                      onPressed: _isBusy || _setupError != null
                          ? null
                          : _showImageOptions,
                      icon: const Icon(Icons.add_photo_alternate_outlined),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        enabled: !_isBusy && _setupError == null,
                        minLines: 1,
                        maxLines: 4,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: InputDecoration(
                          hintText: 'Tanya Pilala...',
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      tooltip: 'Kirim pesan',
                      onPressed:
                          _isBusy || _setupError != null ? null : _sendMessage,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PilalaMessage {
  const _PilalaMessage({
    required this.text,
    required this.fromUser,
    this.imageBytes,
    this.isError = false,
  });

  final String text;
  final bool fromUser;
  final Uint8List? imageBytes;
  final bool isError;
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final _PilalaMessage message;

  @override
  Widget build(BuildContext context) {
    final color = message.isError
        ? Theme.of(context).colorScheme.errorContainer
        : message.fromUser
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surfaceContainerLow;
    final foregroundColor = message.isError
        ? Theme.of(context).colorScheme.onErrorContainer
        : message.fromUser
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onSurface;

    return Align(
      alignment:
          message.fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.imageBytes case final bytes?)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    bytes,
                    width: 220,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Text(message.text, style: TextStyle(color: foregroundColor)),
          ],
        ),
      ),
    );
  }
}
