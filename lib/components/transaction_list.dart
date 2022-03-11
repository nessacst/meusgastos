import 'package:flutter/material.dart';
import 'package:gastos/components/transaction_card.dart';
import '../models/transaction.dart';
import './transaction_card.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) onRemove;

  TransactionList(this.transactions, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty // se tiver vazio
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'Sem gastos, parabéns!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 20),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/img.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView(
            children: transactions.map((tr) {
              return TransactionItem(
                key: ValueKey(tr.id),
                tr: tr,
                onRemove: onRemove,
              );
            }).toList(),
          );
    // : ListView.builder(
    //     // se não tiver vazio
    //     itemCount: transactions.length,
    //     itemBuilder: (ctx, index) {
    //       final tr = transactions[index];
    //       return TransactionItem(
    //         tr: tr,
    //         onRemove: onRemove,
    //       );
    //     },
    //   );
  }
}
