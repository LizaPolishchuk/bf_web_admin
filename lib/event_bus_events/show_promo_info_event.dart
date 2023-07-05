import 'package:bf_network_module/bf_network_module.dart';
import 'package:bf_web_admin/prezentation/widgets/info_container.dart';

class ShowPromoInfoEvent {
  final InfoAction infoAction;
  final BaseEntity? item;
  final int? index;

  ShowPromoInfoEvent(this.infoAction, this.item, this.index);
}
