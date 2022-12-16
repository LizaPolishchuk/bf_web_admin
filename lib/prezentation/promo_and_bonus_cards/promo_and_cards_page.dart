import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:salons_adminka/injection_container_web.dart';
import 'package:salons_adminka/prezentation/promo_and_bonus_cards/bonus_card_info_view.dart';
import 'package:salons_adminka/prezentation/promo_and_bonus_cards/bonus_cards_bloc.dart';
import 'package:salons_adminka/prezentation/promo_and_bonus_cards/promo_info_view.dart';
import 'package:salons_adminka/prezentation/promo_and_bonus_cards/promos_bloc.dart';
import 'package:salons_adminka/prezentation/widgets/custom_app_bar.dart';
import 'package:salons_adminka/prezentation/widgets/flex_list_widget.dart';
import 'package:salons_adminka/prezentation/widgets/info_container.dart';
import 'package:salons_adminka/prezentation/widgets/search_pannel.dart';
import 'package:salons_adminka/utils/alert_builder.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_adminka/utils/app_images.dart';
import 'package:salons_adminka/utils/app_text_style.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class PromosPage extends StatefulWidget {
  final Salon? salon;

  const PromosPage({Key? key, this.salon}) : super(key: key);

  @override
  State<PromosPage> createState() => _PromosPageState();
}

class _PromosPageState extends State<PromosPage> {
  late String _currentSalonId;

  late PromosBloc _promosBloc;
  late BonusCardsBloc _bonusCardsBloc;

  Timer? _searchTimer;
  final ValueNotifier<Widget?> _showInfoNotifier = ValueNotifier<Widget?>(null);

  @override
  void initState() {
    super.initState();

    LocalStorage localStorage = getItWeb<LocalStorage>();
    _currentSalonId = localStorage.getSalonId();

    _promosBloc = getItWeb<PromosBloc>();
    _promosBloc.getPromos(_currentSalonId);

    _bonusCardsBloc = getItWeb<BonusCardsBloc>();
    _bonusCardsBloc.getBonusCards(_currentSalonId);

    _promosBloc.errorMessage.listen((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(error),
      ));
    });
    _bonusCardsBloc.errorMessage.listen((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(error),
      ));
    });

    _promosBloc.promoAdded.listen((isSuccess) {
      _showInfoNotifier.value = null;
    });
    _bonusCardsBloc.bonusCardAdded.listen((isSuccess) {
      _showInfoNotifier.value = null;
    });
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
            Flexible(
              fit: FlexFit.tight,
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: _buildPromosSection(),
                  ),
                  const SizedBox(width: 66),
                  Flexible(
                    flex: 2,
                    child: _buildBonusCardsSection(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // PaginationCounter(),
          ],
        ),
      );
    });
  }

  Widget _buildPromosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(AppLocalizations.of(context)!.promos,
            style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.w500, fontSize: 18)),
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
                    return _buildPromoItem(snapshot.data![index], index);
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

  Widget _buildPromoItem(Promo promo, int index) {
    return Container(
      height: 220,
      width: 220,
      padding: const EdgeInsets.only(left: 20, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC4C4C4).withOpacity(0.25),
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
            child: _buildPopupMenu(true, promo, index),
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
            style: AppTextStyle.bodyText,
          ),
          const SizedBox(height: 8),
          Text(
            promo.description ?? "",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: AppTextStyle.bodyText.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildBonusCardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(AppLocalizations.of(context)!.bonusCards,
            style: AppTextStyle.bodyText.copyWith(fontWeight: FontWeight.w500, fontSize: 18)),
        const SizedBox(height: 30),
        Flexible(
          child: StreamBuilder<List<BonusCard>>(
              stream: _bonusCardsBloc.bonusCardsLoaded,
              builder: (context, snapshot) {
                return GridView.count(
                  controller: ScrollController(),
                  scrollDirection: Axis.horizontal,
                  crossAxisCount: 2,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 30,
                  childAspectRatio: 1 / 1.5,
                  children: snapshot.data
                          ?.asMap()
                          .map((index, item) => MapEntry(index, _buildBonusCardItem(item, index)))
                          .values
                          .toList() ??
                      [],
                );
              }),
        ),
      ],
    );
  }

  Widget _buildBonusCardItem(BonusCard bonusCard, int index) {
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
                    style: AppTextStyle.bodyText.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 6),
                _buildPopupMenu(false, bonusCard, index),
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

  Widget _buildPopupMenu(bool isPromo, BaseEntity item, int index) {
    return PopupMenuButton(
      splashRadius: 5,
      position: PopupMenuPosition.under,
      icon: Icon(
        Icons.more_horiz,
        color: isPromo ? AppColors.hintColor : Colors.white,
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem<int>(
            value: 0,
            height: 32,
            child: Text(AppLocalizations.of(context)!.view, style: AppTextStyle.bodyText.copyWith(fontSize: 12)),
          ),
          PopupMenuItem<int>(
            value: 1,
            height: 32,
            child: Text(AppLocalizations.of(context)!.edit, style: AppTextStyle.bodyText.copyWith(fontSize: 12)),
          ),
          PopupMenuItem<int>(
            value: 2,
            height: 32,
            child: Text(AppLocalizations.of(context)!.delete,
                style: AppTextStyle.bodyText.copyWith(fontSize: 12, color: AppColors.red)),
          ),
        ];
      },
      onSelected: (value) {
        if (value == 0) {
          isPromo
              ? _showPromoInfoView(InfoAction.view, item, index)
              : _showBonusCardInfoView(InfoAction.view, item, index);
        } else if (value == 1) {
          isPromo
              ? _showPromoInfoView(InfoAction.edit, item, index)
              : _showBonusCardInfoView(InfoAction.edit, item, index);
        } else if (value == 2) {
          AlertBuilder().showAlertForDelete(context,
              isPromo ? AppLocalizations.of(context)!.promo1 : AppLocalizations.of(context)!.bonusCard1, item.name, () {
            if (isPromo) {
              _promosBloc.removePromo(item.id, index);
            } else {
              _bonusCardsBloc.removeBonusCard(item.id, index);
            }
            _showInfoNotifier.value = null;
          });
        }
      },
    );
  }

  void _showPromoInfoView(InfoAction infoAction, BaseEntity? item, int? index) {
    _showInfoNotifier.value = PromoInfoView(
      salonId: _currentSalonId,
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
            _showInfoNotifier.value = null;
          });
        }
      },
    );
  }

  void _showBonusCardInfoView(InfoAction infoAction, BaseEntity? item, int? index) {
    _showInfoNotifier.value = BonusCardInfoView(
      salonId: _currentSalonId,
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
            _showInfoNotifier.value = null;
          });
        }
      },
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
                () => _showPromoInfoView(InfoAction.add, null, null),
              ),
              const SizedBox(width: 8),
              _buildAddPromoOrCardButton(
                AppLocalizations.of(context)!.bonusCard,
                AppIcons.bonusCardPlaceholder,
                () => _showBonusCardInfoView(InfoAction.add, null, null),
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
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Text(title.toUpperCase(), style: AppTextStyle.bodyText),
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
              style: AppTextStyle.buttonText.copyWith(
                color: AppColors.darkRose,
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
