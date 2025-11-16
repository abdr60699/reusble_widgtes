import 'package:flutter_test/flutter_test.dart';
import 'package:reuablewidgets/features/ai_ml/models/text_embedding.dart';

void main() {
  group('TextEmbedding', () {
    test('creates embedding with vector', () {
      final embedding = TextEmbedding(
        vector: [0.1, 0.2, 0.3],
        originalText: 'test',
      );

      expect(embedding.vector, [0.1, 0.2, 0.3]);
      expect(embedding.dimension, 3);
      expect(embedding.originalText, 'test');
    });

    test('normalizes vector correctly', () {
      final embedding = TextEmbedding(
        vector: [3.0, 4.0, 0.0],
      );

      final normalized = embedding.normalize();

      // 3-4-5 triangle: magnitude = 5
      expect(normalized.vector[0], closeTo(0.6, 0.001));
      expect(normalized.vector[1], closeTo(0.8, 0.001));
      expect(normalized.vector[2], closeTo(0.0, 0.001));
    });

    test('computes cosine similarity correctly', () {
      final embedding1 = TextEmbedding(vector: [1.0, 0.0, 0.0]);
      final embedding2 = TextEmbedding(vector: [1.0, 0.0, 0.0]);
      final embedding3 = TextEmbedding(vector: [0.0, 1.0, 0.0]);

      // Identical vectors
      expect(embedding1.cosineSimilarity(embedding2), closeTo(1.0, 0.001));

      // Orthogonal vectors
      expect(embedding1.cosineSimilarity(embedding3), closeTo(0.0, 0.001));
    });

    test('computes L2 distance correctly', () {
      final embedding1 = TextEmbedding(vector: [0.0, 0.0, 0.0]);
      final embedding2 = TextEmbedding(vector: [3.0, 4.0, 0.0]);

      // Distance squared = 9 + 16 = 25
      expect(embedding1.l2Distance(embedding2), 25.0);
    });

    test('throws on dimension mismatch', () {
      final embedding1 = TextEmbedding(vector: [1.0, 2.0]);
      final embedding2 = TextEmbedding(vector: [1.0, 2.0, 3.0]);

      expect(
        () => embedding1.cosineSimilarity(embedding2),
        throwsArgumentError,
      );
    });

    test('serializes to and from JSON', () {
      final original = TextEmbedding(
        vector: [0.1, 0.2, 0.3],
        originalText: 'test',
        modelId: 'test_model',
        inferenceTimeMs: 100,
        metadata: {'key': 'value'},
      );

      final json = original.toJson();
      final restored = TextEmbedding.fromJson(json);

      expect(restored.vector, original.vector);
      expect(restored.originalText, original.originalText);
      expect(restored.modelId, original.modelId);
      expect(restored.inferenceTimeMs, original.inferenceTimeMs);
      expect(restored.metadata, original.metadata);
    });

    test('equality works correctly', () {
      final embedding1 = TextEmbedding(vector: [1.0, 2.0, 3.0]);
      final embedding2 = TextEmbedding(vector: [1.0, 2.0, 3.0]);
      final embedding3 = TextEmbedding(vector: [1.0, 2.0, 4.0]);

      expect(embedding1 == embedding2, true);
      expect(embedding1 == embedding3, false);
    });
  });
}
