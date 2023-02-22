import 'package:salons_adminka/prezentation/widgets/info_container.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class ShowBonusCardInfoEvent {
  final InfoAction infoAction;
  final BaseEntity? item;
  final int? index;

  ShowBonusCardInfoEvent(this.infoAction, this.item, this.index);
}
