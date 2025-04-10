import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sistema_animales/core/constants.dart';
import 'package:sistema_animales/models/animal_model.dart';
import 'package:sistema_animales/models/transfer_model.dart';
import 'package:sistema_animales/servicess/transfer_service.dart';
import 'transfer_form_screen.dart';

class TransferListScreen extends StatefulWidget {
  final Animal animal;

  const TransferListScreen({super.key, required this.animal});

  @override
  State<TransferListScreen> createState() => _TransferListScreenState();
}

class _TransferListScreenState extends State<TransferListScreen> {
  final TransferService _transferService = TransferService();
  Transfer? _transfer;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTransfer();
  }

  Future<void> _loadTransfer() async {
    try {
      final transfers = await _transferService.getAll();
      final matching = transfers.firstWhere(
        (t) => t.animalId == widget.animal.id.toString(),
        orElse: () => Transfer(
          animalId: widget.animal.id.toString(),
          fechaTraslado: DateTime.now(),
        ),
      );

      setState(() {
        _transfer = matching;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  String _formatDate(DateTime? date) =>
      date != null ? DateFormat.yMMMd().format(date) : '-';

  String _formatTime(DateTime? date) =>
      date != null ? DateFormat.jm().format(date) : '-';

  Widget _buildRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 4,
              child: Text(
                '$label:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
          Expanded(
              flex: 6,
              child: Text(
                value?.isNotEmpty == true ? value! : '-',
                style: const TextStyle(color: Colors.black54),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/background2.jpg', fit: BoxFit.cover),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 50, left: 20, right: 20, bottom: 16),
                color: AppColors.primary,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Historial de Traslados y Seguimiento',
                        style: AppTextStyles.heading.copyWith(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(child: Text('Error: $_error'))
                        : Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12, blurRadius: 6),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildRow('Ubicación anterior',
                                          _transfer?.ubicacionAnterior),
                                      _buildRow('Ubicación nueva',
                                          _transfer?.ubicacionNueva),
                                      _buildRow('Motivo del traslado',
                                          _transfer?.motivo),
                                      _buildRow('Observaciones',
                                          _transfer?.observaciones),
                                      const SizedBox(height: 12),
                                      const Text('Fecha de traslado:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        children: [
                                          Text(
                                              _formatDate(
                                                  _transfer?.fechaTraslado),
                                              style: const TextStyle(
                                                  color: Colors.blue)),
                                          const SizedBox(width: 10),
                                          Text(
                                              _formatTime(
                                                  _transfer?.fechaTraslado),
                                              style: const TextStyle(
                                                  color: Colors.blue)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TransferFormScreen(
                                            animal: widget.animal),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text('Agregar Traslado'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
