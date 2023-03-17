import 'dart:async';

import 'package:bf_web_admin/event_bus_events/event_bus.dart';
import 'package:bf_web_admin/event_bus_events/show_promo_info_event.dart';
import 'package:bf_web_admin/injection_container_web.dart';
import 'package:bf_web_admin/prezentation/promo_and_bonus_cards/promo/bonus_card_info_view.dart';
import 'package:bf_web_admin/prezentation/promo_and_bonus_cards/promo/bonus_cards_list.dart';
import 'package:bf_web_admin/prezentation/promo_and_bonus_cards/promo/promo_info_view.dart';
import 'package:bf_web_admin/prezentation/promo_and_bonus_cards/promo/promos_bloc.dart';
import 'package:bf_web_admin/prezentation/promo_and_bonus_cards/promo/temporary_promo_list.dart';
import 'package:bf_web_admin/prezentation/promo_and_bonus_cards/promo_and_cards_page.dart';
import 'package:bf_web_admin/prezentation/widgets/info_container.dart';
import 'package:bf_web_admin/utils/alert_builder.dart';
import 'package:bf_web_admin/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class PromoListByTypeWidget extends StatefulWidget {
  final String currentSalonId;
  final ValueNotifier<Widget?> showInfoNotifier;
  final PromoType promoType;

  const PromoListByTypeWidget(
      {Key? key, required this.currentSalonId, required this.showInfoNotifier, required this.promoType})
      : super(key: key);

  @override
  State<PromoListByTypeWidget> createState() => _PromoListByTypeWidgetState();
}

class _PromoListByTypeWidgetState extends State<PromoListByTypeWidget> {
  late PromosBloc _promosBloc;
  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();

    _promosBloc = getItWeb<PromosBloc>();
    _promosBloc.getPromos(widget.currentSalonId, widget.promoType);

    _subscriptions.addAll([
      _promosBloc.errorMessage.listen((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(error),
        ));
      }),
      _promosBloc.promoAdded.listen((isSuccess) {
        widget.showInfoNotifier.value = null;
      }),
      eventBus.on<ShowPromoInfoEvent>().listen((event) {
        _showPromoInfoView(event.infoAction, event.item, event.index);
      }),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(PromoType.temporary_promo.localizedName(context),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 18)),
          ],
        ),
        const SizedBox(height: 30),
        Flexible(
          child: SizedBox(
            width: 220,
            child: StreamBuilder<List<Promo>>(
              stream: _promosBloc.promosLoaded,
              builder: (context, snapshot) {
                switch (widget.promoType) {
                  case PromoType.bonus_card:
                    return BonusCardsList(
                      bonusCardsList: snapshot.data ?? [],
                      onClickMore: (promo, index) => _buildPopupMenu(context, promo, index),
                    );
                  case PromoType.temporary_promo:
                    return TemporaryPromoList(
                      promoList: snapshot.data ?? [],
                      onClickMore: (promo, index) => _buildPopupMenu(context, promo, index),
                    );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopupMenu(BuildContext context, BaseEntity item, int index) {
    return PopupMenuButton(
      splashRadius: 5,
      position: PopupMenuPosition.under,
      icon: const Icon(
        Icons.more_horiz,
        color: AppColors.hintColor,
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
          _showPromoInfoView(InfoAction.view, item, index);
        } else if (value == 1) {
          _showPromoInfoView(InfoAction.edit, item, index);
        } else if (value == 2) {
          AlertBuilder().showAlertForDelete(context, AppLocalizations.of(context)!.promo1, (item as Promo).name, () {
            _promosBloc.removePromo(item.id, index);
            widget.showInfoNotifier.value = null;
          });
        }
      },
    );
  }

  void _showPromoInfoView(InfoAction infoAction, BaseEntity? item, int? index) {
    switch (widget.promoType) {
      case PromoType.bonus_card:
        widget.showInfoNotifier.value = BonusCardInfoView(
          salonId: widget.currentSalonId,
          infoAction: infoAction,
          bonusCard: item as Promo?,
          onClickAction: (promo, action) {
            if (action == InfoAction.add) {
              _promosBloc.addPromo(promo);
            } else if (action == InfoAction.edit) {
              _promosBloc.updatePromo(promo, index!);
            } else if (action == InfoAction.delete) {
              AlertBuilder().showAlertForDelete(context, AppLocalizations.of(context)!.bonusCard1, promo.name, () {
                _promosBloc.removePromo(promo.id, index!);
                widget.showInfoNotifier.value = null;
              });
            }
          },
        );
        break;
      case PromoType.temporary_promo:
        widget.showInfoNotifier.value = PromoInfoView(
          salonId: widget.currentSalonId,
          infoAction: infoAction,
          promo: item as Promo?,
          onClickAction: (promo, action, photo) {
            if (action == InfoAction.add) {
              _promosBloc.addPromo(promo, photo);
            } else if (action == InfoAction.edit) {
              _promosBloc.updatePromo(promo, index!, photo);
            } else if (action == InfoAction.delete) {
              AlertBuilder().showAlertForDelete(context, AppLocalizations.of(context)!.promo1, promo.name, () {
                _promosBloc.removePromo(promo.id, index!);
                widget.showInfoNotifier.value = null;
              });
            }
          },
        );
        break;
    }
  }

  @override
  void dispose() {
    _subscriptions.forEach((element) {
      element.cancel();
    });
    super.dispose();
  }
}
