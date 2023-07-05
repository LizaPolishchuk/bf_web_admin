import 'package:bf_web_admin/prezentation/feedbacks_page/feedbacks_page.dart';
import 'package:bf_web_admin/prezentation/home_page/home_page.dart';
import 'package:bf_web_admin/prezentation/masters_page/masters_page.dart';
import 'package:bf_web_admin/prezentation/profile_page/profile_page.dart';
import 'package:bf_web_admin/prezentation/promo_and_bonus_cards/promo_and_cards_page.dart';
import 'package:bf_web_admin/prezentation/services_page/services_page.dart';
import 'package:bf_web_admin/prezentation/settings_page/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum PageContentType { home, services, masters, clients, promos, feedbacks, profile, settings }

extension PageContentExtention on PageContentType {
  String getPageTitle(BuildContext context) {
    switch (this) {
      case PageContentType.home:
        return AppLocalizations.of(context)!.main;
      case PageContentType.services:
        return AppLocalizations.of(context)!.services;
      case PageContentType.masters:
        return AppLocalizations.of(context)!.masters;
      case PageContentType.clients:
        return AppLocalizations.of(context)!.clients;
      case PageContentType.promos:
        return AppLocalizations.of(context)!.bonusCards;
      case PageContentType.feedbacks:
        return AppLocalizations.of(context)!.feedbacks;
      case PageContentType.profile:
        return AppLocalizations.of(context)!.profile;
      case PageContentType.settings:
        return AppLocalizations.of(context)!.settings;
    }
  }

  Widget getPage() {
    switch (this) {
      case PageContentType.home:
        return const HomePage();
      case PageContentType.services:
        return const ServicesPage();
      case PageContentType.masters:
        return const MastersPage();
      case PageContentType.clients:
        return const SizedBox();
      case PageContentType.promos:
        return const PromosPage();
      case PageContentType.feedbacks:
        return const FeedbacksPage();
      case PageContentType.profile:
        return const ProfilePage();
      case PageContentType.settings:
        return const SettingsPage();
    }
  }
}
