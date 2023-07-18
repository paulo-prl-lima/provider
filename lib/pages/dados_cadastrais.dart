import 'package:flutter/material.dart';
import 'package:provider/shared/text_label.dart';
import 'package:provider/repositories/nivel_repository.dart';
import 'package:provider/repositories/servicos_repository.dart';

class DadosCadastraisPage extends StatefulWidget {
  const DadosCadastraisPage({super.key});

  @override
  State<DadosCadastraisPage> createState() => _DadosCadastraisPageState();
}

class _DadosCadastraisPageState extends State<DadosCadastraisPage> {
  var nomeController = TextEditingController(text: "");
  var dataNascimentoController = TextEditingController(text: "");
  DateTime? dataNascimento;
  var nivelRepository = NivelRepository();
  var linguagensRepository = ServicosRepository();
  var niveis = [];
  var linguagens = [];
  var linguagensSelecionadas = [];
  var nivelSelecionado = "";
  double valor = 0;
  int tempoExperiencia = 0;

  bool salvando = false;

  @override
  void initState() {
    niveis = nivelRepository.retornaNiveis();
    linguagens = linguagensRepository.retornaServicos();
    super.initState();
  }

  List<DropdownMenuItem<int>> returnItens(int quantidadeMaxima) {
    var itens = <DropdownMenuItem<int>>[];
    for (var i = 0; i <= quantidadeMaxima; i++) {
      itens.add(DropdownMenuItem(
        value: i,
        child: Text(i.toString()),
      ));
    }
    return itens;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Provedor")),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: salvando
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  const TextLAbel(texto: "Nome"),
                  TextField(
                    controller: nomeController,
                  ),
                  const TextLAbel(texto: "Tipo de cobrança"),
                  Column(
                      children: niveis
                          .map((nivel) => RadioListTile(
                                dense: true,
                                title: Text(nivel),
                                selected: nivelSelecionado == nivel,
                                value: nivel,
                                groupValue: nivelSelecionado,
                                onChanged: (value) {
                                  //print(value);
                                  setState(() {
                                    nivelSelecionado = value;
                                  });
                                },
                              ))
                          .toList()),
                  const TextLAbel(texto: "Serviços"),
                  Column(
                    children: linguagens
                        .map(
                          (linguagem) => CheckboxListTile(
                            dense: true,
                            title: Text(linguagem),
                            value: linguagensSelecionadas.contains(linguagem),
                            onChanged: (bool? value) {
                              if (value!) {
                                setState(() {
                                  linguagensSelecionadas.add(linguagem);
                                });
                              } else {
                                setState(() {
                                  linguagensSelecionadas.remove(linguagem);
                                });
                              }
                              setState(() {});
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const TextLAbel(texto: "Tempo de experiência"),
                  DropdownButton(
                      value: tempoExperiencia,
                      isExpanded: true,
                      items: returnItens(50),
                      onChanged: (value) {
                        setState(() {
                          tempoExperiencia = int.parse(value.toString());
                        });
                      }),
                  TextLAbel(
                      texto: "Informe Valor. R\$ ${valor.round().toString()}"),
                  Slider(
                      min: 0,
                      max: 10000,
                      value: valor,
                      onChanged: (double value) {
                        setState(() {
                          valor = value;
                        });
                      }),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        salvando = false;
                      });
                      if (nomeController.text.trim().length < 3) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Nome deve ser preenchido"),
                          ),
                        );
                        return;
                      }

                      if (nivelSelecionado.trim() == '') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Selecione o tipo de cobrança"),
                          ),
                        );
                        return;
                      }

                      if (linguagensSelecionadas.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Selecione ao menos um servrço"),
                          ),
                        );
                        return;
                      }

                      if (tempoExperiencia == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Deve ter ao menos um ano de experiência"),
                          ),
                        );
                        return;
                      }

                      if (valor == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Informe um valor válido"),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        salvando = true;
                      });
                      Future.delayed(
                        const Duration(seconds: 2),
                        () => {
                          setState(
                            () {
                              salvando = false;
                            },
                          ),
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Dados salvo com sucesso"),
                            ),
                          ),
                          Navigator.pop(context),
                        },
                      );

                      debugPrint("Dados salvo com sucesso");
                    },
                    child: const Text("Salvar"),
                  ),
                ],
              ),
      ),
    );
  }
}
