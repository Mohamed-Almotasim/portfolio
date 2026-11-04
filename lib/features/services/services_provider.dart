import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/content/engagement_model.dart';
import 'package:portfolio/core/content/faq_item.dart';
import 'package:portfolio/core/content/portfolio_content.dart' as content;
import 'package:portfolio/core/content/process_step.dart';
import 'package:portfolio/core/content/service_offering.dart';

final serviceOfferingsProvider = Provider<List<ServiceOffering>>(
  (ref) => content.serviceOfferings,
);

final processStepsProvider = Provider<List<ProcessStep>>(
  (ref) => content.processSteps,
);

final engagementModelsProvider = Provider<List<EngagementModel>>(
  (ref) => content.engagementModels,
);

final faqsProvider = Provider<List<FaqItem>>((ref) => content.faqs);
