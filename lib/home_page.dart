import 'package:flutter/material.dart';
import 'travel_service.dart';
import 'markdown_formatter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  String _resposta = '';
  bool _carregando = false;

  Future<void> _consultarDestino() async {
    final destino = _controller.text.trim();
    if (destino.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite um destino turístico'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _carregando = true);
    try {
      final prompt =
          'Quero saber sobre pontos turísticos, cultura local e dicas de viagem para $destino. Forneça informações detalhadas.';
      final resposta = await getTravelInfo(prompt);
      setState(() => _resposta = resposta);
    } catch (e) {
      setState(() => _resposta = 'Erro: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ocorreu um erro: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Assistente de Viagens',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF1A73E8),
                      const Color(0xFF6AB7FF),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.travel_explore,
                    size: 80,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Para onde você deseja viajar?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Digite o nome da cidade ou país para descobrir mais informações.',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Destino',
                      hintText: 'Ex: Paris, Tóquio, Machu Picchu...',
                      prefixIcon: const Icon(Icons.place),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _controller.clear(),
                      ),
                    ),
                    onSubmitted: (_) => _consultarDestino(),
                    textInputAction: TextInputAction.search,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _carregando ? null : _consultarDestino,
                      icon: const Icon(Icons.search),
                      label: Text(_carregando
                          ? 'Consultando...'
                          : 'Buscar informações'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_carregando)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            'Buscando informações sobre o destino...',
                            style:
                                TextStyle(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    )
                  else if (_resposta.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.map,
                            size: 64,
                            color: isDark
                                ? Colors.grey.shade500
                                : Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Seu guia de viagem personalizado',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Digite um destino acima e descubra pontos turísticos, cultura local e dicas de viagem.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isDark
                              ? Colors.grey.shade700
                              : Colors.grey.shade200,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.info_outline),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Informações sobre ${_controller.text}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 32),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  color: colorScheme.onSurface,
                                  height: 1.6,
                                ),
                                children:
                                    MarkdownFormatter.formatText(_resposta),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
