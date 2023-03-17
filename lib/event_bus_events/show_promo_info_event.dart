import 'package:bf_web_admin/prezentation/widgets/info_container.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class ShowPromoInfoEvent {
  final InfoAction infoAction;
  final BaseEntity? item;
  final int? index;

  ShowPromoInfoEvent(this.infoAction, this.item, this.index);
}
