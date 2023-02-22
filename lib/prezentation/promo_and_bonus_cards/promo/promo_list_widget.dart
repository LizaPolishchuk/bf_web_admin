import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:salons_adminka/event_bus_events/event_bus.dart';
import 'package:salons_adminka/event_bus_events/show_promo_info_event.dart';
import 'package:salons_adminka/injection_container_web.dart';
import 'package:salons_adminka/prezentation/promo_and_bonus_cards/promo/promo_info_view.dart';
import 'package:salons_adminka/prezentation/promo_and_bonus_cards/promo/promos_bloc.dart';
import 'package:salons_adminka/prezentation/promo_and_bonus_cards/promo_and_cards_page.dart';
import 'package:salons_adminka/prezentation/widgets/info_container.dart';
import 'package:salons_adminka/utils/alert_builder.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_adminka/utils/app_theme.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class PromoListWidget extends StatefulWidget {
  final String currentSalonId;
  final ValueNotifier<Widget?> showInfoNotifier;

  const PromoListWidget({Key? key, required this.currentSalonId, required this.showInfoNotifier}) : super(key: key);

  @override
  State<PromoListWidget> createState() => _PromoListWidgetState();
}

class _PromoListWidgetState extends State<PromoListWidget> {
  late PromosBloc _promosBloc;
  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();

    _promosBloc = getItWeb<PromosBloc>();
    _promosBloc.getPromos(widget.currentSalonId);

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
            Text(PromoType.promos.localizedName(context),
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
                return ListView.separated(
                  controller: ScrollController(),
                  itemBuilder: (context, index) {
                    return _buildPromoItem(context, snapshot.data![index], index);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 20, width: double.infinity);
                  },
                  itemCount: snapshot.data?.length ?? 0,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoItem(BuildContext context, Promo promo, int index) {
    return Container(
      height: 220,
      width: 220,
      padding: const EdgeInsets.only(left: 20, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppTheme.isDark ? AppColors.darkBlue : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: _buildPopupMenu(context, promo, index),
          ),
          SizedBox(
            width: 110,
            height: 110,
            child: Image.network(
              promo.photoUrl ?? "",
              errorBuilder: (context, obj, stackTrace) {
                return Container(
                  color: AppColors.lightRose,
                );
              },
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            promo.name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            promo.description ?? "",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
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
          AlertBuilder().showAlertForDelete(context, AppLocalizations.of(context)!.promo1, item.name, () {
            _promosBloc.removePromo(item.id, index);
            widget.showInfoNotifier.value = null;
          });
        }
      },
    );
  }

  void _showPromoInfoView(InfoAction infoAction, BaseEntity? item, int? index) {
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
  }

  @override
  void dispose() {
    _subscriptions.forEach((element) {
      element.cancel();
    });
    super.dispose();
  }
}
