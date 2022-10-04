import 'package:flutter/material.dart';
import 'package:modi/models/res/user_res.dart';
import 'package:modi/pages/partner/partner_page_controller.dart';
import 'package:modi/widgets/inputs/button_icon.dart';
import 'package:modi/widgets/visual/card.dart';
import 'package:modi/widgets/visual/spinner.dart';
import 'package:provider/provider.dart';

class PartnerRequestRow extends StatelessWidget {
  final int index;
  final PartnerRequestDetails request;

  const PartnerRequestRow({
    required this.index,
    required this.request,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PartnerPageController>(context);
    final theme = Theme.of(context);

    return MyCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Text(request.nickname),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: controller.miniLoading,
                  builder: (context, miniLoading, child) {
                    if(miniLoading == index) {
                      return const Padding(
                        padding: EdgeInsets.fromLTRB(8, 5, 2, 5),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: Spinner()
                        ),
                      );
                    }
                    return ButtonIcon(
                      icon: Icons.close_rounded,
                      iconSize: 30,
                      color: theme.colorScheme.error,
                      onPressed: () => controller.confirmRejectRequest(request, index)
                    );
                  }
                ),
                ButtonIcon(
                  icon: Icons.check_rounded,
                  iconSize: 30,
                  onPressed: () => controller.acceptRequest(request, index)
                ),
              ],
            )
          )
        ],
      ),
    );
  }
}
