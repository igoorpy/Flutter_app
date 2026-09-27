import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora Interativa',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF17171C),
        useMaterial3: true,
      ),
      home: const CalculadoraScreen(),
    );
  }
}

class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  String _display = '0';
  String _expressaoEmAndamento = '';
  double? _primeiroNumero;
  String? _operador;
  bool _novoNumero = true;
  final List<String> _historico = [];

  void _onPressionarBotao(String texto) {
    setState(() {
      if (texto == 'C') {
        _display = '0';
        _expressaoEmAndamento = '';
        _primeiroNumero = null;
        _operador = null;
        _novoNumero = true;
      } else if (texto == '⌫') {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = '0';
          _novoNumero = true;
        }
      } else if (texto == '%') {
        double valor = double.tryParse(_display.replaceAll(',', '.')) ?? 0;
        valor = valor / 100;
        _display = _formatarNumero(valor);
      } else if (texto == '+' || texto == '-' || texto == '×' || texto == '÷') {
        double valorAtual = double.tryParse(_display.replaceAll(',', '.')) ?? 0;

        if (_primeiroNumero != null && _operador != null && !_novoNumero) {
          _calcularResultadoParcial(valorAtual);
        } else {
          _primeiroNumero = valorAtual;
        }

        _operador = texto;
        _expressaoEmAndamento = '${_formatarNumero(_primeiroNumero!)} $texto ';
        _novoNumero = true;
      } else if (texto == '=') {
        if (_primeiroNumero != null && _operador != null) {
          double segundoNumero =
              double.tryParse(_display.replaceAll(',', '.')) ?? 0;
          double resultado = 0;

          switch (_operador) {
            case '+':
              resultado = _primeiroNumero! + segundoNumero;
              break;
            case '-':
              resultado = _primeiroNumero! - segundoNumero;
              break;
            case '×':
              resultado = _primeiroNumero! * segundoNumero;
              break;
            case '÷':
              resultado = segundoNumero != 0
                  ? _primeiroNumero! / segundoNumero
                  : 0;
              break;
          }

          String num1Str = _formatarNumero(_primeiroNumero!);
          String num2Str = _formatarNumero(segundoNumero);
          String resStr = _formatarNumero(resultado);

          String operacaoCompleta = '$num1Str $_operador $num2Str = $resStr';
          _historico.insert(0, operacaoCompleta);

          _expressaoEmAndamento = '$num1Str $_operador $num2Str =';
          _display = resStr;
          _primeiroNumero = null;
          _operador = null;
          _novoNumero = true;
        }
      } else {
        if (_novoNumero) {
          _display = texto == ',' ? '0,' : texto;
          _novoNumero = false;
        } else {
          if (texto == ',' && _display.contains(',')) return;
          _display += texto;
        }

        if (_operador != null && _primeiroNumero != null) {
          _expressaoEmAndamento =
              '${_formatarNumero(_primeiroNumero!)} $_operador $_display';
        }
      }
    });
  }

  void _calcularResultadoParcial(double segundoNumero) {
    double resultado = 0;
    switch (_operador) {
      case '+':
        resultado = _primeiroNumero! + segundoNumero;
        break;
      case '-':
        resultado = _primeiroNumero! - segundoNumero;
        break;
      case '×':
        resultado = _primeiroNumero! * segundoNumero;
        break;
      case '÷':
        resultado = segundoNumero != 0 ? _primeiroNumero! / segundoNumero : 0;
        break;
    }
    _primeiroNumero = resultado;
    _display = _formatarNumero(resultado);
  }

  String _formatarNumero(double valor) {
    if (valor % 1 == 0) {
      return valor.toInt().toString();
    }
    return valor.toStringAsFixed(2).replaceAll('.', ',');
  }

  void _limparHistorico() {
    setState(() {
      _historico.clear();
    });
  }

  Widget _criarBotao(
    String texto, {
    Color? corFundo,
    Color? corTexto,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: corFundo ?? const Color(0xFF2E2F38),
            foregroundColor: corTexto ?? Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () => _onPressionarBotao(texto),
          child: Text(
            texto,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
        centerTitle: true,
        backgroundColor: const Color(0xFF17171C),
        actions: [
          IconButton(
            tooltip: 'Limpar Histórico',
            icon: const Icon(Icons.delete_outline, color: Colors.orangeAccent),
            onPressed: _limparHistorico,
          ),
        ],
      ),
      body: Column(
        children: [
          // Painel do Histórico
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2E2F38).withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _historico.isEmpty
                  ? const Center(
                      child: Text(
                        'Histórico de operações vazio',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _historico.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text(
                            _historico[index],
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),

          // Visor da Operação e Resultado
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            alignment: Alignment.bottomRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _expressaoEmAndamento.isEmpty ? ' ' : _expressaoEmAndamento,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _display,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.grey),

          // Teclado da Calculadora (Grade Uniforme 4x5)
          Column(
            children: [
              Row(
                children: [
                  _criarBotao(
                    'C',
                    corFundo: const Color(0xFF4E4E5A),
                    corTexto: Colors.redAccent,
                  ),
                  _criarBotao(
                    '⌫',
                    corFundo: const Color(0xFF4E4E5A),
                    corTexto: Colors.white,
                  ),
                  _criarBotao(
                    '%',
                    corFundo: const Color(0xFF4E4E5A),
                    corTexto: Colors.white,
                  ),
                  _criarBotao(
                    '÷',
                    corFundo: Colors.orangeAccent,
                    corTexto: Colors.black,
                  ),
                ],
              ),
              Row(
                children: [
                  _criarBotao('7'),
                  _criarBotao('8'),
                  _criarBotao('9'),
                  _criarBotao(
                    '×',
                    corFundo: Colors.orangeAccent,
                    corTexto: Colors.black,
                  ),
                ],
              ),
              Row(
                children: [
                  _criarBotao('4'),
                  _criarBotao('5'),
                  _criarBotao('6'),
                  _criarBotao(
                    '-',
                    corFundo: Colors.orangeAccent,
                    corTexto: Colors.black,
                  ),
                ],
              ),
              Row(
                children: [
                  _criarBotao('1'),
                  _criarBotao('2'),
                  _criarBotao('3'),
                  _criarBotao(
                    '+',
                    corFundo: Colors.orangeAccent,
                    corTexto: Colors.black,
                  ),
                ],
              ),
              Row(
                children: [
                  _criarBotao('0', flex: 2),
                  _criarBotao(','),
                  _criarBotao(
                    '=',
                    corFundo: Colors.orangeAccent,
                    corTexto: Colors.black,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
