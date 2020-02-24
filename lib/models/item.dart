class Item {
  String title;
  bool done;

  Item({this.title, this.done}); //construtor

  Item.fromJson(Map<String, dynamic> json) {
    title = json['title']; //aqui estou pegando a propriedade title do json
    done = json['done']; //aqui estou pegando a propriedade done do json
  } //isso acima e um mapeamento

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =
        new Map<String, dynamic>(); //final é uma constante
    data['title'] = this.title;
    data['done'] = this.done;
    return data;
  }
}
