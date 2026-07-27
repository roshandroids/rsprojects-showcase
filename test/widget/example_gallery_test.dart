/// Widget tests for ExampleGallery and DemoPane.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rsprojects_showcase/design_system/design_system.dart';
import 'package:rsprojects_showcase/features/projects/domain/projects_domain.dart';
import 'package:rsprojects_showcase/features/projects/presentation/widgets/project_showcase_template.dart';
import 'package:rsprojects_showcase/shared/demos/demo_pane.dart';
import 'package:rsprojects_showcase/shared/demos/demo_spec.dart';
import 'package:rsprojects_showcase/shared/examples/example_gallery.dart';
import 'package:rsprojects_showcase/shared/examples/project_example.dart';

const _examples = [
  ProjectExample(
    id: 'product-brief-template',
    title: 'Product brief template',
    description: 'Starter schema for problem, solution, and success metrics.',
    projectId: 'document_platform',
    category: ExampleCategory.template,
    featured: true,
  ),
  ProjectExample(
    id: 'arb-diff-sample',
    title: 'ARB diff sample',
    description: 'Sample ARB pair.',
    projectId: 'localization_analyzer',
    category: ExampleCategory.sample,
  ),
];

void main() {
  testWidgets('ExampleGallery renders only matching project examples',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: SingleChildScrollView(
            child: ExampleGallery(
              projectId: 'document_platform',
              examples: _examples,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Examples / Playground'), findsOneWidget);
    expect(find.text('Product brief template'), findsOneWidget);
    expect(find.text('ARB diff sample'), findsNothing);
  });

  testWidgets('ExampleGallery is empty when no examples match', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: ExampleGallery(
            projectId: 'ai_tray',
            examples: _examples,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Examples / Playground'), findsNothing);
  });

  testWidgets('project template shows gallery for provided examples',
      (tester) async {
    const project = Project(
      id: 'document_platform',
      name: 'Document Platform',
      description: 'Living docs',
      version: '0.9.0',
      status: ProjectStatus.beta,
      category: ProjectCategory.platform,
      platforms: ['web'],
      featured: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: SingleChildScrollView(
            child: ProjectShowcaseTemplate(
              project: project,
              examples: _examples,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Examples / Playground'), findsOneWidget);
    expect(find.text('Product brief template'), findsOneWidget);
  });

  testWidgets('DemoPane renders external and unavailable variants',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: const [
                DemoPane(
                  spec: DemoExternalLink(url: 'https://example.com/demo'),
                ),
                DemoPane(
                  spec: DemoUnavailable(note: 'Coming later'),
                ),
                DemoPane(
                  spec: DemoEmbeddedWeb(embedUrl: 'https://example.com/embed'),
                ),
                DemoPane(
                  spec: DemoMediaFallback(
                    media: [
                      DemoMediaRef(alt: 'Preview diagram', caption: 'Flow'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Open demo'), findsOneWidget);
    expect(find.text('https://example.com/demo'), findsOneWidget);
    expect(find.text('Demo placeholder'), findsOneWidget);
    expect(find.text('Coming later'), findsOneWidget);
    expect(find.text('Embedded web demo'), findsOneWidget);
    expect(find.text('Demo preview'), findsOneWidget);
    expect(find.text('Preview diagram'), findsOneWidget);
  });
}
