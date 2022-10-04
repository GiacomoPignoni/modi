class ModiUser {
  String nickname;
  int tokens;
  String email;
  String? patnerNickname;
  int combo;

  ModiUser.fromJson(Map<String, dynamic> json) :
    nickname = json["nickname"] ?? "-",
    tokens = json["tokens"] ?? 0,
    email = json["email"] ?? "-",
    patnerNickname = json["partnerNickname"],
    combo = json["combo"] ?? 0;
}
