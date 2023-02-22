import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:salons_adminka/event_bus_events/event_bus.dart';
import 'package:salons_adminka/event_bus_events/show_bonus_card_info_event.dart';
import 'package:salons_adminka/injection_container_web.dart';
import 'package:salons_adminka/prezentation/promo_and_bonus_cards/bonus_cards/bonus_card_info_view.dart';
import 'package:salons_adminka/prezentation/promo_and_bonus_cards/bonus_cards/bonus_cards_bloc.dart';
import 'package:salons_adminka/prezentation/promo_and_bonus_cards/promo_and_cards_page.dart';
import 'package:salons_adminka/prezentation/widgets/info_container.dart';
import 'package:salons_adminka/utils/alert_builder.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class BonusCardsListWidget extends StatefulWidget {
  final String currentSalonId;
  final ValueNotifier<Widget?> showInfoNotifier;

  const BonusCardsListWidget({Key? key, required this.currentSalonId, required this.showInfoNotifier})
      : super(key: key);

  @override
  State<BonusCardsListWidget> createState() => _BonusCardsListWidgetState();
}

class _BonusCardsListWidgetState extends State<BonusCardsListWidget> {
  late BonusCardsBloc _bonusCardsBloc;
  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();

    _bonusCardsBloc = getItWeb<BonusCardsBloc>();
    _bonusCardsBloc.getBonusCards(widget.currentSalonId);

    _subscriptions.addAll([
      _bonusCardsBloc.errorMessage.listen((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(error),
        ));
      }),
      _bonusCardsBloc.bonusCardAdded.listen((isSuccess) {
        widget.showInfoNotifier.value = null;
      }),
      eventBus.on<ShowBonusCardInfoEvent>().listen((event) {
        _showBonusCardInfoView(event.infoAction, event.item, event.index);
      })
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(PromoType.bonusCards.localizedName(context),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 18)),
        const SizedBox(height: 30),
        Flexible(
          child: StreamBuilder<List<BonusCard>>(
              stream: _bonusCardsBloc.bonusCardsLoaded,
              builder: (context, snapshot) {
                print("loaded bonus cards: ${snapshot.data}");

                return GridView.count(
                  controller: ScrollController(),
                  scrollDirection: Axis.horizontal,
                  crossAxisCount: 2,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 30,
                  childAspectRatio: 1 / 1.5,
                  children: snapshot.data
                          ?.asMap()
                          .map((index, item) => MapEntry(index, _buildBonusCardItem(context, item, index)))
                          .values
                          .toList() ??
                      [],
                );
              }),
        ),
      ],
    );
  }

  Widget _buildBonusCardItem(BuildContext context, BonusCard bonusCard, int index) {
    return Container(
      height: 220,
      width: 340,
      padding: const EdgeInsets.only(left: 20, right: 10, top: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: bonusCard.color != null ? Color(bonusCard.color!) : AppColors.rose,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC4C4C4).withOpacity(0.25),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    bonusCard.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 6),
                _buildPopupMenu(context, bonusCard, index),
              ],
            ),
          ),
          Center(
            child: Text(
              "${bonusCard.discount}%",
              style: const TextStyle(color: Colors.white, fontSize: 48),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context, BaseEntity item, int index) {
    return PopupMenuButton(
      splashRadius: 5,
      position: PopupMenuPosition.under,
      icon: const Icon(
        Icons.more_horiz,
        color: Colors.white,
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem<int>(
            value: 0,
            height: 32,
            child: Text(AppLocalizations.of(context)!.view,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
          ),
          PopupMenuItem<int>(
            value: 1,
            height: 32,
            child: Text(AppLocalizations.of(context)!.edit,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
          ),
          PopupMenuItem<int>(
            value: 2,
            height: 32,
            child: Text(AppLocalizations.of(context)!.delete,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12, color: AppColors.red)),
          ),
        ];
      },
      onSelected: (value) {
        if (value == 0) {
          _showBonusCardInfoView(InfoAction.view, item, index);
        } else if (value == 1) {
          _showBonusCardInfoView(InfoAction.edit, item, index);
        } else if (value == 2) {
          AlertBuilder().showAlertForDelete(context, AppLocalizations.of(context)!.bonusCard1, item.name, () {
            _bonusCardsBloc.removeBonusCard(item.id, index);
            widget.showInfoNotifier.value = null;
          });
        }
      },
    );
  }

  void _showBonusCardInfoView(InfoAction infoAction, BaseEntity? item, int? index) {
    widget.showInfoNotifier.value = BonusCardInfoView(
      salonId: widget.currentSalonId,
      infoAction: infoAction,
      bonusCard: item as BonusCard?,
      onClickAction: (card, action) {
        if (action == InfoAction.add) {
          _bonusCardsBloc.addBonusCard(card);
        } else if (action == InfoAction.edit) {
          _bonusCardsBloc.updateBonusCard(card, index!);
        } else if (action == InfoAction.delete) {
          AlertBuilder().showAlertForDelete(context, AppLocalizations.of(context)!.bonusCard1, card.name, () {
            _bonusCardsBloc.removeBonusCard(card.id, index!);
            widget.showInfoNotifier.value = null;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _subscriptions.forEach((element) {
      element.cancel();
    });
    super.dispose();
  }
}
