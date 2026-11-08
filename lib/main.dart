import 'package:flutter/material.dart';

void main() {
  runApp(const TemperatureConverterApp());
}

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7FC),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF7F9FD),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 17,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE1E7F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE1E7F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFF2563EB),
              width: 1.7,
            ),
          ),
        ),
      ),
      home: const ConverterScreen(),
    );
  }
}

enum ConversionType {
  celsiusToFahrenheit,
  fahrenheitToCelsius,
}

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController _temperatureController =
      TextEditingController();

  ConversionType _selectedType = ConversionType.fahrenheitToCelsius;
  String? _result;
  String? _errorMessage;

  String get _inputUnit {
    return _selectedType == ConversionType.celsiusToFahrenheit ? '°C' : '°F';
  }

  String get _outputUnit {
    return _selectedType == ConversionType.celsiusToFahrenheit ? '°F' : '°C';
  }

  String get _selectedTypeLabel {
    return _selectedType == ConversionType.celsiusToFahrenheit
        ? 'Celsius to Fahrenheit'
        : 'Fahrenheit to Celsius';
  }

  void _calculate() {
    final inputText = _temperatureController.text.trim();

    setState(() {
      _errorMessage = null;
      _result = null;

      if (inputText.isEmpty) {
        _errorMessage = 'Please enter a temperature value.';
        return;
      }

      final inputValue = double.tryParse(inputText);
      if (inputValue == null || !inputValue.isFinite) {
        _errorMessage = 'Please enter a valid number.';
        return;
      }

      final convertedValue = _selectedType ==
              ConversionType.celsiusToFahrenheit
          ? (inputValue * 9 / 5) + 32
          : (inputValue - 32) * 5 / 9;

      _result = '${convertedValue.toStringAsFixed(2)} $_outputUnit';
    });
  }

  void _onConversionChanged(ConversionType? value) {
    if (value == null) return;
    setState(() {
      _selectedType = value;
      _result = null;
      _errorMessage = null;
    });
  }

  void _clear() {
    setState(() {
      _temperatureController.clear();
      _result = null;
      _errorMessage = null;
      _selectedType = ConversionType.fahrenheitToCelsius;
    });
  }

  @override
  void dispose() {
    _temperatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF17345C).withValues(alpha: 0.08),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 58,
                          width: 58,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.device_thermostat_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          'Temperature Converter',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF14213D),
                            letterSpacing: -0.6,
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          'Convert Celsius and Fahrenheit in seconds.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF718096),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildFieldLabel('Temperature'),
                        const SizedBox(height: 9),
                        TextField(
                          controller: _temperatureController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _calculate(),
                          decoration: InputDecoration(
                            hintText: 'Enter temperature',
                            suffixText: _inputUnit,
                            prefixIcon: const Icon(
                              Icons.thermostat_outlined,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                        const SizedBox(height: 21),
                        _buildFieldLabel('Conversion Type'),
                        const SizedBox(height: 9),
                        DropdownButtonFormField<ConversionType>(
                          initialValue: _selectedType,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.swap_horiz_rounded,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: ConversionType.celsiusToFahrenheit,
                              child: Text('Celsius to Fahrenheit (°C → °F)'),
                            ),
                            DropdownMenuItem(
                              value: ConversionType.fahrenheitToCelsius,
                              child: Text('Fahrenheit to Celsius (°F → °C)'),
                            ),
                          ],
                          onChanged: _onConversionChanged,
                        ),
                        const SizedBox(height: 26),
                        SizedBox(
                          height: 54,
                          child: FilledButton.icon(
                            onPressed: _calculate,
                            icon: const Icon(Icons.calculate_outlined),
                            label: const Text(
                              'Calculate',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF1F2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFFECdd3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Color(0xFFBE123C),
                                  size: 20,
                                ),
                                const SizedBox(width: 9),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(
                                      color: Color(0xFFBE123C),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(
                              color: const Color(0xFFDCEBFF),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    color: Color(0xFF2563EB),
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'RESULT',
                                    style: TextStyle(
                                      color: Color(0xFF52709B),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _result ?? 'Your result will appear here',
                                style: TextStyle(
                                  fontSize: _result == null ? 15 : 27,
                                  fontWeight: FontWeight.w800,
                                  color: _result == null
                                      ? const Color(0xFF8A9AB2)
                                      : const Color(0xFF1746A2),
                                ),
                              ),
                              if (_result != null) ...[
                                const SizedBox(height: 5),
                                Text(
                                  _selectedTypeLabel,
                                  style: const TextStyle(
                                    color: Color(0xFF718096),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextButton.icon(
                          onPressed: _clear,
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                          label: const Text('Reset converter'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Simple • Accurate • Fast',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF8290A5),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF334155),
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
    );
  }
}
