import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_adminka/utils/app_images.dart';
import 'package:salons_adminka/utils/app_text_style.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class FeedbackInfoView extends StatefulWidget {
  final String salonId;
  final List<FeedbackEntity> feedbacks;
  final int index;
  final VoidCallback onClickClose;

  const FeedbackInfoView({
    Key? key,
    required this.feedbacks,
    required this.salonId,
    required this.onClickClose,
    required this.index,
  }) : super(key: key);

  @override
  State<FeedbackInfoView> createState() => _FeedbackInfoViewState();
}

class _FeedbackInfoViewState extends State<FeedbackInfoView> {
  late FeedbackEntity _feedbackEntity;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();

    _feedbackEntity = widget.feedbacks[widget.index];
    _currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(AppLocalizations.of(context)!.view, style: AppTextStyle.titleText),
        const SizedBox(height: 35),
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(_feedbackEntity.authorAvatar ?? ""),
          backgroundColor: AppColors.rose,
        ),
        const SizedBox(height: 20),
        Text(_feedbackEntity.authorName, style: AppTextStyle.titleText),
        const SizedBox(height: 20),
        SizedBox(
          height: 16,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return SvgPicture.asset(AppIcons.icStar);
            },
            itemCount: _feedbackEntity.points,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(width: 5);
            },
          ),
        ),
        const SizedBox(height: 40),
        Flexible(
          fit: FlexFit.tight,
          child: SingleChildScrollView(
            child: Text(
              _feedbackEntity.feedbackText,
              textAlign: TextAlign.center,
              style: AppTextStyle.hintText.copyWith(
                color: AppColors.textColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildBottomButtons(),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      children: [
        Flexible(
          child: InkWell(
            onTap: () {
              widget.onClickClose();
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  AppIcons.icCircleArrowLeft,
                  color: AppColors.hintColor,
                ),
                const SizedBox(width: 5),
                Text(AppLocalizations.of(context)!.close, style: AppTextStyle.hintText),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: InkWell(
            onTap: () {
              setState(() {
                _currentIndex += 1;
                _feedbackEntity = widget.feedbacks[_currentIndex];
              });
            },
            child: Row(
              children: [
                Text(AppLocalizations.of(context)!.nextFeedback,
                    style: AppTextStyle.hintText.copyWith(color: AppColors.textColor)),
                const SizedBox(width: 5),
                SvgPicture.asset(
                  AppIcons.icCircleArrowRight,
                  color: AppColors.textColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
