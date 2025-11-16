import 'package:flutter_test/flutter_test.dart';
import 'package:reuablewidgets/features/ai_ml/ai_ml.dart';
import '../mocks/mock_adapters.dart';

void main() {
  group('AiMlManager', () {
    late AiMlManager aiMl;

    setUp(() async {
      final config = AiMlConfig(
        inferencePolicy: InferencePolicy.onDeviceOnly,
        enableLogging: false,
      );

      aiMl = AiMlManager(
        config: config,
        logger: const NoOpLogger(),
      );

      await aiMl.initialize(config);
    });

    tearDown(() async {
      await aiMl.dispose();
    });

    test('initializes successfully', () {
      expect(aiMl.isInitialized, true);
    });

    test('registers and uses image classification adapter', () async {
      final adapter = MockImageClassificationAdapter();
      await adapter.initialize();
      aiMl.registerAdapter('classifier', adapter);

      final mockFile = File('test.jpg'); // Won't actually be read by mock

      final result = await aiMl.classifyImage(
        mockFile,
        modelId: 'classifier',
        threshold: 0.5,
      );

      expect(result.labels.length, greaterThan(0));
      expect(result.labels.first.label, 'cat');
      expect(result.labels.first.score, 0.95);
    });

    test('registers and uses OCR adapter', () async {
      final adapter = MockOcrAdapter();
      await adapter.initialize();
      aiMl.registerAdapter('ocr', adapter);

      final mockFile = File('test.jpg');

      final result = await aiMl.runOcr(mockFile, modelId: 'ocr');

      expect(result.text, 'This is mock OCR text');
      expect(result.blocks.length, 2);
    });

    test('registers and uses chat adapter', () async {
      final adapter = MockChatAdapter();
      await adapter.initialize();
      aiMl.registerChatAdapter('mock', adapter);

      final session = aiMl.createChatSession(
        config: ChatSessionConfig(
          backend: ModelProvider.custom,
        ),
      );

      // Override to use mock adapter
      aiMl._chatAdapters['custom'] = adapter;

      final response = await aiMl.chatGenerate(session, 'Hello');

      expect(response.text, contains('Mock response'));
      expect(session.messages.length, 2); // User + Assistant
    });

    test('throws on uninitialized manager', () async {
      final uninitializedManager = AiMlManager();

      expect(
        () => uninitializedManager.classifyImage(File('test.jpg')),
        throwsA(isA<InitializationException>()),
      );
    });

    test('throws on missing adapter', () async {
      expect(
        () => aiMl.classifyImage(File('test.jpg'), modelId: 'nonexistent'),
        throwsA(isA<ModelNotFoundException>()),
      );
    });

    test('manages multiple adapters', () async {
      final classifier = MockImageClassificationAdapter();
      final ocr = MockOcrAdapter();
      final embedder = MockTextEmbeddingAdapter();

      await classifier.initialize();
      await ocr.initialize();
      await embedder.initialize();

      aiMl.registerAdapter('classifier', classifier);
      aiMl.registerAdapter('ocr', ocr);
      aiMl.registerAdapter('embedder', embedder);

      // Should be able to use all adapters
      await aiMl.classifyImage(File('test.jpg'), modelId: 'classifier');
      await aiMl.runOcr(File('test.jpg'), modelId: 'ocr');
      await aiMl.embedText('test', modelId: 'embedder');
    });

    test('closes chat sessions', () async {
      final adapter = MockChatAdapter();
      await adapter.initialize();
      aiMl.registerChatAdapter('mock', adapter);

      final session = aiMl.createChatSession(
        config: ChatSessionConfig(backend: ModelProvider.custom),
      );

      expect(aiMl._chatSessions.containsKey(session.id), true);

      await aiMl.closeChatSession(session);

      expect(aiMl._chatSessions.containsKey(session.id), false);
    });

    test('disposes all resources', () async {
      final adapter = MockImageClassificationAdapter();
      await adapter.initialize();
      aiMl.registerAdapter('classifier', adapter);

      expect(aiMl.isInitialized, true);
      expect(adapter.isInitialized, true);

      await aiMl.dispose();

      expect(aiMl.isInitialized, false);
      expect(adapter.isInitialized, false);
    });
  });
}
