import 'dart:async';

import 'package:flutter/material.dart';
import 'package:salons_adminka/injection_container_web.dart';
import 'package:salons_adminka/prezentation/feedbacks_page/feedback_info_view.dart';
import 'package:salons_adminka/prezentation/feedbacks_page/feedbacks_bloc.dart';
import 'package:salons_adminka/prezentation/widgets/custom_app_bar.dart';
import 'package:salons_adminka/prezentation/widgets/info_container.dart';
import 'package:salons_adminka/prezentation/widgets/search_pannel.dart';
import 'package:salons_adminka/prezentation/widgets/table_widget.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class FeedbacksPage extends StatefulWidget {
  final Salon? salon;

  const FeedbacksPage({Key? key, this.salon}) : super(key: key);

  @override
  State<FeedbacksPage> createState() => _FeedbacksPageState();
}

class _FeedbacksPageState extends State<FeedbacksPage> {
  late String _currentSalonId;

  late FeedbacksBloc _feedbacksBloc;

  Timer? _searchTimer;
  final ValueNotifier<Widget?> _showInfoNotifier = ValueNotifier<Widget?>(null);

  @override
  void initState() {
    super.initState();

    _currentSalonId = getItWeb<LocalStorage>().getSalonId();

    _feedbacksBloc = getItWeb<FeedbacksBloc>();
    _feedbacksBloc.getFeedbacks(_currentSalonId);

    _feedbacksBloc.errorMessage.listen((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(error),
      ));
    });

    // _feedbacksBloc.serviceAdded.listen((isSuccess) {
    //   _showInfoNotifier.value = null;
    // });
    // _feedbacksBloc.serviceUpdated.listen((isSuccess) {
    //   _showInfoNotifier.value = null;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return InfoContainer(
      onPressedAddButton: () {},
      hideAddButton: true,
      showInfoNotifier: _showInfoNotifier,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomAppBar(title: "Отзывы"),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              const SizedBox(width: 60),
              SearchPanel(
                hintText: "Поиск услуги",
                onSearch: (text) {
                  _searchTimer = Timer(const Duration(milliseconds: 600), () {
                    _feedbacksBloc.searchFeedbacks(text);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Flexible(
            fit: FlexFit.tight,
            child: _buildServicesTable(),
          ),
          const SizedBox(height: 20),
          // PaginationCounter(),
        ],
      ),
    );
  }

  Widget _buildServicesTable() {
    return StreamBuilder<List<FeedbackEntity>>(
        stream: _feedbacksBloc.feedbacksLoaded,
        builder: (context, snapshot) {
          return TableWidget(
            columnTitles: const ["Имя", "Дата отзыва", "Оценка", "Отзыв", "Действия"],
            items: snapshot.data ?? [],
            onClickLook: (item, index) {
              _showInfoView(item, index);
            },
          );
        });
  }

  void _showInfoView(BaseEntity item, int index) {
    _showInfoNotifier.value = FeedbackInfoView(
      salonId: _currentSalonId,
      feedbacks: _feedbacksBloc.feedbacksList,
      index: index,
      onClickClose: () {
        _showInfoNotifier.value = null;
      },
    );
  }

  @override
  void dispose() {
    _showInfoNotifier.dispose();
    _searchTimer?.cancel();

    super.dispose();
  }
}