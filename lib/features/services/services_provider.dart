import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/content/portfolio_content.dart' as content;
import 'package:portfolio/core/content/service_offering.dart';

final serviceOfferingsProvider = Provider<List<ServiceOffering>>(
  (ref) => content.serviceOfferings,
);
