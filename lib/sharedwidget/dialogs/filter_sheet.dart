import 'package:flutter/material.dart';

class ReusableFilterSheet extends StatefulWidget {
  final List<String> categories;
  final List<String> brands;
  final void Function(List<String> selectedCategories, List<String> selectedBrands, double? priceMin, double? priceMax)? onApply;

  const ReusableFilterSheet({Key? key, this.categories = const [], this.brands = const [], this.onApply}) : super(key: key);

  @override
  State<ReusableFilterSheet> createState() => _ReusableFilterSheetState();
}

class _ReusableFilterSheetState extends State<ReusableFilterSheet> {
  final Set<String> _selectedCategories = {};
  final Set<String> _selectedBrands = {};
  double? _minPrice;
  double? _maxPrice;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Filter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () { setState(() { _selectedCategories.clear(); _selectedBrands.clear(); _minPrice = null; _maxPrice = null; }); }, child: Text('Reset')),
          ]),
          if (widget.categories.isNotEmpty) ...[
            Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.symmetric(vertical:8), child: Text('Categories'))),
            Wrap(spacing:8, children: widget.categories.map((c) => FilterChip(label: Text(c), selected: _selectedCategories.contains(c), onSelected: (s)=> setState(()=> s? _selectedCategories.add(c): _selectedCategories.remove(c)))).toList()),
          ],
          if (widget.brands.isNotEmpty) ...[
            Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.symmetric(vertical:8), child: Text('Brands'))),
            Wrap(spacing:8, children: widget.brands.map((b) => FilterChip(label: Text(b), selected: _selectedBrands.contains(b), onSelected: (s)=> setState(()=> s? _selectedBrands.add(b): _selectedBrands.remove(b)))).toList()),
          ],
          Padding(padding: EdgeInsets.symmetric(vertical:8), child: Row(children: [
            Expanded(child: TextField(decoration: InputDecoration(labelText: 'Min price'), keyboardType: TextInputType.number, onChanged: (v)=> _minPrice = double.tryParse(v))),
            SizedBox(width:8),
            Expanded(child: TextField(decoration: InputDecoration(labelText: 'Max price'), keyboardType: TextInputType.number, onChanged: (v)=> _maxPrice = double.tryParse(v))),
          ])),
          SizedBox(height:8),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            TextButton(onPressed: ()=> Navigator.of(context).pop(), child: Text('Cancel')),
            ElevatedButton(onPressed: (){
              widget.onApply?.call(_selectedCategories.toList(), _selectedBrands.toList(), _minPrice, _maxPrice);
              Navigator.of(context).pop();
            }, child: Text('Apply')),
          ])
        ]),
      ),
    );
  }
}
