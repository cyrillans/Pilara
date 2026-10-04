import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Detail',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1F2937),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageCard(),
            const SizedBox(height: 20),
            _buildTitleSection(),
            const SizedBox(height: 20),
            _buildInfoCard(),
            const SizedBox(height: 20),
            _buildDescriptionCard(),
            const SizedBox(height: 24),
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: Icon(
          Icons.recycling_rounded,
          size: 90,
          color: Color(0xFF4CAF50),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Botol Plastik',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Sampah Anorganik',
          style: TextStyle(
            color: Color(0xFF4CAF50),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.category_outlined,
            title: 'Kategori',
            value: 'Anorganik',
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.stars_rounded,
            title: 'Poin',
            value: '+50 Poin',
            valueColor: const Color(0xFFFF9800),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.access_time_rounded,
            title: 'Waktu',
            value: 'Hari ini, 10:30',
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.verified_rounded,
            title: 'Status',
            value: 'Sudah Dipilah',
            valueColor: const Color(0xFF4CAF50),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF4CAF50),
            size: 21,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? const Color(0xFF1F2937),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tentang Sampah Ini',
            style: TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Botol plastik termasuk sampah anorganik yang '
            'dapat dikumpulkan dan disalurkan ke tempat '
            'pengelolaan atau daur ulang yang sesuai.',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Fitur setor sampah akan segera tersedia.',
              ),
            ),
          );
        },
        icon: const Icon(Icons.location_on_outlined),
        label: const Text(
          'Cari Lokasi Setor',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}