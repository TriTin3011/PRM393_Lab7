import 'package:flutter/material.dart';

void main() => runApp(const Lab7App());

class Lab7App extends StatelessWidget {
  const Lab7App({super.key});

  static const ink = Color(0xFF172C4D);
  static const teal = Color(0xFF167D77);
  static const canvas = Color(0xFFF3F7F6);

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: teal,
      brightness: Brightness.light,
      surface: Colors.white,
    );

    return MaterialApp(
      title: 'Tạo tài khoản',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: canvas,
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF8FAFA),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDCE5E4)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDCE5E4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: teal, width: 1.7),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFB42318)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFB42318), width: 1.7),
          ),
        ),
      ),
      home: const SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _acceptedTerms = false;
  bool _showPassword = false;
  bool _showConfirm = false;
  bool _isSubmitting = false;
  bool _submitted = false;

  int get _passwordScore {
    final value = _password.text;
    var score = 0;
    if (value.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(value)) score++;
    if (RegExp(r'[0-9]').hasMatch(value)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(value)) score++;
    return score;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Vui lòng nhập họ và tên.';
    if (name.length < 2) return 'Tên cần có ít nhất 2 ký tự.';
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Vui lòng nhập email.';
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$').hasMatch(email)) {
      return 'Email chưa đúng định dạng.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Vui lòng tạo mật khẩu.';
    if (password.length < 8) return 'Mật khẩu cần ít nhất 8 ký tự.';
    return null;
  }

  String? _validateConfirm(String? value) {
    if ((value ?? '').isEmpty) return 'Vui lòng nhập lại mật khẩu.';
    if (value != _password.text) return 'Mật khẩu chưa khớp.';
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _submitted = true);
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đồng ý với điều khoản để tiếp tục.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (_email.text.trim().toLowerCase().contains('taken')) {
      _emailFocus.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email này đã được sử dụng. Hãy thử email khác.')),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle_rounded, color: Lab7App.teal, size: 42),
        title: const Text('Tạo tài khoản thành công'),
        content: Text('Chào ${_name.text.trim()}, tài khoản của bạn đã sẵn sàng.'),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hoàn tất'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 760;
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.symmetric(
                horizontal: wide ? 32 : 20,
                vertical: wide ? 28 : 18,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1040),
                  child: wide ? _wideLayout() : _phoneLayout(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _phoneLayout() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _brandRow(),
          const SizedBox(height: 24),
          _intro(),
          const SizedBox(height: 22),
          _formCard(),
          const SizedBox(height: 18),
          _footerNote(),
        ],
      );

  Widget _wideLayout() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.only(right: 36, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _brandRow(),
                  const SizedBox(height: 72),
                  _intro(),
                  const SizedBox(height: 30),
                  _benefits(),
                  const SizedBox(height: 34),
                  _footerNote(),
                ],
              ),
            ),
          ),
          Expanded(flex: 10, child: _formCard()),
        ],
      );

  Widget _brandRow() => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Lab7App.ink,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 21),
          ),
          const SizedBox(width: 11),
          const Text(
            'Mầm',
            style: TextStyle(
              color: Lab7App.ink,
              fontSize: 21,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2EF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'LAB 07',
              style: TextStyle(
                color: Lab7App.teal,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      );

  Widget _intro() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFE5F2EF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.spa_rounded, size: 15, color: Lab7App.teal),
                SizedBox(width: 6),
                Text(
                  'BẮT ĐẦU HÀNH TRÌNH CỦA BẠN',
                  style: TextStyle(
                    color: Lab7App.teal,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.65,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tạo tài khoản,\nmở lối khám phá.',
            style: TextStyle(
              color: Lab7App.ink,
              fontSize: 34,
              height: 1.12,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.1,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Chỉ mất một phút để bắt đầu. Thông tin của bạn luôn được bảo vệ an toàn.',
            style: TextStyle(color: Color(0xFF53647A), fontSize: 15, height: 1.55),
          ),
        ],
      );

  Widget _benefits() => const Column(
        children: [
          _Benefit(icon: Icons.bolt_rounded, title: 'Thiết lập nhanh', text: 'Tạo tài khoản chỉ trong vài bước.'),
          SizedBox(height: 15),
          _Benefit(icon: Icons.lock_outline_rounded, title: 'Riêng tư mặc định', text: 'Mật khẩu được giữ an toàn.'),
          SizedBox(height: 15),
          _Benefit(icon: Icons.devices_rounded, title: 'Dùng ở mọi nơi', text: 'Tiếp tục trên điện thoại hoặc web.'),
        ],
      );

  Widget _formCard() => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE6ECEB)),
          boxShadow: const [
            BoxShadow(color: Color(0x10172C4D), blurRadius: 28, offset: Offset(0, 12)),
          ],
        ),
        child: Form(
          key: _formKey,
          autovalidateMode: _submitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Thông tin đăng ký',
                style: TextStyle(color: Lab7App.ink, fontSize: 21, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 5),
              const Text('Điền thông tin bên dưới để tạo tài khoản.', style: TextStyle(color: Color(0xFF66758A), fontSize: 13, height: 1.5)),
              const SizedBox(height: 22),
              _fieldLabel('Họ và tên'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                validator: _validateName,
                onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                decoration: _decoration('Nguyễn Minh Anh', Icons.person_outline_rounded),
              ),
              const SizedBox(height: 16),
              _fieldLabel('Email'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _email,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: _validateEmail,
                onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                decoration: _decoration('ban@example.com', Icons.mail_outline_rounded),
              ),
              const SizedBox(height: 16),
              _fieldLabel('Mật khẩu'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _password,
                focusNode: _passwordFocus,
                obscureText: !_showPassword,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                validator: _validatePassword,
                onChanged: (_) => setState(() {}),
                onFieldSubmitted: (_) => _confirmFocus.requestFocus(),
                decoration: _decoration('Tối thiểu 8 ký tự', Icons.lock_outline_rounded).copyWith(
                  suffixIcon: IconButton(
                    tooltip: _showPassword ? 'Ẩn mật khẩu' : 'Hiện mật khẩu',
                    onPressed: () => setState(() => _showPassword = !_showPassword),
                    icon: Icon(_showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                  ),
                ),
              ),
              if (_password.text.isNotEmpty) ...[
                const SizedBox(height: 9),
                _passwordStrength(),
              ],
              const SizedBox(height: 16),
              _fieldLabel('Xác nhận mật khẩu'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _confirm,
                focusNode: _confirmFocus,
                obscureText: !_showConfirm,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
                validator: _validateConfirm,
                onFieldSubmitted: (_) => _submit(),
                decoration: _decoration('Nhập lại mật khẩu', Icons.verified_user_outlined).copyWith(
                  suffixIcon: IconButton(
                    tooltip: _showConfirm ? 'Ẩn mật khẩu' : 'Hiện mật khẩu',
                    onPressed: () => setState(() => _showConfirm = !_showConfirm),
                    icon: Icon(_showConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _termsRow(),
              const SizedBox(height: 18),
              SizedBox(
                height: 54,
                child: FilledButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: Lab7App.teal,
                    disabledBackgroundColor: const Color(0xFF9BBDB9),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('Tạo tài khoản'), SizedBox(width: 8), Icon(Icons.arrow_forward_rounded, size: 18)],
                        ),
                ),
              ),
              const SizedBox(height: 17),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield_outlined, color: Lab7App.teal, size: 16),
                  SizedBox(width: 7),
                  Flexible(child: Text('Thông tin của bạn được bảo mật.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF66758A), fontSize: 12))),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _fieldLabel(String text) => Text(
        text,
        style: const TextStyle(color: Lab7App.ink, fontSize: 13, fontWeight: FontWeight.w700),
      );

  InputDecoration _decoration(String hint, IconData icon) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9AA7B4), fontSize: 14),
        prefixIcon: Icon(icon, size: 19, color: const Color(0xFF78899A)),
      );

  Widget _passwordStrength() {
    final score = _passwordScore;
    final color = score <= 1 ? const Color(0xFFB42318) : (score <= 2 ? const Color(0xFFB7791F) : Lab7App.teal);
    final label = score <= 1 ? 'Yếu' : (score <= 2 ? 'Trung bình' : 'Tốt');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (index) => Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index == 3 ? 0 : 5),
                  decoration: BoxDecoration(
                    color: index < score ? color : const Color(0xFFE5EBEA),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              )),
        ),
        const SizedBox(height: 5),
        Text('Độ mạnh: $label', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _termsRow() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: Checkbox(
              value: _acceptedTerms,
              activeColor: Lab7App.teal,
              onChanged: (value) => setState(() => _acceptedTerms = value ?? false),
              semanticLabel: 'Đồng ý với điều khoản và chính sách bảo mật',
            ),
          ),
          const SizedBox(width: 5),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text.rich(
                TextSpan(
                  style: TextStyle(color: Color(0xFF53647A), fontSize: 12, height: 1.5),
                  children: [
                    TextSpan(text: 'Tôi đồng ý với '),
                    TextSpan(text: 'Điều khoản sử dụng', style: TextStyle(color: Lab7App.teal, fontWeight: FontWeight.w700)),
                    TextSpan(text: ' và '),
                    TextSpan(text: 'Chính sách bảo mật', style: TextStyle(color: Lab7App.teal, fontWeight: FontWeight.w700)),
                    TextSpan(text: '.'),
                  ],
                ),
              ),
            ),
          ),
        ],
      );

  Widget _footerNote() => const Text(
        'Bài thực hành Flutter · Lab 7',
        textAlign: TextAlign.center,
        style: TextStyle(color: Color(0xFF8996A3), fontSize: 12),
      );
}

class _Benefit extends StatelessWidget {
  const _Benefit({required this.icon, required this.title, required this.text});

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: const Color(0xFFE5F2EF), borderRadius: BorderRadius.circular(13)),
            child: Icon(icon, color: Lab7App.teal, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Lab7App.ink, fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(text, style: const TextStyle(color: Color(0xFF66758A), fontSize: 12)),
              ],
            ),
          ),
        ],
      );
}
