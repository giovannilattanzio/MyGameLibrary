class IGDBPlatformFields {
  static const String id = 'id';
  static const String abbreviation = 'abbreviation';
  static const String alternative_name = 'alternative_name';
  static const String category = 'category';
  static const String created_at = 'created_at';
  static const String generation = 'generation';
  static const String name = 'name';
  static const String platform_logo = 'platform_logo';
  static const String product_family = 'product_family';
  static const String slug = 'slug';
  static const String summary = 'summary';
  static const String updated_at = 'updated_at';
  static const String url = 'url';
  static const String versions = 'versions';
  static const String websites = 'websites';
}

class IGDBPlatformLogoFields {
  static const String id = 'id';
  static const String alpha_channel = 'alpha_channel';
  static const String animated = 'animated';
  static const String height = 'height';
  static const String image_id = 'image_id';
  static const String url = 'url';
  static const String width = 'width';
}

class IGDBPlatformEnums {
  static const Map<int, String> categories = {
    1: 'console',
    2: 'arcade',
    3: 'platform',
    4: 'operating_system',
    5: 'portable_console',
    6: 'computer'
  };
}