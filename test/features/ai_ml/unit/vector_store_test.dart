import 'package:flutter_test/flutter_test.dart';
import 'package:reuablewidgets/features/ai_ml/storage/vector_store.dart';
import 'package:reuablewidgets/features/ai_ml/models/text_embedding.dart';
import 'package:reuablewidgets/features/ai_ml/models/vector_store_models.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Mock embedding generator for testing
class MockEmbeddingGenerator implements TextEmbeddingGenerator {
  @override
  Future<TextEmbedding> generate(String text) async {
    // Simple hash-based embedding for testing
    final hash = text.hashCode.abs();
    final vector = List.generate(
      3,
      (i) => ((hash >> (i * 8)) & 0xFF) / 255.0,
    );
    return TextEmbedding(vector: vector, originalText: text);
  }
}

void main() {
  // Setup SQLite for testing
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('SqliteVectorStore', () {
    late SqliteVectorStore vectorStore;
    late MockEmbeddingGenerator embeddingGenerator;

    setUp(() async {
      embeddingGenerator = MockEmbeddingGenerator();
      vectorStore = SqliteVectorStore(
        dbName: 'test_vectors_${DateTime.now().millisecondsSinceEpoch}',
        embeddingGenerator: embeddingGenerator,
      );
      await vectorStore.initialize();
    });

    tearDown(() async {
      await vectorStore.dispose();
    });

    test('initializes successfully', () async {
      expect(vectorStore._database, isNotNull);
    });

    test('adds and retrieves documents', () async {
      await vectorStore.addDocument(
        'doc1',
        'This is a test document',
        metadata: {'category': 'test'},
      );

      final doc = await vectorStore.getDocument('doc1');

      expect(doc, isNotNull);
      expect(doc!.id, 'doc1');
      expect(doc.text, 'This is a test document');
      expect(doc.metadata?['category'], 'test');
      expect(doc.embedding, isNotNull);
    });

    test('queries similar documents', () async {
      // Add multiple documents
      await vectorStore.addDocument('doc1', 'Flutter is great');
      await vectorStore.addDocument('doc2', 'Flutter is awesome');
      await vectorStore.addDocument('doc3', 'Python is nice');

      // Query
      final results = await vectorStore.query(
        'Flutter is wonderful',
        topK: 2,
      );

      expect(results.length, 2);
      // Should find Flutter-related docs first
      expect(results[0].document.text, contains('Flutter'));
      expect(results[1].document.text, contains('Flutter'));
    });

    test('filters by metadata', () async {
      await vectorStore.addDocument(
        'doc1',
        'Text about Flutter',
        metadata: {'category': 'mobile'},
      );
      await vectorStore.addDocument(
        'doc2',
        'Text about Flutter',
        metadata: {'category': 'web'},
      );

      final results = await vectorStore.query(
        'Flutter',
        metadataFilter: {'category': 'mobile'},
      );

      expect(results.length, 1);
      expect(results[0].document.metadata?['category'], 'mobile');
    });

    test('respects minSimilarity threshold', () async {
      await vectorStore.addDocument('doc1', 'Completely different text');

      final results = await vectorStore.query(
        'Query text',
        minSimilarity: 0.9, // Very high threshold
      );

      // Should return nothing if similarity is too low
      expect(results.length, lessThanOrEqualTo(1));
    });

    test('deletes documents', () async {
      await vectorStore.addDocument('doc1', 'Test');

      var doc = await vectorStore.getDocument('doc1');
      expect(doc, isNotNull);

      await vectorStore.deleteDocument('doc1');

      doc = await vectorStore.getDocument('doc1');
      expect(doc, isNull);
    });

    test('counts documents correctly', () async {
      expect(await vectorStore.count(), 0);

      await vectorStore.addDocument('doc1', 'Test 1');
      await vectorStore.addDocument('doc2', 'Test 2');

      expect(await vectorStore.count(), 2);
    });

    test('clears all documents', () async {
      await vectorStore.addDocument('doc1', 'Test 1');
      await vectorStore.addDocument('doc2', 'Test 2');

      expect(await vectorStore.count(), 2);

      await vectorStore.clear();

      expect(await vectorStore.count(), 0);
    });

    test('adds document with pre-computed embedding', () async {
      final embedding = TextEmbedding(vector: [0.1, 0.2, 0.3]);

      await vectorStore.addDocumentWithEmbedding(
        'doc1',
        'Test text',
        embedding,
        metadata: {'precomputed': true},
      );

      final doc = await vectorStore.getDocument('doc1');

      expect(doc, isNotNull);
      expect(doc!.embedding!.vector, [0.1, 0.2, 0.3]);
    });

    test('queries with pre-computed embedding', () async {
      final embedding1 = TextEmbedding(vector: [1.0, 0.0, 0.0]);
      final embedding2 = TextEmbedding(vector: [0.9, 0.1, 0.0]);
      final embedding3 = TextEmbedding(vector: [0.0, 1.0, 0.0]);

      await vectorStore.addDocumentWithEmbedding('doc1', 'Similar 1', embedding1);
      await vectorStore.addDocumentWithEmbedding('doc2', 'Similar 2', embedding2);
      await vectorStore.addDocumentWithEmbedding('doc3', 'Different', embedding3);

      final queryEmbedding = TextEmbedding(vector: [1.0, 0.0, 0.0]);
      final results = await vectorStore.queryWithEmbedding(
        queryEmbedding,
        topK: 2,
      );

      expect(results.length, 2);
      expect(results[0].document.text, 'Similar 1');
    });
  });
}
