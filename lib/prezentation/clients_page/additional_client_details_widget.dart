import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:salons_adminka/prezentation/widgets/colored_circle.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class AdditionalClientDetails extends StatefulWidget {
  final Client? client;

  const AdditionalClientDetails({Key? key, this.client}) : super(key: key);

  @override
  State<AdditionalClientDetails> createState() => _AdditionalClientDetailsState();
}

class _AdditionalClientDetailsState extends State<AdditionalClientDetails> {
  late Client? _client;

  @override
  void initState() {
    super.initState();

    _client = widget.client;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(46),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Flexible(child: _buildServicesMasters(AppLocalizations.of(context)!.services, _serviceList)),
                const SizedBox(width: 30),
                Flexible(child: _buildServicesMasters(AppLocalizations.of(context)!.masters, _mastersList)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Flexible(
            flex: 2,
            child: Row(
              children: [
                Flexible(child: _buildLastVisits()),
                const SizedBox(width: 40),
                Flexible(child: _buildBonusCards()),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Service> _serviceList = [
    Service("id", "Маникюр", "", 100, "creatorSalon", "categoryId", "categoryName", 0xffE59B9C, 60),
    Service("id", "Маникюр", "", 100, "creatorSalon", "categoryId", "categoryName", 0xffE59B9C, 60),
    Service("id", "Маникюр", "", 100, "creatorSalon", "categoryId", "categoryName", 0xffE59B9C, 60),
    Service("id", "Маникюр", "", 100, "creatorSalon", "categoryId", "categoryName", 0xffE59B9C, 60),
  ];

  List<Master> _mastersList = [
    Master("id", "Дарина", "", "", "", "", [], {}, "status", "phoneNumber"),
    Master("id", "Карина", "", "", "", "", [], {}, "status", "phoneNumber"),
    Master("id", "Владік", "", "", "", "", [], {}, "status", "phoneNumber"),
  ];

  Widget _buildServicesMasters(String title, List<BaseEntity> items) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        Flexible(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _buildServiceMasterItem(
                items[index].name,
                (items[index] is Service) ? (items[index] as Service).categoryColor : null,
              );
            },
            itemCount: items.length,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceMasterItem(String name, int? color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        ColoredCircle(color: (color != null) ? Color(color) : Colors.grey),
        Flexible(
          child: Text(
            name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ]),
    );
  }

  List<OrderEntity> _ordersList = [
    OrderEntity("id", "clientId", "Liza", "salonId", "Salon", "masterId", "Master Nika", "masterAvatar", "serviceId",
        "Маникюр", DateTime.now(), 60, Colors.red.value),
    OrderEntity("id", "clientId", "Liza", "salonId", "Salon", "masterId", "Master Nika", "masterAvatar", "serviceId",
        "Маникюр", DateTime.now(), 60, Colors.red.value),
    OrderEntity("id", "clientId", "Liza", "salonId", "Salon", "masterId", "Master Nika", "masterAvatar", "serviceId",
        "Маникюр", DateTime.now(), 60, Colors.red.value)
  ];

  Widget _buildLastVisits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSectionTitle(AppLocalizations.of(context)!.lastVisits),
        Flexible(
          child: ListView.separated(
            itemBuilder: (context, index) {
              OrderEntity order = _ordersList[index];

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('dd-MMM-yyyy').format(order.date),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                  ),
                  Text(
                    order.serviceName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                  ),
                  Text(
                    order.masterName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                  ),
                ],
              );
            },
            itemCount: _ordersList.length,
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 0.5,
                width: double.infinity,
                color: AppColors.hintColor,
                margin: EdgeInsets.symmetric(vertical: 10),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  Widget _buildBonusCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSectionTitle(AppLocalizations.of(context)!.bonusCards),
        Flexible(
          child: GridView.count(
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 1.5,
            crossAxisCount: 2,
            children: [
              Container(
                color: Colors.blueAccent,
              ),
              Container(
                color: Colors.green,
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
