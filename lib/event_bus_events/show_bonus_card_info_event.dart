import 'package:bf_network_module/bf_network_module.dart';
import 'package:bf_web_admin/prezentation/widgets/info_container.dart';

class ShowBonusCardInfoEvent {
  final InfoAction infoAction;
  final BaseEntity? item;
  final int? index;

  ShowBonusCardInfoEvent(this.infoAction, this.item, this.index);
}
