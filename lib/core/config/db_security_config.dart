class DbSecurityConfig {
  final bool secure;
  final String? phrase;

  const DbSecurityConfig({
    this.secure = true,
    this.phrase,
  });
}
