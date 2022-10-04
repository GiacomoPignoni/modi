import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/models/res/user_res.dart';
import 'package:modi/pages/partner/partner_page_controller.dart';
import 'package:modi/pages/partner/partner_page_request_row.dart';
import 'package:modi/widgets/inputs/button.dart';
import 'package:modi/widgets/visual/spinner.dart';
import 'package:provider/provider.dart';

class PartnerPageNoPartner extends StatelessWidget {
  const PartnerPageNoPartner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PartnerPageController>(context);
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          tr("partnerPage.noPartner"),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 50, top: 10),
          child: Button(
            text: tr("partnerPage.sendRequest"),
            onPressed: controller.showSendPartnerRequestDialog
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Text(
                tr("partnerPage.partnerRequests"),
                style: theme.textTheme.headline5,
              ),
            ],
          ),
        ),
        ValueListenableBuilder<List<PartnerRequestDetails>?>(
          valueListenable: controller.requests,
          builder: (context, requests, child) {
            if(requests == null) {
              return const Spinner();
            }

            if(requests.isEmpty) {
              return Text(
                tr("partnerPage.noRequests"),
                style: theme.textTheme.subtitle1,
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                requests.length, 
                (index) => PartnerRequestRow(
                  index: index, 
                  request: requests[index]
                )
              ),
            );
          },
        )
      ],
    );
  }
}
