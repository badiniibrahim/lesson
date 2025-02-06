import 'package:google_generative_ai/google_generative_ai.dart';

final topicSchema = Schema.object(properties: {
  'course_titles': Schema.array(
    description: 'Liste des titres de cours',
    items: Schema.string(description: 'Titre du cours', nullable: false),
  )
}, requiredProperties: [
  'course_titles'
]);
