import 'dart:io';
import 'package:reuablewidgets/features/ai_ml/ai_ml.dart';

/// Mock image classification adapter for testing
class MockImageClassificationAdapter extends ImageClassificationAdapter {
  final ModelInfo _modelInfo;
  bool _initialized = false;

  MockImageClassificationAdapter({ModelInfo? modelInfo})
      : _modelInfo = modelInfo ??
            ModelInfo(
              id: 'mock_classifier',
              name: 'Mock Classifier',
              sizeBytes: 1000000,
              framework: 'mock',
              quantized: false,
            );

  @override
  bool get isInitialized => _initialized;

  @override
  Future<ModelInfo> info() async => _modelInfo;

  @override
  Future<void> initialize() async {
    _initialized = true;
  }

  @override
  Future<void> dispose() async {
    _initialized = false;
  }

  @override
  Future<ImageClassificationResult> classify(
    File imageFile, {
    double threshold = 0.0,
  }) async {
    return ImageClassificationResult(
      labels: [
        LabelScore(label: 'cat', score: 0.95),
        LabelScore(label: 'dog', score: 0.03),
        LabelScore(label: 'bird', score: 0.02),
      ].where((l) => l.score >= threshold).toList(),
      inferenceTimeMs: 50,
      modelId: _modelInfo.id,
    );
  }

  @override
  Future<ImageClassificationResult> classifyFromBytes(
    List<int> imageBytes, {
    double threshold = 0.0,
  }) async {
    return classify(File(''), threshold: threshold);
  }
}

/// Mock OCR adapter for testing
class MockOcrAdapter extends OcrAdapter {
  final ModelInfo _modelInfo;
  bool _initialized = false;

  MockOcrAdapter({ModelInfo? modelInfo})
      : _modelInfo = modelInfo ??
            ModelInfo(
              id: 'mock_ocr',
              name: 'Mock OCR',
              sizeBytes: 1000000,
              framework: 'mock',
              quantized: false,
            );

  @override
  bool get isInitialized => _initialized;

  @override
  Future<ModelInfo> info() async => _modelInfo;

  @override
  Future<void> initialize() async {
    _initialized = true;
  }

  @override
  Future<void> dispose() async {
    _initialized = false;
  }

  @override
  Future<OcrResult> recognize(File imageFile) async {
    return OcrResult(
      text: 'This is mock OCR text',
      blocks: [
        OcrBlock(
          text: 'This is mock',
          confidence: 0.95,
        ),
        OcrBlock(
          text: 'OCR text',
          confidence: 0.90,
        ),
      ],
      inferenceTimeMs: 100,
      modelId: _modelInfo.id,
    );
  }

  @override
  Future<OcrResult> recognizeFromBytes(List<int> imageBytes) async {
    return recognize(File(''));
  }
}

/// Mock chat adapter for testing
class MockChatAdapter extends BaseChatAdapter {
  final String _provider;
  final String _model;

  MockChatAdapter({
    String provider = 'mock',
    String model = 'mock-model',
  })  : _provider = provider,
        _model = model;

  @override
  String get provider => _provider;

  @override
  String get defaultModel => _model;

  @override
  Future<ChatResponse> generate(ChatRequest request) async {
    validateRequest(request);

    await Future.delayed(Duration(milliseconds: 100));

    final lastMessage = request.messages.last;
    final responseText = 'Mock response to: ${lastMessage.content}';

    return ChatResponse(
      text: responseText,
      metadata: {
        'model': _model,
        'mock': true,
      },
      generationTimeMs: 100,
    );
  }
}

/// Mock text embedding adapter for testing
class MockTextEmbeddingAdapter extends TextEmbeddingAdapter {
  final ModelInfo _modelInfo;
  bool _initialized = false;

  MockTextEmbeddingAdapter({ModelInfo? modelInfo})
      : _modelInfo = modelInfo ??
            ModelInfo(
              id: 'mock_embedder',
              name: 'Mock Embedder',
              sizeBytes: 1000000,
              framework: 'mock',
              quantized: false,
            );

  @override
  bool get isInitialized => _initialized;

  @override
  Future<ModelInfo> info() async => _modelInfo;

  @override
  Future<void> initialize() async {
    _initialized = true;
  }

  @override
  Future<void> dispose() async {
    _initialized = false;
  }

  @override
  Future<TextEmbedding> embed(String text) async {
    // Simple deterministic embedding based on text hash
    final hash = text.hashCode.abs();
    final vector = List.generate(
      128,
      (i) => ((hash >> (i % 32)) & 0xFF) / 255.0,
    );

    return TextEmbedding(
      vector: vector,
      originalText: text,
      modelId: _modelInfo.id,
      inferenceTimeMs: 50,
    );
  }

  @override
  Future<List<TextEmbedding>> embedBatch(List<String> texts) async {
    return Future.wait(texts.map((text) => embed(text)));
  }
}
