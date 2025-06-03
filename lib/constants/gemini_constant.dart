class GeminiModels {
  /// Gemini 2.5 Pro phiên bản thử nghiệm (experimental), tối ưu cho coding, complex prompts, reasoning, mathematics và long context.
  static const String proExp2_5 = "gemini-2.5-pro-exp-03-25";
  /// Gemini 2.0 Flash phiên bản khả dụng rộng rãi, tối ưu cho hiệu suất nhanh chóng cho các tác vụ hàng ngày.
  static const String flash2_0 = "gemini-2.0-flash";
  /// Gemini 2.0 Flash Lite phiên bản khả dụng rộng rãi, tối ưu cho hiệu suất tiết kiệm chi phí.
  static const String flashLite2_0 = "gemini-2.0-flash-lite";
  /// Gemini 1.5 Flash, tối ưu cho tốc độ phản hồi nhanh và khả năng suy luận tốt.
  static const String flash1_5 = "gemini-1.5-flash";
  /// Gemini 1.5 Flash với 8 tỷ tham số, tối ưu cho instruction following, multitask multimodal understanding và mathematical problem-solving.
  static const String flash8B1_5 = "gemini-1.5-flash-8b";
  /// Gemini 1.5 Pro, được đánh giá là mô hình ngôn ngữ lớn và thông minh nhất của Google tại thời điểm ra mắt, phù hợp với nhiều tác vụ và có khả năng xử lý long context.
  static const String pro1_5 = "gemini-1.5-pro";

  /// Danh sách các models
  static List<String> models() => [
    proExp2_5, flash2_0, flashLite2_0, flash1_5, flash8B1_5, pro1_5
  ];
}