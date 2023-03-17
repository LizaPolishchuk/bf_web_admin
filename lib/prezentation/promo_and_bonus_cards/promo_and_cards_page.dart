import 'dart:async';

import 'package:bf_web_admin/event_bus_events/event_bus.dart';
import 'package:bf_web_admin/event_bus_events/show_bonus_card_info_event.dart';
import 'package:bf_web_admin/event_bus_events/show_promo_info_event.dart';
import 'package:bf_web_admin/injection_container_web.dart';
import 'package:bf_web_admin/prezentation/promo_and_bonus_cards/promo/promo_list_by_type_widget.dart';
import 'package:bf_web_admin/prezentation/widgets/custom_app_bar.dart';
import 'package:bf_web_admin/prezentation/widgets/flex_list_widget.dart';
import 'package:bf_web_admin/prezentation/widgets/info_container.dart';
import 'package:bf_web_admin/prezentation/widgets/search_pannel.dart';
import 'package:bf_web_admin/utils/app_colors.dart';
import 'package:bf_web_admin/utils/app_images.dart';
import 'package:bf_web_admin/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

extension ParomoTypeExtension on PromoType {
  String localizedName(BuildContext context) {
    switch (this) {
      case PromoType.temporary_promo:
        return AppLocalizations.of(context)!.promos;
      case PromoType.bonus_card:
        return AppLocalizations.of(context)!.bonusCards;
      default:
        return "";
    }
  }
}

class PromosPage extends StatefulWidget {
  final Salon? salon;

  const PromosPage({Key? key, this.salon}) : super(key: key);

  @override
  State<PromosPage> createState() => _PromosPageState();
}

class _PromosPageState extends State<PromosPage> {
  late String _currentSalonId;

  Timer? _searchTimer;
  final ValueNotifier<Widget?> _showInfoNotifier = ValueNotifier<Widget?>(null);

  late PromoListByTypeWidget _promoListWidget;
  late PromoListByTypeWidget _bonusCardsListWidget;

  @override
  void initState() {
    super.initState();

    LocalStorage localStorage = getItWeb<LocalStorage>();
    _currentSalonId = localStorage.getSalonId();

    _promoListWidget = PromoListByTypeWidget(
      currentSalonId: _currentSalonId,
      showInfoNotifier: _showInfoNotifier,
      promoType: PromoType.temporary_promo,
    );

    _bonusCardsListWidget = PromoListByTypeWidget(
      currentSalonId: _currentSalonId,
      showInfoNotifier: _showInfoNotifier,
      promoType: PromoType.bonus_card,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, SizingInformation size) {
      return InfoContainer(
        onPressedAddButton: _showAlertToAddPromoOrCard,
        showInfoNotifier: _showInfoNotifier,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomAppBar(title: "${AppLocalizations.of(context)!.promos}/${AppLocalizations.of(context)!.bonusCards}"),
            FlexListWidget(
              children: [
                if (size.isDesktop) const Spacer(),
                SearchPanel(
                  hintText: AppLocalizations.of(context)!.search,
                  onSearch: (text) {
                    // _searchTimer = Timer(const Duration(milliseconds: 600), () {
                    //   _mastersBloc.searchMasters(text);
                    // });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ScreenTypeLayout.builder(
                breakpoints: const ScreenBreakpoints(tablet: 400, desktop: 750, watch: 300),
                desktop: _buildDesktopView,
                mobile: _buildMobileView,
                tablet: _buildMobileView,
              ),
            ),
            // const SizedBox(height: 20),
            // PaginationCounter(),
          ],
        ),
      );
    });
  }

  Widget _buildDesktopView(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: _promoListWidget,
        ),
        const SizedBox(width: 66),
        Flexible(
          flex: 2,
          child: _bonusCardsListWidget,
        ),
      ],
    );
  }

  Widget _buildMobileView(BuildContext context) {
    Widget pageContent;
    switch (_currentPromoType) {
      case PromoType.temporary_promo:
        pageContent = _promoListWidget;
        break;
      case PromoType.bonus_card:
        pageContent = _bonusCardsListWidget;
        break;
    }

    return Column(
      children: [
        _buildSelectorForMobile(),
        const SizedBox(height: 20),
        Expanded(child: pageContent),
      ],
    );
  }

  PromoType _currentPromoType = PromoType.temporary_promo;

  Widget _buildSelectorForMobile() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
      child: Row(
        children: [
          _buildSelectorItem(PromoType.temporary_promo),
          _buildSelectorItem(PromoType.bonus_card),
        ],
      ),
    );
  }

  Widget _buildSelectorItem(PromoType promoType) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentPromoType = promoType;
          });
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _currentPromoType == promoType ? Theme.of(context).colorScheme.primary : null,
          ),
          alignment: Alignment.center,
          child: Text(promoType.localizedName(context)),
        ),
      ),
    );
  }

  void _showAlertToAddPromoOrCard() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAddPromoOrCardButton(
                AppLocalizations.of(context)!.promo,
                AppIcons.promoPlaceholder,
                () => eventBus.fire(ShowPromoInfoEvent(InfoAction.add, null, null)),
              ),
              const SizedBox(width: 8),
              _buildAddPromoOrCardButton(
                AppLocalizations.of(context)!.bonusCard,
                AppIcons.bonusCardPlaceholder,
                () => eventBus.fire(ShowBonusCardInfoEvent(InfoAction.add, null, null)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddPromoOrCardButton(String title, String imagePath, VoidCallback onClick) {
    return Container(
      width: 228,
      height: 303,
      padding: const EdgeInsets.only(top: 49, bottom: 36, left: 10, right: 10),
      decoration: BoxDecoration(
        color: AppTheme.isDark ? AppColors.darkBlue : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Text(title.toUpperCase(), style: Theme.of(context).textTheme.bodyMedium),
          Flexible(
            child: Center(
              child: SizedBox(
                height: 110,
                width: 110,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              onClick();
              Get.back();
            },
            child: Text(
              AppLocalizations.of(context)!.add,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _showInfoNotifier.dispose();
    _searchTimer?.cancel();

    super.dispose();
  }
}
