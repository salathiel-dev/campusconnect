import 'package:flutter/material.dart';
import '../models/produto_detalhado.dart';
import '../services/produto_service.dart';

class EditProductScreen extends StatefulWidget {
  final String produtoId;
  const EditProductScreen({super.key, required this.produtoId});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late Future<ProdutoDetalhado> _futureProduto;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _futureProduto = ProdutoService.buscarProdutoPorId(widget.produtoId);
    _futureProduto.then((produto) {
      _titleController.text = produto.titulo;
      _descriptionController.text = produto.descricao;
      _priceController.text = produto.preco.toString();
      _categoryController.text = produto.categoria;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });
      try {
        await ProdutoService.atualizarProduto(
          id: widget.produtoId,
          titulo: _titleController.text,
          descricao: _descriptionController.text,
          preco: double.parse(_priceController.text),
          categoria: _categoryController.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produto atualizado com sucesso!')),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {

      } finally {
        if (mounted) {
          setState(() { _isLoading = false; });
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Produto')),
      body: FutureBuilder<ProdutoDetalhado>(
        future: _futureProduto,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar dados do produto.'));
          }
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: 'Título')),
                  const SizedBox(height: 16),
                  TextFormField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Descrição'), maxLines: 3),
                  const SizedBox(height: 16),
                  TextFormField(controller: _priceController, decoration: const InputDecoration(labelText: 'Preço'), keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  TextFormField(controller: _categoryController, decoration: const InputDecoration(labelText: 'Categoria')),
                  const SizedBox(height: 32),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(onPressed: _submitForm, child: const Text('Salvar Alterações')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
