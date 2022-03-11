import 'dart:math';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gastos/components/chart.dart';
import 'package:gastos/controller/theme_control.dart';

import './components/transaction_form.dart';
import './components/transaction_list.dart';
import 'models/transaction.dart';
import 'package:flutter/material.dart';

main() => runApp(DespesasApp());

class DespesasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeController.instance,
      builder: (BuildContext context, child) {
        return MaterialApp(
          home: MyHomePage(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.purple,
            brightness: ThemeController.instance.isDartTheme
                ? Brightness.dark
                : Brightness.light,
            accentColor: Colors.amber,

            fontFamily: 'FiraSans',
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                    fontFamily: 'Righteous',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  button: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

            appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                    headline6: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),
            //accentColor: Colors.amber,
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    // filtrar transações
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context)
        .pop(); // fecha a janela modal - fecha o primeiro elemento da pilha
  }

  _removeTransaction(String id) {
    // função para deletar gasto
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  // Tema claro e tema escuro

  Widget _getIconButton(IconData icon, Function() fn) {
    return Platform.isIOS
        ? GestureDetector(onTap: fn, child: Icon(icon))
        : IconButton(icon: Icon(icon), onPressed: fn);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = MediaQuery.of(context).orientation ==
        Orientation.landscape; // se estiver no modo paisagem

    final actions = <Widget>[
      if (isLandscape)
        _getIconButton(
          _showChart ? Icons.list : Icons.show_chart,
          () {
            setState(() {
              _showChart = !_showChart;
            });
          },
        ),
      CustomSwitch(),
    ];

    final PreferredSizeWidget appBar = AppBar(
      title: Text('Gastos Pessoais'),
      actions: actions,
    );

    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top; // subtrair o tamanho do appBar

    final bodyPage = SafeArea(
      // garante que os componentes não invadam áreas indesejadas no dispositivo

      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            /* if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Exibir Gráfico'),
                  Switch(
                    value: _showChart,
                    onChanged: (value) {
                      setState(() {
                        _showChart =
                            value; // semque que o switch mudar passa o novo valor
                      });
                    },
                  ),
                ],
              ),*/
            if (_showChart || !isLandscape) // se for verdadeiro
              Container(
                height: availableHeight *
                    (isLandscape ? 0.8 : 0.3), //80% - 30% da tela
                child: Chart(_recentTransactions),
              ),
            if (!_showChart || !isLandscape) //se for falso
              Container(
                height: availableHeight *
                    (isLandscape
                        ? 1
                        : 0.3), // altura disponível multiplicado por 0.6
                child: TransactionList(_transactions, _removeTransaction),
              ), //comunicação direta
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('Meus Gastos'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: actions),
            ),
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton:
                Platform.isIOS // verifica se o dispositivo é IOS
                    ? Container()
                    : FloatingActionButton(
                        child: Icon(Icons.add),
                        onPressed: () => _openTransactionFormModal(context),
                      ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}

class CustomSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoSwitch(
            value: ThemeController.instance.isDartTheme,
            onChanged: (value) {
              ThemeController.instance.changeTheme();
            },
          )
        : Switch(
            value: ThemeController.instance.isDartTheme,
            onChanged: (value) {
              ThemeController.instance.changeTheme();
            },
          );
  }
}



/**        style: TextStyle(
          fontSize: 20 *
              MediaQuery.of(context)
                  .textScaleFactor, // permite que os textos cresçam de aconto com o dispositivo do usuário
        ), */