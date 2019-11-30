import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:search_cep/services/via_cep_service.dart';
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  var _searchCepController = TextEditingController();
  var _logradouroController = TextEditingController();
  var _complementoController = TextEditingController();
  var _bairroController = TextEditingController();
  var _localidadeController = TextEditingController();
  var _ufController = TextEditingController();
  var _unidadeController = TextEditingController();
  var _ibgeController = TextEditingController();
  var _giaController = TextEditingController();

  bool _loading = false;
  bool _enableField = true;
  String _result;

  @override
  void dispose() {
    super.dispose();
    _searchCepController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Consultar CEP'), actions: <Widget>[
        // action button
        IconButton(
          icon: Icon(Icons.brightness_high),
          onPressed: () {
            _changeBrightness();
          },
        ),
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () {
            Share.share('CEP: ${_searchCepController.text} \n' +
                'Logradouro: ${_logradouroController.text} \n' +
                'Bairro: ${_bairroController.text} \n' +
                'Localidade: ${_localidadeController.text} \n' +
                'UF: ${_ufController.text} \n' +
                'Complemento: ${_complementoController.text} \n' +
                'Unidade: ${_unidadeController.text} \n' +
                'IBGE: ${_ibgeController.text} \n' +
                'Gia: ${_giaController.text} \n');
          },
        ),
      ]),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildSearchCepTextField(),
                  _buildSearchCepButton(),
                  _buildResultForm()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _changeBrightness() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  RegExp re = new RegExp(r'^[0-9]');

  Widget _buildSearchCepTextField() {
    return TextFormField(
      autofocus: true,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(labelText: 'Cep'),
      controller: _searchCepController,
      enabled: _enableField,
      validator: (String arg) {
        if (arg.length != 8)
          return 'CEP deve conter 8 dígitos numéricos!';
        else if (!re.hasMatch(_searchCepController.text))
          return 'CEP deve conter apenas dígitos numéricos!';
        else
          return null;
      },
    );
  }

  Widget _buildSearchCepButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        onPressed: _searchCep,
        child: _loading ? _circularLoading() : Text('Consultar'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  void _searching(bool enable) {
    setState(() {
      _result = enable ? '' : _result;
      _loading = enable;
      _enableField = !enable;
    });
  }

  Widget _circularLoading() {
    return Container(
      height: 15.0,
      width: 15.0,
      child: CircularProgressIndicator(),
    );
  }

  Future _searchCep() async {
    _searching(true);
    _formKey.currentState.validate();
    final cep = _searchCepController.text;

    try {
      final resultCep = await ViaCepService.fetchCep(cep: cep);

      setState(() {
        _logradouroController.text = resultCep.logradouro;
        _complementoController.text = resultCep.complemento;
        _bairroController.text = resultCep.bairro;
        _localidadeController.text = resultCep.localidade;
        _ufController.text = resultCep.uf;
        _unidadeController.text = resultCep.unidade;
        _ibgeController.text = resultCep.ibge;
        _giaController.text = resultCep.gia;
      });

      _searching(false);
    } catch (error) {
      Flushbar(
        title: "Error",
        message: error.toString(),
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.red[300],
        ),
        backgroundColor: Colors.red,
        boxShadows: [
          BoxShadow(
            color: Colors.red[800],
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.red[300],
      )..show(context);
      _searching(false);
      _formKey.currentState.validate();
      return null;
    }
  }

  Widget _buildResultForm() {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Logradouro'),
            controller: _logradouroController,
            enabled: false,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Complemento'),
            controller: _complementoController,
            enabled: false,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Bairro'),
            controller: _bairroController,
            enabled: false,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Localidade'),
            controller: _localidadeController,
            enabled: false,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'UF'),
            controller: _ufController,
            enabled: false,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Unidade'),
            controller: _unidadeController,
            enabled: false,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'IBGE'),
            controller: _ibgeController,
            enabled: false,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Gia'),
            controller: _giaController,
            enabled: false,
          ),
        ],
      ),
    );
  }
}
