import 'package:modi/models/res/base_res.dart';
import 'package:modi/models/modi_user.dart';

class CheckNicknameRes extends BaseRes {
  final bool available;

  CheckNicknameRes.fromJson(Map<String, dynamic> json) :
    available = json["available"] ?? false,
    super.fromJson(json);
}

class GetModiUserRes extends BaseRes {
  final ModiUser user;

  GetModiUserRes.fromJson(Map<String, dynamic> json) :
    user = ModiUser.fromJson(json["user"]),
    super.fromJson(json);
}

class GetPartnerRequestsRes extends BaseRes {
  final List<PartnerRequestDetails> requests;

  GetPartnerRequestsRes.fromJson(Map<String, dynamic> json) :
    requests = (json["requests"] as List<dynamic>).map<PartnerRequestDetails>((x) => PartnerRequestDetails.fromJson(x)).toList(),
    super.fromJson(json);
}

class PartnerRequestDetails {
  final String id;
  final String nickname;

  PartnerRequestDetails.fromJson(Map<String, dynamic> json) :
    id = json["id"],
    nickname = json["nickname"];
}
