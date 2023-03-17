import 'package:bf_web_admin/injection_container_web.dart';
import 'package:bf_web_admin/prezentation/widgets/info_container.dart';
import 'package:bf_web_admin/prezentation/widgets/rounded_button.dart';
import 'package:bf_web_admin/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class BonusCardInfoView extends StatefulWidget {
  final String salonId;
  final Promo? bonusCard;
  final InfoAction infoAction;
  final Function(Promo bonusCard, InfoAction action) onClickAction;

  const BonusCardInfoView({
    Key? key,
    this.bonusCard,
    required this.infoAction,
    required this.salonId,
    required this.onClickAction,
  }) : super(key: key);

  @override
  State<BonusCardInfoView> createState() => _BonusCardInfoViewState();
}

class _BonusCardInfoViewState extends State<BonusCardInfoView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  final ValueNotifier<Color?> _cardColorNotifier = ValueNotifier<Color?>(null);
  final ValueNotifier<bool> _enableButtonNotifier = ValueNotifier<bool>(false);

  late InfoAction _infoAction;
  late Promo? _cardForUpdate;

  late String _currentSalonId;

  final cardColors = [
    Color(0xffCAEBE4),
    Color(0xff83A7D3),
    Color(0xffFABB06),
    Color(0xffE59B9C),
    Color(0xffD75554),
    Color(0xff979797),
    Color(0xffBA83FF),
    Color(0xff86ECFF),
  ];

  @override
  void initState() {
    super.initState();

    LocalStorage localStorage = getItWeb<LocalStorage>();
    _currentSalonId = localStorage.getSalonId();

    _infoAction = widget.infoAction;
    _cardForUpdate = widget.bonusCard;

    if (_cardForUpdate != null) {
      _nameController.text = _cardForUpdate!.name;
      _descriptionController.text = _cardForUpdate!.description ?? "";
      _discountController.text = _cardForUpdate!.discount?.toString() ?? "";
      if (_cardForUpdate!.color != null) {
        _cardColorNotifier.value = Color(_cardForUpdate!.color!);
      }

      _enableButtonNotifier.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            _infoAction == InfoAction.view
                ? AppLocalizations.of(context)!.view
                : _infoAction == InfoAction.edit
                    ? AppLocalizations.of(context)!.redact
                    : AppLocalizations.of(context)!.addBonusCard,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 35),
        _infoAction == InfoAction.view ? _buildForViewMode() : _buildForEditMode(),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int lines = 1, bool digitsOnly = false}) {
    return TextField(
      controller: controller,
      onChanged: (text) {
        _checkIfEnableButton();
      },
      maxLines: lines,
      minLines: lines,
      enabled: _infoAction != InfoAction.view,
      inputFormatters: digitsOnly ? [FilteringTextInputFormatter.digitsOnly] : null,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        counterText: "",
        hintText: hint,
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _buildForViewMode() {
    return Column(children: [
      Text(
        _nameController.text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 15),
      Container(
        width: 227,
        height: 127,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _cardColorNotifier.value ?? AppColors.rose,
        ),
        alignment: Alignment.center,
        child: Text(
          "${_discountController.text}%",
          style: const TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
      const SizedBox(height: 15),
      SingleChildScrollView(
        child: Text(
          "${_descriptionController.text}\n\n\n\n\n",
          maxLines: 6,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.hintColor),
        ),
      ),
      const SizedBox(height: 120),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                _infoAction = InfoAction.edit;
              });
            },
            child: Text(
              AppLocalizations.of(context)!.edit,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.hintColor,
                    decoration: TextDecoration.underline,
                  ),
            ),
          ),
          TextButton(
            onPressed: () {
              widget.onClickAction(_cardForUpdate!, InfoAction.delete);
            },
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.red,
                  ),
            ),
          ),
        ],
      ),
    ]);
  }

  Widget _buildForEditMode() {
    return Column(
      children: [
        _buildTextField(_nameController, AppLocalizations.of(context)!.title),
        const SizedBox(height: 15),
        _buildTextField(_descriptionController, AppLocalizations.of(context)!.description, lines: 6),
        const SizedBox(height: 15),
        _buildTextField(_discountController, "${AppLocalizations.of(context)!.discount}, %", digitsOnly: true),
        const SizedBox(height: 15),
        Container(
          height: 80,
          alignment: Alignment.center,
          child: ValueListenableBuilder<Color?>(
            valueListenable: _cardColorNotifier,
            builder: (context, selectedColor, child) {
              print("selectedColor: $selectedColor");
              return GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 19,
                mainAxisSpacing: 19,
                scrollDirection: Axis.horizontal,
                children: cardColors
                    .map(
                      (color) => InkWell(
                        onTap: () {
                          if (color != selectedColor) {
                            _cardColorNotifier.value = color;
                          }
                          _checkIfEnableButton();
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: color,
                            border: Border.all(color: selectedColor == color ? Colors.black : Colors.transparent),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
        const SizedBox(height: 40),
        ValueListenableBuilder<bool>(
          valueListenable: _enableButtonNotifier,
          builder: (context, value, child) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: RoundedButton(
                text: AppLocalizations.of(context)!.save,
                isEnabled: value,
                onPressed: () {
                  Promo cardToUpdate;
                  if (_infoAction == InfoAction.add) {
                    cardToUpdate = Promo(
                      name: _nameController.text,
                      description: _descriptionController.text,
                      promoType: PromoType.bonus_card.name,
                      creatorSalon: _currentSalonId,
                      discount: int.tryParse(_discountController.text),
                      //todo add expired date
                      // expiredDate:
                    );

                    widget.onClickAction(cardToUpdate, _infoAction);
                  } else {
                    if (_cardForUpdate != null) {
                      cardToUpdate = _cardForUpdate!.copy(
                        name: _nameController.text,
                        description: _descriptionController.text,
                        discount: int.tryParse(_discountController.text),
                        creatorSalon: _currentSalonId,
                      );

                      widget.onClickAction(cardToUpdate, _infoAction);
                    }
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }

  void _checkIfEnableButton() {
    if (_nameController.text.length > 1 && _discountController.text.isNotEmpty && _cardColorNotifier.value != null) {
      _enableButtonNotifier.value = true;
    } else {
      _enableButtonNotifier.value = false;
    }
  }

  @override
  void dispose() {
    _enableButtonNotifier.dispose();
    super.dispose();
  }
}
